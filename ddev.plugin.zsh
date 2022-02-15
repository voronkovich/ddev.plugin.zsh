ZSH_PLUGIN_DDEV_TOOLS=(composer yarn npm ${ZSH_PLUGIN_DDEV_TOOLS})

for tool in $ZSH_PLUGIN_DDEV_TOOLS; do
    "${tool}"() {
        if [[ -d .ddev ]]; then
            ddev exec "${funcstack}" "$@"
        else
            "$(/usr/bin/which "${funcstack}")" "$@"
        fi
    }
done

ddev-install() {
    curl https://raw.githubusercontent.com/drud/ddev/master/scripts/install_ddev.sh | bash
}

ddev-update() {
    ddev-install
}
