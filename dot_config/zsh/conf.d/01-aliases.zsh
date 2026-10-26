# 01-aliases.zsh — Aliases

alias ls="eza -A --icons=auto"
alias ll="eza -A --icons -l"
alias lt="eza --tree --icons -A"
alias cat="bat"
alias dots="chezmoi update"
alias home="cd ~"
alias c="clear"

# --- Oracle 12c Podman Config ---
# Image: Oracle Database 21.3.0 Enterprise Edition (12c media unavailable)
alias sqlplus='podman exec -it oracle21c sqlplus "$@"'
alias rman='podman exec -it oracle21c rman "$@"'
alias oracle-start='podman start oracle21c'
alias oracle-stop='podman stop oracle21c'
alias oracle-logs='podman logs -f oracle21c'
oracle-status() {
    podman ps --filter name=oracle21c --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
    podman exec oracle21c lsnrctl status 2>/dev/null || true
}

# MSSQL
alias mssql-start='podman start sql1'
alias mssql-stop='podman stop sql1'
mssql-sql() {
    if ! podman ps -a --format '{{.Names}}' | grep -qx sql1; then
        read -s "?Enter SA password: " sa_pass && podman run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=$sa_pass" \
           -p 1433:1433 --name sql1 --hostname sql1 \
           -d mcr.microsoft.com/mssql/server:2022-latest
    fi
    podman start sql1
}

# Android/Waydroid
alias android-on="sudo systemctl start waydroid-container && waydroid show-full-ui"
alias android-off="waydroid session stop && sudo waydroid container stop && sudo systemctl stop waydroid-container"

# Suffix aliases
alias -s md="bat"
alias -s py="$EDITOR"
alias -s json="jless"
alias -s html="xdg-open"

# zmv helpers
alias zcp='zmv -C'
alias zln='zmv -L'
