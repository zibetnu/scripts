#!/usr/bin/env bash

: "${DIALOG_OK:=0}"

text="Adjusts annoying default settings

This script will:
- Make windows maximize (instead of tile) when dragged to top of screen
- Disable mouse acceleration
- Hide the update manager tray icon when there are no updates available
- Disable bluetooth connection notifications

Is this okay?
"

dialog \
	--defaultno \
	--no-collapse \
	--title "Setting Tweaks for Linux Mint" \
	--yesno "$text" 0 0 &&
	result=$DIALOG_OK || result=$?

clear

if [ "$result" = "$DIALOG_OK" ]; then
	gsettings set org.cinnamon.muffin tile-maximize true
	gsettings set org.cinnamon.desktop.peripherals.mouse accel-profile flat
	gsettings set com.linuxmint.updates hide-systray true
	gsettings set org.blueman.general plugin-list "['\!ConnectionNotifier']"

	echo "Done!"
else
	echo "No changes were made."
fi
