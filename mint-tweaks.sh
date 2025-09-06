#!/usr/bin/env bash

echo "Adjusts annoying default settings

This script will:
- Make windows maximize (instead of tile) when dragged to top of screen
- Disable mouse acceleration
- Hide the update manager tray icon when there are no updates available
- Disable bluetooth connection notifications
"
read -erp "Is this okay? [y/N] "
if [[ $REPLY =~ ^[Yy]$ ]]; then
	gsettings set org.cinnamon.muffin tile-maximize true
	gsettings set org.cinnamon.desktop.peripherals.mouse accel-profile flat
	gsettings set com.linuxmint.updates hide-systray true
	gsettings set org.blueman.general plugin-list "['\!ConnectionNotifier']"
	echo "Done!"
else
	echo "No changes were made."
fi
