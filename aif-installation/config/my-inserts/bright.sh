#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Please, enter the brightness value on 0 to 100 percentage !"
	exit 0
fi

brightness_directory="/dev/null"
if [ -d /sys/class/backlight/intel_backlight ]; then
	brightness_directory="/sys/class/backlight/intel_backlight"
elif [ -d /sys/class/blacklight/acpi_video0 ]; then
	brightness_directory="/sys/class/backlight/acpi_video0"
else
	echo "Can't determine backlight controller !"
	exit 0
fi
_max_bright="${brightness_directory}/max_brightness"
_bright="${brightness_directory}/brightness"

#
# chown -R root:users /sys/class/backlight/intel_backlight/
# chmod -R 755 /sys/class/backlight/intel_backlight/
# chown root:sys /sys/class/backlight/intel_backlight/brightness
# chmod 775 /sys/class/backlight/intel_backlight/brightness
# sudo usermod -aG sys mikl
#

_tmp=$(cat "${_max_bright}")
max_brightness="${_tmp[*]}"
unset _tmp
#
_get="$1"
if [[ "${_get}" == *"+"* ]]; then
	if [[ $1 -gt 0 ]] && [[ $1 -le 50 ]]; then
		count="${_get:1}"
		tmp=$(cat "${_bright}")
		get_bright="$tmp"
		unset tmp
		counter=$(expr 100 / $count)
		count=$(expr $max_brightness / $counter)
		unset counter
		get_bright=$(expr $get_bright + $count)
		unset count
		if [[ $get_bright -gt $max_brightness ]]; then
			echo "$max_brightness" > "${_bright}"
		else
			echo "$get_bright" > "${_bright}"
		fi
	else
		echo "You entered an incorrect brightness value (0...50)! Please, repeat the input!"
	fi
elif [[ "${_get}" == *"-"* ]]; then
	if [[ $1 -gt -50 ]] && [[ $1 -le 0 ]]; then
		count="${_get:1}"
		tmp=$(cat "${_bright}")
		get_bright="$tmp"
		unset tmp
		counter=$(expr 100 / $count)
		count=$(expr $max_brightness / $counter)
		unset counter
		get_bright=$(expr $get_bright - $count)
		unset count
		if [[ $get_bright -lt 0 ]]; then
			echo "0" > "${_bright}"
		else
			echo "$get_bright" > "${_bright}"
		fi
	else
		echo "You entered an incorrect brightness value (-50...0)! Please, repeat the input!"
	fi
else
	if [[ $1 -gt 0 ]] && [[ $1 -le 100 ]]; then
		brightness=$(expr 100 / $1)
		brightness=$(expr $max_brightness / $brightness)
		echo "$brightness" > "${_bright}"
	else
		echo "You entered an incorrect brightness value (0...100)! Please, repeat the input!"
	fi
fi
exit 0
