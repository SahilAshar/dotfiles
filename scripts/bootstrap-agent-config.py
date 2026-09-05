#!/usr/bin/env python3
"""Opt-in preference deployment. Python 3.11+ supplies a strict TOML reader."""
import argparse
import json
import os
from pathlib import Path
import sys
import tempfile

if sys.version_info < (3, 11):
    sys.exit("Python 3.11+ required; no dependencies are installed automatically.")
import tomllib

ROOT = Path(__file__).resolve().parent.parent


def safe_path(path):
    """Never follow user-config symlinks or replace non-regular files."""
    for parent in path.parents:
        if parent.is_symlink() or (parent.exists() and not parent.is_dir()):
            raise ValueError(f"Resolve redirected/non-directory parent manually: {parent}")
    if path.is_symlink() or (path.exists() and not path.is_file()):
        raise ValueError(f"Resolve existing non-regular destination manually: {path}")
    if path.exists() and path.stat().st_nlink != 1:
        raise ValueError(f"Resolve hard-linked destination manually: {path}")


def destination(value):
    path = Path(os.path.expanduser(value))
    if not path.is_absolute() or ".." in path.parts:
        raise ValueError("Config overrides must be absolute paths (or start with ~/).")
    if path == ROOT or ROOT in path.parents:
        raise ValueError("Config destination must not be inside the source checkout.")
    return path


def unique_object(pairs):
    result = {}
    for key, value in pairs:
        if key in result:
            raise ValueError("Duplicate JSON key")
        result[key] = value
    return result


def invalid_constant(_value):
    raise ValueError("Non-finite JSON number")


def parse(raw, kind):
    try:
        data = (json.loads(raw, object_pairs_hook=unique_object, parse_constant=invalid_constant)
                if kind == "json" else tomllib.loads(raw.decode()))
    except (ValueError, UnicodeError):
        raise ValueError(f"Invalid {kind} config; resolve manually (contents withheld).") from None
    if not isinstance(data, dict):
        raise ValueError(f"Expected a {kind} object/table.")
    return data


def merge(existing, desired, path="", fill=True):
    """Fill missing JSON keys; union skill paths only. Conflicts never overwrite."""
    result = dict(existing)
    for key, value in desired.items():
        label = f"{path}.{key}" if path else key
        if key not in existing:
            if not fill:
                raise ValueError(f"Missing TOML preference {label}; merge template manually.")
            result[key] = value
        elif isinstance(value, dict) and isinstance(existing[key], dict):
            result[key] = merge(existing[key], value, label, fill)
        elif label == "skills" and fill:
            if not isinstance(existing[key], list) or not all(isinstance(x, str) for x in existing[key]):
                raise ValueError("Existing skills must be an array of paths.")
            result[key] = existing[key] + [x for x in value if x not in existing[key]]
        elif type(existing[key]) is not type(value) or existing[key] != value:
            raise ValueError(f"Conflicting preference {label}; resolve manually (values withheld).")
    return result


def config_plan(src, dest, kind):
    safe_path(dest)
    desired_raw = src.read_bytes()
    desired = parse(desired_raw, kind)
    old = dest.read_bytes() if dest.exists() else None
    new = desired_raw
    if old is not None:
        current = parse(old, kind)
        merged = merge(current, desired, fill=kind == "json")
        if merged == current:
            return None  # Preserve formatting, permissions and mtime on reruns.
        new = (json.dumps(merged, indent=2) + "\n").encode()
        backup = Path(str(dest) + ".dotfiles.bak")
        if backup.exists() or backup.is_symlink():
            raise ValueError(f"Backup exists; resolve manually: {backup}")
    return dest, old, new


def apply_config(plan):
    dest, old, new = plan
    safe_path(dest)
    if (dest.read_bytes() if dest.exists() else None) != old:
        raise ValueError(f"Config changed during preflight; retry with tools closed: {dest}")
    dest.parent.mkdir(parents=True, exist_ok=True)
    if old is None:
        # Exclusive create: never truncate a concurrently created file.
        fd = os.open(dest, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600)
        with os.fdopen(fd, "wb") as out:
            out.write(new)
    else:
        backup = Path(str(dest) + ".dotfiles.bak")
        fd = os.open(backup, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600)
        with os.fdopen(fd, "wb") as out:
            out.write(old)
        fd, temp = tempfile.mkstemp(dir=dest.parent, prefix=".dotfiles-")
        try:
            with os.fdopen(fd, "wb") as out:
                out.write(new)
            os.chmod(temp, dest.stat().st_mode & 0o777)
            os.replace(temp, dest)
        finally:
            if os.path.exists(temp):
                os.unlink(temp)
    print(f"Configured: {dest}")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for flag in ("pi", "herdr", "claude-skills"):
        parser.add_argument(f"--{flag}", action="store_true")
    args = parser.parse_args()
    if not any(vars(args).values()):
        parser.error("Select --pi, --herdr and/or --claude-skills")
    if not os.environ.get("HOME"):
        raise ValueError("HOME must be set.")
    home = Path(os.environ["HOME"]).resolve()
    plans, links = [], []
    if args.pi:
        shared = home / ".agents/skills/herdr"
        if shared.exists() or shared.is_symlink():
            raise ValueError("Shared Herdr exposure exists; review/remove that link manually before --pi (duplicate skill names).")
        pi = destination(os.environ.get("PI_CODING_AGENT_DIR") or str(home / ".pi/agent"))
        for filename in ("settings.json", "keybindings.json"):
            plans.append(config_plan(ROOT / "pi" / filename, pi / filename, "json"))
    if args.herdr:
        dest = destination(os.environ.get("HERDR_CONFIG_PATH") or str(home / ".config/herdr/config.toml"))
        plans.append(config_plan(ROOT / "herdr/config.toml", dest, "toml"))
    if args.claude_skills:
        # Pi's tracked path is deliberately fixed; no machine-specific paths in JSON.
        claude = os.environ.get("CLAUDE_CONFIG_DIR")
        if claude and Path(os.path.expanduser(claude)) != home / ".claude":
            raise ValueError("Custom CLAUDE_CONFIG_DIR: deploy skills and adjust Pi path manually.")
        for src in sorted((ROOT / ".claude/skills").iterdir()):
            if src.is_symlink() or not (src / "SKILL.md").is_file():
                print(f"Skipping non-canonical skill entry: {src.name}")
                continue
            dest = home / ".claude/skills" / src.name
            if dest.is_symlink() and os.readlink(dest).rstrip("/") == str(src):
                # Still validate ancestors of an already-correct link.
                safe_path(dest.parent / ".dotfiles-preflight")
                continue
            safe_path(dest)
            if dest.exists():
                raise ValueError(f"Existing skill left untouched: {dest}")
            links.append((src, dest))
    # Reject overlapping destinations selected via overrides before any writes.
    targets = [plan[0] for plan in plans if plan] + [dest for _, dest in links]
    for index, target in enumerate(targets):
        for other in targets[index + 1:]:
            if target == other or target in other.parents or other in target.parents:
                raise ValueError("Selected destinations overlap; resolve config overrides manually.")
    # Preflight all selected resources before changing any file.
    for plan in plans:
        if plan:
            apply_config(plan)
    for src, dest in links:
        safe_path(dest)
        dest.parent.mkdir(parents=True, exist_ok=True)
        dest.symlink_to(src)
        print(f"Linked skill: {dest}")
    print("Complete. No CLI, integration, authentication or service commands executed.")


if __name__ == "__main__":
    try:
        main()
    except (ValueError, OSError) as error:
        sys.exit(f"ERROR: {error}")
