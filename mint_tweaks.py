#!/usr/bin/env python

from enum import Enum
import subprocess

BACK_TITLE = '--backtitle "Tweaks for Linux Mint Cinnamon"'
DIMENSIONS = "0 0"


class ReturnCode(int, Enum):
	APPLY = 0
	SKIP = 1
	SEE_COMMANDS = 2
	ESCAPE = 255


def message(text, title="", ok_label="OK", max_width=False):
	args = [
		"--no-collapse",
		f'--title "{title}"',
		BACK_TITLE,
		f'--ok-label "{ok_label}"',
		"--msgbox",
		f'"{text}"',
		"0 -1" if max_width else DIMENSIONS,
	]
	subprocess.call(f"dialog {' '.join(args)}", shell=True)


def apply(tweak):
	for command in tweak.get("commands"):
		print(command)
		subprocess.call(command, shell=True)


def see_commands(tweak):
	message(
		"\n".join(tweak.get("commands", "")),
		tweak.get("title", ""),
		"Back",
		max_width=True,
	)


def prompt(tweak):
	args = [
		"--defaultno",
		"--no-collapse",
		f'--title "{tweak.get("title", "")}"',
		BACK_TITLE,
		"--help-button",
		'--yes-label "Apply"',
		'--no-label "Skip"',
		'--help-label "See Commands"',
		"--yesno",
		f'"{tweak.get("description", "")}"',
		DIMENSIONS,
	]
	return_code = subprocess.call(f"dialog {' '.join(args)}", shell=True)
	match return_code:
		case ReturnCode.APPLY:
			apply(tweak)

		case ReturnCode.SEE_COMMANDS:
			see_commands(tweak)
			prompt(tweak)

		case ReturnCode.ESCAPE:
			message("Skipped by pressing escape.", tweak.get("title", ""))


def prompt_list(text, tweaks, title="", show_reset_message=False):
	args = [
		"--no-hot-list",
		"--no-tags",
		f'--title "{title}"',
		BACK_TITLE,
		"--help-button",
		'--ok-label "Apply Enabled"',
		'--cancel-label "Skip All"',
		'--help-label "See Commands"',
		"--checklist",
		f'"{text}"',
		DIMENSIONS,
		str(len(tweaks)),
	]
	for tweak in tweaks:
		args.append(f'{tweaks.index(tweak)} "{tweak.get("title", "Unknown")}" on')

	completed_process = subprocess.run(
		f"dialog {' '.join(args)}",
		shell=True,
		stderr=subprocess.PIPE,
	)
	output = completed_process.stderr.decode("utf-8").split(" ")
	match completed_process.returncode:
		case ReturnCode.APPLY:
			for i in output:
				apply(tweaks[int(i)])

		case ReturnCode.SEE_COMMANDS:
			see_commands(tweaks[int(output[1])])
			message("Item selection was reset.", title)
			prompt_list(text, tweaks, title, show_reset_message=True)

		case ReturnCode.ESCAPE:
			message("Skipped all by pressing escape.", title)


def main():
	major_tweaks = [
		{
			"title": "Configure theme",
			"description": "Do the default icons look dated? Try this out.\n\nThis tweak will:\n- Install the Papirus icon theme\n- Set the Papirus-Dark folder color to green\n- Set theme settings\n  Applications  : Mint-Y-Dark\n  Icons         : Papirus-Dark\n  Desktop       : Mint-Y-Dark",
			"commands": [
				"sudo add-apt-repository -y ppa:papirus/papirus",
				"sudo apt -y update",
				"sudo apt -y install papirus-icon-theme",
				"sudo apt -y install papirus-folders",
				"sudo apt autoremove",
				"papirus-folders --color green --theme Papirus-Dark",
				"gsettings set org.cinnamon.desktop.interface gtk-theme Mint-Y-Dark",
				"gsettings set org.cinnamon.desktop.interface icon-theme Papirus-Dark",
				"gsettings set org.cinnamon.theme name Mint-Y-Dark",
			],
		},
	]
	for tweak in major_tweaks:
		prompt(tweak)

	annoying_defaults = [
		{
			"title": "Disable bluetooth connection notifications",
			"commands": [
				"gsettings set org.blueman.general plugin-list \"['\\!ConnectionNotifier']\"",
			],
		},
		{
			"title": "Maximize (instead of tile) when dragging a window to the top edge",
			"commands": [
				"gsettings set org.cinnamon.muffin tile-maximize true",
			],
		},
		{
			"title": "Disable mouse acceleration",
			"commands": [
				"gsettings set org.cinnamon.desktop.peripherals.mouse accel-profile flat",
			],
		},
		{
			"title": "Only show update manager tray icon when there are updates or errors",
			"commands": [
				"gsettings set com.linuxmint.updates hide-systray true",
			],
		},
	]
	prompt_list(
		"Is something bugging you? One of these changes may help. Click or press space to toggle an item.",
		annoying_defaults,
		"Change Annoying Defaults",
	)
	message("All done!")
	subprocess.call("clear")


if __name__ == "__main__":
	main()
