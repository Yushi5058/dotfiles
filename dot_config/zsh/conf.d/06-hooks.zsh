# 06-hooks.zsh — chpwd hooks

# Auto-enable virtualenv in Python projects
function auto_venv() {
  # If already in a virtualenv, do nothing
  if [[ -n "$VIRTUAL_ENV" && "$PWD" != *"${VIRTUAL_ENV:h}"* ]]; then
    deactivate
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
autoload -Uz edit-command-line && zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

# Expand history expressions with space
bindkey ' ' magic-space