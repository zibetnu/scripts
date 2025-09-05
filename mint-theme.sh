#!/usr/bin/env bash

echo "This script will:
- Download Papirus icons
- Set the theme to Mint-Y-Dark
- Set the theme icons to Papirus-Dark
- Set the folder color to green

You will be asked for your password.
"
read -erp "Is this okay? [y/N] "
if [[ $REPLY =~ ^[Yy]$ ]]; then
	sudo add-apt-repository -y ppa:papirus/papirus
	sudo apt -y update
	sudo apt -y install papirus-icon-theme
	sudo apt -y install papirus-folders

	gsettings set org.cinnamon.desktop.interface gtk-theme Mint-Y-Dark
	gsettings set org.cinnamon.desktop.interface icon-theme Papirus-Dark
	papirus-folders -C green --theme Papirus-Dark

	sudo apt autoremove
	echo "Done!"
else
	echo "No changes were made."
fi
