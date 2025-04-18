all:
	echo "Must select a target OS"

base:
	stow --target=$$HOME neovim oh-my-posh zsh

clean:
	stow --target=$$HOME --delete */

archlinux: clean base
	stow --target=$$HOME dunst kitty hypr waybar

osx: clean base
	stow --target=$$HOME ghostty
