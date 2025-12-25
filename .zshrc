# alias 
alias ls="eza -A --icons"
alias ll="eza -A --icons -l"
alias lt="eza --tree --icons -A"
alias cat="bat"
alias home="cd ~"
alias c="clear"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gs="git status"
alias gd="git diff"

# Add local binaries to PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.symfony5/bin:$PATH"

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

# AI Commit Helper
function aicommit() {
    # 1. Check for staged changes
    # "2>/dev/null" silences the big usage text if an error occurs
    local diff=$(git diff --cached 2>/dev/null)

    # 2. Check if diff is empty OR if the command failed
    if [[ -z "$diff" ]]; then
        echo "⚠️  No staged changes found. Run 'git add' first."
        return 1
    fi

    echo "🤖 Generating message with qwen2.5-coder:3b..."

    local system_prompt="You are a strict git commit generator. You must generate a single line commit message that adheres to the Conventional Commits v1.0.0 specification (https://www.conventionalcommits.org/en/v1.0.0/).

**Rules:**
1. Format: <type>(<scope>): <subject>
2. Allowed Types: feat, fix, docs, style, refactor, test, chore, perf, ci, build, revert.
3. Use imperative mood (e.g., 'add' not 'added').
4. Do NOT output markdown, quotes, or explanations. Output ONLY the raw commit message."

    local msg=$(ollama run qwen2.5-coder:3b "$system_prompt

Review this git diff:
$diff")

    print -P "\n📝 \033[1;32m$msg\033[0m"
    print -n "Commit with this message? (y = yes / e = edit / n = no): "
    read -k 1 choice
    echo ""

    case "$choice" in
        y|Y) git commit -m "$msg" ;;
        e|E) git commit -m "$msg" -e ;;
        *) echo "❌ Aborted." ;;
    esac
# Force unload the model from RAM immediately to save memory
    curl -s http://localhost:11434/api/generate -d '{"model": "qwen2.5-coder:3b", "keep_alive": 0}' > /dev/null
}
