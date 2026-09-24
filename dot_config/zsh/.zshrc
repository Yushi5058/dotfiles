# .zshrc — Main entry point, sources conf.d/*

# Source all conf.d fragments in order
for f in $ZDOTDIR/conf.d/*.zsh; do
  [[ -r "$f" ]] && source "$f"
done

# Load secrets if exists (gitignored)
[[ -f $ZDOTDIR/conf.d/99-secrets.zsh ]] && source $ZDOTDIR/conf.d/99-secrets.zsh