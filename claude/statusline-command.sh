#!/usr/bin/env bash
set -euo pipefail
# Claude Code status line - mirroring Powerlevel10k lean prompt from ~/.p10k.zsh
#
# Layout: <dir> <git-branch +staged !unstaged ?untracked>   <time>   [model]
#
# Colors match p10k config:
#   dir anchor:  color 39  bold (bright blue)
#   git clean:   color 76  (green)
#   git modified:color 178 (yellow)
#   git untrack: color 39  (blue)
#   time:        color 66  (muted teal, per p10k default)

input=$(cat)
if command -v jq >/dev/null 2>&1; then
    cwd=$(jq -r '.cwd' <<<"$input")
    model=$(jq -r '.model.display_name // empty' <<<"$input")
else
    cwd="${PWD:-$HOME}"
    model=""
fi

# --- ANSI helpers (256-color) ---
c()  { printf "\033[38;5;%sm" "$1"; }  # foreground color N
rs() { printf "\033[0m"; }              # reset

dir_anchor="\033[1m$(c 39)"
git_clean="$(c 76)"
git_mod="$(c 178)"
git_untrack="$(c 39)"
time_color="$(c 66)"
reset="$(rs)"

# --- Directory: replace $HOME with ~ ---
display_cwd="${cwd/#$HOME/\~}"

# --- Git status (using --no-optional-locks to avoid lock contention) ---
git_part=""
if git --no-optional-locks -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
    branch="$(git --no-optional-locks -C "$cwd" symbolic-ref --short HEAD 2>/dev/null \
        || git --no-optional-locks -C "$cwd" rev-parse --short HEAD 2>/dev/null)"

    if [ -n "${branch:-}" ]; then
        git_part=" ${git_clean}${branch}${reset}"
    fi

    # Staged (+), unstaged (!), untracked (?)
    staged=$(git --no-optional-locks -C "$cwd" diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')
    unstaged=$(git --no-optional-locks -C "$cwd" diff --name-only 2>/dev/null | wc -l | tr -d ' ')
    untracked=$(git --no-optional-locks -C "$cwd" ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')

    [ "$staged"    -gt 0 ] && git_part="${git_part} ${git_mod}+${staged}${reset}"
    [ "$unstaged"  -gt 0 ] && git_part="${git_part} ${git_mod}!${unstaged}${reset}"
    [ "$untracked" -gt 0 ] && git_part="${git_part} ${git_untrack}?${untracked}${reset}"
fi

# --- Time (12h format, matching p10k wizard "12h time" option) ---
time_str="$(date +%I:%M%p | sed 's/^0//')"

# --- Model (right-side extra, in muted grey) ---
model_part=""
if [ -n "$model" ]; then
    model_part="   $(c 244)[${model}]${reset}"
fi

printf "%b%s%s%s   %s%s%s%s\n" \
    "$dir_anchor" "$display_cwd" "$reset" \
    "$git_part" \
    "$time_color" "$time_str" "$reset" \
    "$model_part"
