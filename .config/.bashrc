alias q="exit"
alias c="clear"
alias h="history"
alias ls="eza -a --icons"
alias ll="eza -a -l --icons"
alias home="cd ~"

# Define color codes
CAPP_BLUE='\[\e[38;5;74m\]'
CAPP_BROWN='\[\e[38;5;180m\]'
CAPP_GRAY='\[\e[38;5;248m\]'
CAPP_RESET='\[\e[0m\]'

# Customize prompt for user@host
PS1="${CAPP_BLUE}\u${CAPP_GRAY}@${CAPP_BROWN}\h${CAPP_GRAY}:${CAPP_BROWN}\W${CAPP_RESET} "

# Check if the current directory is a Git repository
if [ -x "$(command -v git)" ]; then
  # If yes, customize the prompt for Git repositories
  parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
  }

  PS1="${CAPP_BLUE}\u${CAPP_GRAY}@${CAPP_BROWN}\h${CAPP_GRAY}:${CAPP_BROWN}\W${CAPP_BROWN}\$(parse_git_branch)${CAPP_RESET} "
fi

# End of .bashrc

