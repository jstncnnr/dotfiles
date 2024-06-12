all:
	echo "Must select a target OS"

base:
	stow --verbose --target=$$HOME neovim oh-my-posh

osx: clean base

archlinux: clean base
	stow --verbose --target=$$HOME kitty Hyprland waybar wofi dunst

clean:
	stow --verbose --target=$$HOME --delete */
