#!/bin/bash

# Read JSON input from stdin; extract all values in a single jq call
input=$(cat)
IFS=$'\t' read -r model cwd used_pct session_name <<< "$(jq -r '[
    (.model.display_name // "Claude"),
    (.workspace.current_dir // .cwd),
    (.context_window.used_percentage // 0 | floor | tostring),
    (.session_name // "")
  ] | @tsv' <<< "$input")"

# Get git branch + dirty status in minimal git calls
git_info=""
if branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null); then
  if [ -n "$(git -C "$cwd" --no-optional-locks status --porcelain -uno 2>/dev/null)" ]; then
    git_info=" (${branch}*)"
  else
    git_info=" (${branch})"
  fi
fi

# Build entire status line in a single printf
out="\033[36m${cwd##*/}\033[0m${git_info} \033[90m│\033[0m \033[35m${model}\033[0m \033[90m│\033[0m \033[33m${used_pct}%\033[0m"
if [ -n "$session_name" ]; then
  out+=" \033[90m│\033[0m \033[32m${session_name}\033[0m"
fi
printf '%b\n' "$out"
