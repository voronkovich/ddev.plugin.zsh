dev() {
    if [[ $# == 0 ]]; then
        ddev ssh

        return
    fi

    if [[ $1 =~ '^(-h|--help)$' ]]; then
        cat <<HELP
Wrapper for "ddev exec"

Usage: dev [<command>] [<args>]

Example: dev npm install
HELP

        return
    fi

    ddev exec -- "$@"
}

ddev-install() {
    if command -v brew > /dev/null; then
        brew install 'drud/ddev/ddev'

        return
    fi

    wget -q -O - https://raw.githubusercontent.com/drud/ddev/master/scripts/install_ddev.sh | bash
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

ddev-project-root() {
    local dir="${PWD}"

    while [[ -n "${dir}" ]]; do
        if [[ -e "${dir}/.ddev/config.yaml" ]]; then
            echo "${dir}" && return 0
        fi

        dir="${dir%/*}"
    done

    return 1
}

declare -g -A _zsh_plugin_ddev_tools=()

ddev-use-tool() {
    local tool="${1}"

    if [[ $# == 0 ]]; then
        for tool in "${(@k)_zsh_plugin_ddev_tools}"; do
            echo "${tool}"
        done

        return
    fi

    if [[ -v "_zsh_plugin_ddev_tools[${tool}]" ]]; then
        return
    fi

    _zsh_plugin_ddev_tools[${tool}]="$(command -v "${tool}")"

    "${tool}"() {
        local tool="${funcstack[-1]}"

        if ddev-project-root > /dev/null; then
            ddev exec -- "${tool}" "$@"

            return
        fi

        local executable="${_zsh_plugin_ddev_tools[${tool}]}"

        if [[ -z "${executable}" ]]; then
            echo "DDEV: Local \"${tool}\" is not available." >&2

            return 1
        fi

        "${executable}" "$@"
    }
}

for tool in $ZSH_PLUGIN_DDEV_TOOLS; do
    ddev-use-tool "${tool}"
done
