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

## License

Copyright (c) Voronkovich Oleg. Distributed under the MIT.
