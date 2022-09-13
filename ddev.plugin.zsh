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
    if command -v brew > /dev/null; then
        if brew list --version 'drud/ddev/ddev' > /dev/null; then
            brew upgrade 'drud/ddev/ddev'

            return
        fi
    fi

    ddev-install
}

declare -g -A _zsh_plugin_ddev_tools=()

ddev-tools() {
    local tool

    if [[ $# == 0 ]]; then
        for tool in "${(@k)_zsh_plugin_ddev_tools}"; do
            echo "${tool}"
        done

        return
    fi

    for tool in $@; do
        if [[ -v "_zsh_plugin_ddev_tools[${tool}]" ]]; then
            continue
        fi

        _zsh_plugin_ddev_tools[${tool}]="$(which -p "${tool}")"

        "${tool}"() {
            local tool="${funcstack[-1]}"

            if __dev-project-root &>/dev/null; then
                ddev exec -- "${tool}" "$@"

                return $?
            fi

            local executable="${_zsh_plugin_ddev_tools[${tool}]}"

            if [[ -z "${executable}" ]]; then
                echo "DDEV: Local \"${tool}\" is not available." >&2

                return 1
            fi

            if [[ "${executable}" == "${tool}" ]]; then
                "${executable}" "$@"

                return $?
            fi

            "${executable}" "$@"
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
