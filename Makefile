modules = git kitty nvim rg wezterm zsh

install:
	stow $(modules)

delete:
	stow -D $(modules)
