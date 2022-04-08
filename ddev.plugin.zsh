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

for tool in $ZSH_PLUGIN_DDEV_TOOLS; do
    "${tool}"() {
        if [[ -f '.ddev/config.yaml' ]]; then
            ddev exec -- "${funcstack}" "$@"
        else
            "$(/usr/bin/which "${funcstack}")" "$@"
        fi
    }
done
