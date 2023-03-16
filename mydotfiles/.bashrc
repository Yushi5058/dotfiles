# Alias


# Alias pour naviguer dans les dossiers
alias cd..='cd ..' # Aller au dossier parent
alias cd...='cd ../..' # Aller à deux niveaux au-dessus
alias ll='ls -la' # Afficher les fichiers et dossiers de manière détaillée

# Alias pour les commandes Git
alias ga='git add .' # Ajouter tous les fichiers modifiés
alias gc='git commit -m' # Commit avec un message
alias gs='git status' # Afficher le statut des fichiers
alias glog='git log --graph --pretty=format:"%C(yellow)%h%Creset %ad [%Cred%an%Creset] %Cgreen%d%Creset %s" --date=short' # Afficher un historique Git agréable


# Variables d'environnement 



# Chemin vers vos projets de développement
export DEV_PATH="$HOME/Dev"

# Chemin vers votre dossier de notes
export NOTES_PATH="$HOME/Notes"

# Définir le nombre de processus maximum pour Make
export MAKEFLAGS="-j $(nproc)"


# Set prompt
PS1='\[\033[38;5;27m\]\A \[\033[38;5;39m\]\u@\[\033[38;5;39m\]\h\[\033[00m\]:\[\033[38;5;153m\]\w\[\033[00m\]\$ '

# Set title
PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'

# Set status bar
STATUS_BAR="$DARK_GRAY[\t]"

# Set status bar color
export PS1="$PS1$BLUE$STATUS_BAR$NO_COLOR\n$ "

