# 06-hooks.zsh — chpwd hooks

# Auto-enable virtualenv in Python projects
function auto_venv() {
  # If already in a virtualenv, do nothing
  if [[ -n "$VIRTUAL_ENV" && "$PWD" != *"${VIRTUAL_ENV:h}"* ]]; then
    command -v deactivate >/dev/null && deactivate
    return
  fi

  [[ -n "$VIRTUAL_ENV" ]] && return

  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    if [[ -f "$dir/.venv/bin/activate" ]]; then
      source "$dir/.venv/bin/activate"
      return
    fi
    dir="${dir:h}"
  done
}

# List files after cd
function listfiles_dir() {
    ls
}

# Register hooks
autoload -Uz add-zsh-hook
add-zsh-hook chpwd auto_venv
add-zsh-hook chpwd listfiles_dir

# Edit command line in editor
# zsh-vi-mode uses lazy keybindings and claims 'v' for visual mode;
# bind AFTER zvm applies its binds so ours wins, with plain fallback.
autoload -Uz edit-command-line && zle -N edit-command-line
function _bind_edit_command_line() { bindkey -M vicmd 'v' edit-command-line }
if (( $+functions[zvm_after_lazy_keybindings] )); then
  zvm_after_lazy_keybindings _bind_edit_command_line
else
  _bind_edit_command_line
fi

# Expand history expressions with space
bindkey ' ' magic-space