#!/usr/bin/env bash

: "${DIALOG_OK:=0}"

confirm_change() {
	dialog \
		--defaultno \
		--keep-window \
		--no-collapse \
		--title "$1" \
		--backtitle "Tweaks for Linux Mint Cinnamon" \
		--yes-label "Apply" \
		--no-label "Skip" \
		--yesno "$2" 0 0 &&
		result=$DIALOG_OK || result=$?
	clear

	if [ "$result" = "$DIALOG_OK" ]; then
		return 0
	fi

	return 1
}

confirm_change "Configure Theme" \
	"Do the default icons look dated? Try this out.

This section will:
- Install the Papirus icon theme
- Set the Papirus-Dark folder color to green
- Set theme settings
  Applications  : Mint-Y-Dark
  Icons         : Papirus-Dark
  Desktop       : Mint-Y-Dark"
if [ $? = "$DIALOG_OK" ]; then
	sudo add-apt-repository -y ppa:papirus/papirus
	sudo apt -y update
	sudo apt -y install papirus-icon-theme
	sudo apt -y install papirus-folders
	sudo apt autoremove

	papirus-folders --color green --theme Papirus-Dark

	gsettings set org.cinnamon.desktop.interface gtk-theme Mint-Y-Dark
	gsettings set org.cinnamon.desktop.interface icon-theme Papirus-Dark
	gsettings set org.cinnamon.theme name Mint-Y-Dark
fi

confirm_change "Change Annoying Defaults" \
	"Is something bugging you? It might be one of these settings.

This section will:
- Disable bluetooth connection notifications
- Disable mouse acceleration
- Maximize (instead of tile) when dragging a window to the top edge
- Only show update manager tray icon when there are updates or errors"
if [ $? = "$DIALOG_OK" ]; then
	gsettings set org.blueman.general plugin-list "['\!ConnectionNotifier']"
	gsettings set org.cinnamon.desktop.peripherals.mouse accel-profile flat
	gsettings set org.cinnamon.muffin tile-maximize true
	gsettings set com.linuxmint.updates hide-systray true
fi
