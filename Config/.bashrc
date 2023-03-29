# Alias


# Alias pour naviguer dans les dossiers
alias cd..='cd ..' # Aller au dossier parent
alias cd...='cd ../..' # Aller à deux niveaux au-dessus
alias ll='ls -la' # Afficher les fichiers et dossiers de manière détaillée


export TERMINAL=kitty



# Variables d'environnement



# Chemin vers vos projets de développement
export DEV_PATH="$HOME/Dev"

# Chemin vers votre dossier de notes
export NOTES_PATH="$HOME/Notes"

# Définir le nombre de processus maximum pour Make
export MAKEFLAGS="-j $(nproc)"
