#!/usr/bin/env bash

echo "This script will:
- Make windows maximize when dragged to top of screen
- Disable mouse acceleration
- Hide the update manager tray icon when there are no updates available
"
read -erp "Is this okay? [y/N] "
if [[ $REPLY =~ ^[Yy]$ ]]; then
	gsettings set org.cinnamon.muffin tile-maximize true
	gsettings set org.cinnamon.desktop.peripherals.mouse accel-profile flat
	gsettings set com.linuxmint.updates hide-systray true
	echo "Done!"
else
	echo "No changes were made."
fi
