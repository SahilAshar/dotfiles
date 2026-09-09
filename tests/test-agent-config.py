#!/usr/bin/env python3
"""Isolated tests: execute the real bootstrap, never a live harness CLI."""
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import tomllib
import unittest

ROOT = Path(__file__).resolve().parent.parent


class BootstrapTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.base = Path(self.temp.name).resolve()
        self.home = self.base / "home with spaces"
        self.home.mkdir()
        self.repo = self.base / "repo with spaces"
        for name in ("pi", "herdr", "scripts"):
            shutil.copytree(ROOT / name, self.repo / name)
        shutil.copy(ROOT / "install-herdr-skill.sh", self.repo)
        self.skill = self.repo / ".claude/skills/herdr"
        self.skill.mkdir(parents=True)
        shutil.copy(ROOT / ".claude/skills/herdr/SKILL.md", self.skill)
        (self.repo / ".claude/skills/broken").symlink_to(self.base / "missing")
        self.bin = self.base / "bin"
        self.bin.mkdir()
        # Block all external tooling except the two prerequisites.
        for name in ("python3", "dirname"):
            (self.bin / name).symlink_to(shutil.which(name))
        for name in ("herdr", "pi", "curl", "git", "npm", "sudo"):
            stub = self.bin / name
            stub.write_text(f'#!/bin/sh\necho called >> "{self.base}/cli-calls"\nexit 99\n')
            stub.chmod(0o755)
        self.env = {"HOME": str(self.home), "PATH": str(self.bin)}
        self.settings = self.home / ".pi/agent/settings.json"
        self.keys = self.settings.with_name("keybindings.json")
        self.herdr = self.home / ".config/herdr/config.toml"

    def write(self, path, text):
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text)

    def run_bootstrap(self, *args, ok=True):
        result = subprocess.run(
            [shutil.which("bash"), str(self.repo / "install-herdr-skill.sh"), *args],
            env=self.env, capture_output=True, text=True,
        )
        self.assertEqual(result.returncode == 0, ok, result.stdout + result.stderr)
        self.assertFalse((self.base / "cli-calls").exists())
        return result

    def test_fresh_and_idempotent(self):
        self.run_bootstrap("--pi", "--herdr", "--claude-skills")
        self.assertEqual(json.loads(self.settings.read_text()), json.loads((ROOT / "pi/settings.json").read_text()))
        self.assertEqual(tomllib.loads(self.herdr.read_text()), tomllib.loads((ROOT / "herdr/config.toml").read_text()))
        self.assertEqual((self.home / ".claude/skills/herdr").resolve(), self.skill)
        self.assertFalse((self.home / ".claude/skills/broken").exists())
        self.assertFalse((self.home / ".agents").exists())
        times = [p.stat().st_mtime_ns for p in (self.settings, self.keys, self.herdr)]
        self.run_bootstrap("--pi", "--herdr", "--claude-skills")
        self.assertEqual(times, [p.stat().st_mtime_ns for p in (self.settings, self.keys, self.herdr)])
        self.assertFalse(list(self.home.rglob("*.bak")))
        self.assertFalse((self.home / ".pi/agent/extensions").exists())

    def test_json_additive_merge_backup_and_unrelated_keys(self):
        old = '{"skills":["~/my-skills"],"compaction":{"keepRecentTokens":1234}}\n'
        self.write(self.settings, old)
        self.write(self.keys, '{"app.session.new":"ctrl+alt+n"}')
        self.run_bootstrap("--pi")
        data = json.loads(self.settings.read_text())
        self.assertEqual(data["skills"], ["~/my-skills", "~/.claude/skills"])
        self.assertEqual(data["compaction"], {"keepRecentTokens": 1234})
        self.assertEqual(Path(str(self.settings) + ".dotfiles.bak").read_text(), old)
        self.assertEqual(json.loads(self.keys.read_text())["app.session.new"], "ctrl+alt+n")
        self.run_bootstrap("--pi")

    def test_conflicts_preflight_all_resources(self):
        for path, text in [(self.settings, '{"theme":"light"}'), (self.keys, '{"app.model.select":"ctrl+m"}'), (self.herdr, '[ui]\nagent_panel_sort="priority"\n')]:
            with self.subTest(path=path):
                self.write(path, text)
                self.run_bootstrap("--pi", "--herdr", "--claude-skills", ok=False)
                self.assertEqual(path.read_text(), text)
                self.assertFalse((self.home / ".claude").exists())
                path.unlink()
                self.assertFalse(self.settings.exists())
                self.assertFalse(self.keys.exists())

    def test_preserves_safety_preferences_on_conflict(self):
        for text in ('{"warnings":{"anthropicExtraUsage":false}}', '{"defaultProjectTrust":"always"}'):
            self.write(self.settings, text)
            self.run_bootstrap("--pi", ok=False)
            self.assertEqual(self.settings.read_text(), text)

    def test_existing_toml_subset_untouched(self):
        text = (ROOT / "herdr/config.toml").read_text() + '\n[terminal]\nnew_cwd="follow" # preserve comment\n'
        self.write(self.herdr, text)
        self.run_bootstrap("--herdr")
        self.assertEqual(self.herdr.read_text(), text)

    def test_missing_toml_preferences_require_manual_merge(self):
        self.write(self.herdr, '[ui]\nagent_panel_sort="spaces"\n')
        old = self.herdr.read_bytes()
        self.run_bootstrap("--herdr", ok=False)
        self.assertEqual(self.herdr.read_bytes(), old)

    def test_invalid_formats(self):
        for path, args, text in [(self.settings, ("--pi",), "[]"), (self.settings, ("--pi",), "not json"), (self.herdr, ("--herdr",), "[broken"), (self.settings, ("--pi",), '{"skills":"wrong"}')]:
            self.write(path, text)
            self.run_bootstrap(*args, ok=False)
            self.assertEqual(path.read_text(), text)
            path.unlink()

    def test_duplicate_keys_and_nonfinite_json_refused(self):
        for text in ('{"theme":"dark","theme":"light"}', '{"unrelated":NaN}'):
            self.write(self.settings, text)
            self.run_bootstrap("--pi", ok=False)
            self.assertEqual(self.settings.read_text(), text)

    def test_overlapping_destinations_refused(self):
        self.env["HERDR_CONFIG_PATH"] = str(self.settings)
        self.run_bootstrap("--pi", "--herdr", ok=False)
        self.assertFalse(self.settings.exists())

    def test_backup_destination_overlap_refused_before_writes(self):
        for suffix in ("", "/config.toml"):
            with self.subTest(suffix=suffix):
                self.write(self.settings, "{}")
                backup = Path(str(self.settings) + ".dotfiles.bak")
                self.env["HERDR_CONFIG_PATH"] = str(backup) + suffix
                self.run_bootstrap("--pi", "--herdr", ok=False)
                self.assertEqual(self.settings.read_text(), "{}")
                self.assertFalse(backup.exists())
                self.assertFalse(self.keys.exists())

    def test_backup_collision(self):
        self.write(self.settings, "{}")
        backup = Path(str(self.settings) + ".dotfiles.bak")
        backup.symlink_to(self.base / "missing")
        self.run_bootstrap("--pi", ok=False)
        self.assertEqual(self.settings.read_text(), "{}")
        self.assertTrue(backup.is_symlink())

    def test_file_symlink_directory_and_hardlink_collisions(self):
        target = self.base / "target"
        target.write_text("{}")
        self.settings.parent.mkdir(parents=True)
        self.settings.symlink_to(target)
        self.run_bootstrap("--pi", ok=False)
        self.settings.unlink()
        os.link(target, self.settings)
        self.run_bootstrap("--pi", ok=False)
        self.settings.unlink()
        self.settings.mkdir()
        self.run_bootstrap("--pi", ok=False)
        self.assertEqual(target.read_text(), "{}")

    def test_parent_symlink(self):
        redirected = self.base / "redirected"
        redirected.mkdir()
        (self.home / ".pi").symlink_to(redirected)
        self.run_bootstrap("--pi", ok=False)
        self.assertEqual(list(redirected.iterdir()), [])

    def test_path_overrides(self):
        pi = self.base / "custom pi"
        herdr = self.base / "custom herdr/preferences.toml"
        self.env.update(PI_CODING_AGENT_DIR=str(pi), HERDR_CONFIG_PATH=str(herdr))
        self.run_bootstrap("--pi", "--herdr")
        self.assertTrue((pi / "settings.json").is_file())
        self.assertTrue(herdr.is_file())
        self.assertFalse(self.settings.exists())
        self.assertFalse(self.herdr.exists())

    def test_unsafe_overrides_and_unknown_flags(self):
        for path in ("relative/config.toml", str(self.repo / "herdr/config.toml")):
            self.env["HERDR_CONFIG_PATH"] = path
            self.run_bootstrap("--herdr", ok=False)
        self.run_bootstrap("--pi", "--shared", ok=False)
        self.env["CLAUDE_CONFIG_DIR"] = str(self.base / "custom claude")
        self.run_bootstrap("--pi", "--claude-skills", ok=False)
        self.assertFalse(self.settings.exists())

    def test_skill_collision_and_shared_duplicate(self):
        self.write(self.home / ".claude/skills/herdr", "keep")
        self.run_bootstrap("--pi", "--claude-skills", ok=False)
        self.assertFalse(self.settings.exists())
        shared = self.home / ".agents/skills/herdr"
        shared.parent.mkdir(parents=True)
        shared.symlink_to(self.base / "missing")
        self.run_bootstrap("--pi", ok=False)
        self.assertTrue(shared.is_symlink())

    def test_tracked_preferences_are_portable(self):
        settings = json.loads((ROOT / "pi/settings.json").read_text())
        self.assertEqual(set(settings), {"defaultProvider", "defaultModel", "theme", "skills", "defaultProjectTrust", "warnings"})
        self.assertEqual(settings["skills"], ["~/.claude/skills"])
        self.assertTrue(settings["warnings"]["anthropicExtraUsage"])
        herdr = tomllib.loads((ROOT / "herdr/config.toml").read_text())
        self.assertNotIn("onboarding", herdr)
        self.assertTrue(herdr["ui"]["confirm_close"])
        self.assertNotIn("/Users/", (ROOT / "pi/settings.json").read_text())


if __name__ == "__main__":
    unittest.main(verbosity=2)
