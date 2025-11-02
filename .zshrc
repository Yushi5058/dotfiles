# alias 
alias ls="eza -a --icons"
alias home="cd ~"
alias c="clear"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gs="git status"
alias gd="git diff"

# Add local binaries to PATH
export PATH="$HOME/.local/bin:$PATH"

# ~/.zshrc
eval "$(starship init zsh)"
