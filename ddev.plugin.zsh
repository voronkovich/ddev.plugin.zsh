ZSH_PLUGIN_DDEV_TOOLS=(composer yarn npm npx ${ZSH_PLUGIN_DDEV_TOOLS})

for tool in $ZSH_PLUGIN_DDEV_TOOLS; do
    "${tool}"() {
        if [[ -f '.ddev/config.yaml' ]]; then
            ddev exec -- "${funcstack}" "$@"
        else
            "$(/usr/bin/which "${funcstack}")" "$@"
        fi
    }
done

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
    curl https://raw.githubusercontent.com/drud/ddev/master/scripts/install_ddev.sh | bash
}

ddev-update() {
    ddev-install
}
