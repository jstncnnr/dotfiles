#!/bin/bash

declare -a dirs=(
	"hypr" 
	"kitty"
	"nvim"
	"waybar"
	"wofi"
	"dunst"
	"bspwm"
	"sxhkd"
	"picom"
	"polybar"
)

for i in "${dirs[@]}" 
do
	ln -sf "$(pwd)/config/$i" ~/.config/
done

declare -A etc=(
	["pipewire--50-network.conf"]="/etc/pipewire/pipewire-pulse.conf.d/50-network.conf"
	["pipewire--raop-discover.conf"]="/etc/pipewire/pipewire.conf.d/raop-discover.conf"
)

for key in "${!etc[@]}" 
do
	sudo ln -sf "$(pwd)/etc/$key" "${etc[$key]}"
done

echo "zmodule asdf" >> ~/.zimrc
echo "zmodule romkatv/powerlevel10k --use degit" >> ~/.zimrc
