# 00-options.zsh — Shell options, history, completion

# History
HISTSIZE=50000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Never write commands that carry a secret literal to ~/.zsh_history.
# Parenthesised alternation works without `setopt extendedglob`; mixed-case
# classes keep `PASSWORD=`, `password=` and `Password=` all covered.
# `hist_ignore_space` still works for one-off commands that need a literal.
HISTORY_IGNORE='(*[Pp][Aa][Ss][Ss][Ww][Oo][Rr][Dd]=*|*[Pp][Aa][Ss][Ss][Ww][Dd]=*|*[Tt][Oo][Kk][Ee][Nn]=*|*[Ss][Ee][Cc][Rr][Ee][Tt]=*|*[Aa][Pp][Ii][_-][Kk][Ee][Yy]=*|*[Bb][Ee][Aa][Rr][Ee][Rr][[:space:]]*|*[Pp][Rr][Ii][Vv][Aa][Tt][Ee][_-][Kk][Ee][Yy]*|*--[Pp][Aa][Ss][Ss][Ww][Oo][Rr][Dd]*|*--[Tt][Oo][Kk][Ee][Nn]*|*--[Ss][Ee][Cc][Rr][Ee][Tt]*)'

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# English date format (override Arabic system locale)
export LC_TIME=en_US.UTF-8

# FUNCNEST problem workaround
if [[ "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select" || \
      "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select-wrapped" ]]; then
  zle -N zle-keymap-select "";
fi