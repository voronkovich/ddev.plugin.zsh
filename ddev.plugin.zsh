dev() {
    if [[ $1 =~ '^(-h|--help)$' ]]; then
        cat <<HELP
Wrapper for "ddev exec"

Usage: dev [<command>] [<args>]

Example: dev npm install
HELP

        return
    fi

    if [[ $# == 0 ]]; then
        ddev ssh

        return
    fi

    local -r cmd="${1}" && shift

    case "${cmd}" in
        start )
            ddev start "${@}" && ddev launch &>/dev/null
            return
            ;;
        status )
            ddev status "$@"
            return
            ;;
        stop )
            ddev stop "$@"
            return
            ;;
        restart )
            ddev restart "$@"
            return
            ;;
        open )
            ddev launch "$@" &>/dev/null
            return
            ;;
        mails )
            ddev launch -m "$@" &>/dev/null
            return
            ;;
        dba )
            ddev launch -p "$@" &>/dev/null
            return
            ;;
    esac

    ddev exec -- "${cmd}" "$@"
}

ddev-install() {
    if (( $+commands[brew] )); then
        command brew install 'drud/ddev/ddev'

        return
    fi

    command wget -q -O - https://raw.githubusercontent.com/drud/ddev/master/scripts/install_ddev.sh | bash
}

ddev-upgrade() {
    if (( $+commands[brew] )); then
        if brew list --version 'drud/ddev/ddev' > /dev/null; then
            brew upgrade 'drud/ddev/ddev'

            return
        fi
    fi

    ddev-install
}

ddev-tools() {
    local tool

    for tool in $@; do
        "${tool}"() {
            if __dev-project-root &>/dev/null; then
                command ddev exec -- "$0" "$@"

                return
            fi

            command "$0" "$@"
        }
    done
}

__dev-project-root() {
    local dir="${PWD}"

    while [[ -n "${dir}" ]]; do
        if [[ -e "${dir}/.ddev/config.yaml" ]]; then
            echo "${dir}" && return 0
        fi

        dir="${dir%/*}"
    done

    return 1
}
