# 05-tools.zsh — Tool integrations (fzf, zoxide, atuin, keychain)

# Shell integrations
[[ -t 1 ]] && eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# Atuin
[ -f "$HOME/.atuin/bin/env" ] && . "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"

# Keychain
eval $(keychain --quiet --agents ssh --eval id_ed25519 2>/dev/null || keychain -q --eval id_ed25519)

# opencode
export PATH=$HOME/.opencode/bin:$PATH

# GPG
export GPG_TTY=$(tty)

# Local bin env
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
