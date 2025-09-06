#!/usr/bin/env bash

: "${DIALOG_OK:=0}"

text="Configures dark theme with modern icons and green accent

This script will:
- Install the Papirus icon theme
- Set the Papirus-Dark folder color to green
- Set theme settings
  Mouse Pointer : Bibata-Modern-Classic
  Applications  : Mint-Y-Dark
  Icons         : Papirus-Dark
  Desktop       : Mint-Y-Dark

You will be asked for your password.

Is this okay?
"

dialog \
	--defaultno \
	--no-collapse \
	--title "Theme Settings for Linux Mint" \
	--yesno "$text" 0 0 &&
	result=$DIALOG_OK || result=$?

clear

if [ "$result" = "$DIALOG_OK" ]; then
	sudo add-apt-repository -y ppa:papirus/papirus
	sudo apt -y update
	sudo apt -y install papirus-icon-theme
	sudo apt -y install papirus-folders
	sudo apt autoremove

	papirus-folders --color green --theme Papirus-Dark

	gsettings set org.cinnamon.desktop.interface cursor-theme Bibata-Modern-Classic
	gsettings set org.cinnamon.desktop.interface gtk-theme Mint-Y-Dark
	gsettings set org.cinnamon.desktop.interface icon-theme Papirus-Dark
	gsettings set org.cinnamon.theme name Mint-Y-Dark

	echo "Done!"
else
	echo "No changes were made."
fi
