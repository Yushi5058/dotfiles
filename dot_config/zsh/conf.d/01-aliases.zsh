# 01-aliases.zsh — Aliases

alias ls="eza -A --icons=auto"
alias ll="eza -A --icons -l"
alias lt="eza --tree --icons -A"
alias cat="bat"
alias dots="chezmoi update"
alias home="cd ~"
alias c="clear"

# Oracle
alias ora-install='podman run -d --name oracle11g -p 1521:1521 -p 8080:8080 --shm-size=2g --privileged -v oracle_data:/u01/app/oracle docker.io/wnameless/oracle-xe-11g-r2'
alias ora-start='podman start oracle11g'
alias ora-stop='podman stop oracle11g'
ora-sql() {
    read -s "?Enter Oracle password: " ora_pass && podman exec -it oracle11g bash -c "export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe; export PATH=\$ORACLE_HOME/bin:\$PATH; export ORACLE_SID=XE; sqlplus system/$ora_pass"
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
