# Trampoline: switch to zsh when available (interactive shells only).
# Handles environments where chsh is unavailable (containers, VMs, etc.).
# The interactive check ([[ $- == *i* ]]) prevents breaking non-interactive
# bash invocations (scripts, bash -c, tool integrations, etc.).
if [[ $- == *i* ]] && command -v zsh >/dev/null 2>&1 && [ -z "$ZSH_VERSION" ]; then
  exec zsh -l
fi
