# 07-functions.zsh — Custom functions

# Create a new Java Maven project folder instantly
makejava() {
    mkdir -p "$1/src/main/java/com/school"
    cat <<EOF > "$1/pom.xml"
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.school</groupId>
  <artifactId>$1</artifactId>
  <version>1.0-SNAPSHOT</version>
  <properties>
    <maven.compiler.source>17</maven.compiler.source>
    <maven.compiler.target>17</maven.compiler.target>
  </properties>
</project>
EOF
    echo "Project $1 created! Code goes in $1/src/main/java/com/school"
}

# Enable zmv
autoload -Uz zmv

# List the *names* of exported variables without their values. Use this instead
# of `env`/`printenv` when a stream is live: `99-secrets.zsh` exports secrets
# into every pane, so `env` would print them all.
envnames() {
    typeset +x | sort
}

# `env` and `printenv` dump every exported value, including the secrets from
# 99-secrets.zsh. Shadow them in the interactive shell (child processes still
# get the real binaries):
#   env                 -> names only
#   env VAR=x cmd ...   -> run cmd with VAR set, no dump
#   printenv            -> names only
#   printenv NAME       -> redacted; `printenv -r NAME` prints the real value
env() {
    if (( $# == 0 )); then
        envnames
        return 0
    fi
    command env "$@"
}

printenv() {
    if (( $# == 0 )); then
        envnames
        return 0
    fi
    local reveal=0
    if [[ $1 == -r ]]; then
        reveal=1
        shift
    fi
    local name value
    for name in "$@"; do
        value=${(P)name}
        if (( reveal )); then
            print -r -- "$value"
        elif [[ -n $value ]]; then
            print -r -- "$name=<redacted>"
        else
            print -r -- "$name=<unset or empty>"
        fi
    done
}

# Refuse to run the remaining obvious value-dumping commands at the prompt.
# `echo $SECRET`, `printf %s $TOKEN`, `set`, `export -p`, `typeset -p` and
# `cat <<< $SECRET` are blocked when they reference a secret-looking variable.
# Prefix with `command` to override: `command echo "$TOKEN"`.
_secret_name() {
    [[ ${1:u} == (*PASSWORD*|*PASSWD*|*TOKEN*|*SECRET*|*API_KEY*|*APIKEY*|*PRIVATE_KEY*|*ACCESS_KEY*|*SECRET_KEY*|*_KEY|KEY) ]]
}

# Returns 0 when the command line should be blocked.
_secret_guard_blocked() {
    setopt local_options extended_glob
    local buf=$1
    local trimmed=${buf##[[:space:]]#}
    trimmed=${trimmed%%[[:space:]]#}
    local cmd=${trimmed%%[[:space:]]*}
    cmd=${cmd:t}

    # Escape hatch for deliberate inspection.
    if [[ $cmd == (command|builtin) ]]; then
        return 1
    fi

    # Look through a leading privilege wrapper so `sudo echo $SECRET` is caught.
    if [[ $cmd == (sudo|doas) ]]; then
        trimmed=${trimmed#*[[:space:]]}
        trimmed=${trimmed##[[:space:]]#}
        cmd=${trimmed%%[[:space:]]*}
        while [[ $cmd == -* ]]; do
            trimmed=${trimmed#*[[:space:]]}
            trimmed=${trimmed##[[:space:]]#}
            cmd=${trimmed%%[[:space:]]*}
        done
        cmd=${cmd:t}
    fi

    case $cmd in
        (set)
            [[ $trimmed == set ]] && return 0
            ;;
        (export|typeset|declare)
            [[ $trimmed == ${cmd}[[:space:]]#-p ]] && return 0
            ;;
        (echo|print|printf|cat)
            if [[ $cmd != cat || $buf == *'<<<'* ]]; then
                local ref name
                local -a refs
                refs=(${(f)"$(print -r -- "$buf" | grep -oE '\$\{?[A-Za-z_][A-Za-z0-9_]*\}?')"})
                for ref in $refs; do
                    name=${ref#\$}
                    name=${name#\{}
                    name=${name%\}}
                    [[ -n $name && -n ${(P)name} ]] || continue
                    if _secret_name "$name"; then
                        return 0
                    fi
                done
            fi
            ;;
    esac
    return 1
}

_secret_guard_accept_line() {
    if _secret_guard_blocked "$BUFFER"; then
        zle -M "secret-guard: this would print an exported secret. Use envnames, or prefix with 'command' to override."
        return
    fi
    zle .accept-line
}

if [[ -o interactive ]]; then
    zle -N accept-line _secret_guard_accept_line
fi
