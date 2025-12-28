# alias 
alias ls="eza -A --icons"
alias ll="eza -A --icons -l"
alias lt="eza --tree --icons -A"
alias cat="bat"
alias home="cd ~"
alias c="clear"
alias ora-install='podman run -d --name oracle11g -p 1521:1521 -p 8080:8080 --shm-size=2g --privileged -v oracle_data:/u01/app/oracle docker.io/wnameless/oracle-xe-11g-r2'
alias ora-start='podman start oracle11g'
alias ora-stop='podman stop oracle11g'
alias ora-sql='podman exec -it oracle11g bash -c "export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe; export PATH=\$ORACLE_HOME/bin:\$PATH; export ORACLE_SID=XE; sqlplus system/oracle"'
alias lj="lazyjj"

# Add local binaries to PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.symfony5/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# ~/.zshrc
eval "$(starship init zsh)"

# define default editor
export EDITOR="nvim"

# bun completions
[ -s "/home/yushi_61/.bun/_bun" ] && source "/home/yushi_61/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# rg config path
export RIPGREP_CONFIG_PATH="$HOME/.config/.ripgreprc"

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk
#
#Add in zsh plugins 
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode
zinit load atuinsh/atuin

# Add in snippets
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found


# Autoload completions
autoload -U compinit && compinit

zinit cdreplay -q

# keybindings
# Only changing the escape key to `jk` in insert mode, we still
# keep using the default keybindings `^[` in other modes
ZVM_VI_INSERT_ESCAPE_BINDKEY=jk

# History 
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

# FUNCNEST problem workaround 
if [[ "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select" || \
      "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select-wrapped" ]]; then
    zle -N zle-keymap-select "";
fi

eval "$(starship init zsh)"

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups


# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completions:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"

# opencode
export PATH=/home/yushi_61/.opencode/bin:$PATH

# Fix Discord Flatpak RPC for Neovim
if [ -d "$XDG_RUNTIME_DIR/app/com.discordapp.Discord" ]; then
    ln -sf $XDG_RUNTIME_DIR/app/com.discordapp.Discord/discord-ipc-0 $XDG_RUNTIME_DIR/discord-ipc-0
fi

# dynamic completions for jj
source <(COMPLETE=zsh jj)
