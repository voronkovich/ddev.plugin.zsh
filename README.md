# ddev.plugin.zsh

ZSH plugin for [ddev](https://ddev.com/).

## Installation

### [Antigen](https://github.com/zsh-users/antigen)

```sh
antigen bundle voronkovich/ddev.plugin.zsh
```
### [Zplug](https://github.com/zplug/zplug)

```sh
zplug "voronkovich/ddev.plugin.zsh"
```

### [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)

```sh
git clone https://github.com/voronkovich/ddev.plugin.zsh ~/.oh-my-zsh/custom/plugins/ddev
```

Edit `.zshrc` to enable the plugin:

```sh
plugins=(... ddev)
```

### Manual

Clone this repo and add this into your `.zshrc`:

```sh
source path/to/cloned/repo/ddev.plugin.zsh
```

## Usage

This plugin provides a convenient wrapper around `ddev exec`, making it easier to run commands within a DDEV environment.

```sh
# Runs: ddev exec bin/console
dev bin/console

# Runs: ddev exec cli/joomla.php
dev cli/joomla.php
```

### Commands

- `dev <command> [args]` - Runs a command inside the DDEV environment.
- `devs` - Alias for `dev start`, starts the DDEV project and launches the browser.
- `devo` - Alias for `dev open`, opens the project in the browser.
- `devm` - Alias for `dev mails`, opens the mail viewer.

### Special Commands

- `dev start` - Starts the DDEV environment and opens the project in the browser.
- `dev status` - Shows the status of the DDEV project.
- `dev stop` - Stops the DDEV environment.
- `dev restart` - Restarts the DDEV environment.
- `dev open` - Opens the project in the browser.
- `dev mails` - Opens the mail viewer.

### Installation & Upgrade Helpers

- `ddev-install` - Installs DDEV using Homebrew or the official installation script.
- `ddev-upgrade` - Upgrades DDEV via Homebrew or reinstalls it if not using Homebrew.

### Custom Tool Wrappers

You can wrap specific tools to automatically execute inside the DDEV environment when in a DDEV project:

```sh
ddev-tools composer npm yarn
```

Now, running `composer`, `npm`, or `yarn` within a DDEV project will automatically execute inside the container.

## License

Copyright (c) Voronkovich Oleg. Distributed under the MIT.
