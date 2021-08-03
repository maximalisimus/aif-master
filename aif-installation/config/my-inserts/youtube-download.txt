#!/bin/bash
SETCOLOR_SUCCESS="echo -en \\033[1;32m"
SETCOLOR_FAILURE="echo -en \\033[1;31m"
SETCOLOR_ERROR="echo -en \\033[1;33m"
SETCOLOR_NORMAL="echo -en \\033[0;39m"
#
SETCOLOR_BLACK="echo -en \\033[1;30m"
SETCOLOR_GREY="echo -en \\033[1;30m"
SETCOLOR_RED="echo -en \\033[0;31m"
SETCOLOR_RED_BOLD="echo -en \\033[1;31m"
SETCOLOR_GREEN="echo -en \\033[0;32m"
SETCOLOR_LIGHT_GREEN="echo -en \\033[1;32m"
SETCOLOR_YELLOW="echo -en \\033[1;33m"
SETCOLOR_ORANGE="echo -en \\033[0;33m"
SETCOLOR_BLUE="echo -en \\033[1;34m"
SETCOLOR_PURPLE="echo -en \\033[1;35m"
SETCOLOR_CYAN="echo -en \\033[1;36m"
SETCOLOR_WHITE="echo -en \\033[0;38m"
#
script_name=$(basename $0)
script_version="v1.0"
playlist_flag=0
sp_flag=0
ep_flag=0
sp=0
ep=0
sms()
{
	case "$1" in
		1) $SETCOLOR_SUCCESS
			echo -e -n "Process to Complete"
			$SETCOLOR_NORMAL;; 
		2) $SETCOLOR_FAILURE
			echo -e -n "Process to Failure"
			$SETCOLOR_NORMAL;;
	esac
}
checkprocess()
{
	if [ $1 -eq 0 ]; then
		$SETCOLOR_SUCCESS
		# echo -e -n "\n"
		echo -e -n "$(tput hpa $(tput cols))$(tput cub 6)[OK]"
		$SETCOLOR_NORMAL
		 echo -e -n "\n"
	else
		$SETCOLOR_FAILURE
		# echo -e -n "\n"
		echo -e -n "$(tput hpa $(tput cols))$(tput cub 6)[Fail]"
		$SETCOLOR_NORMAL
		 echo -e -n "\n"
	fi
}
_version()
{
	$SETCOLOR_NORMAL
	echo -e -n "Programm "
	$SETCOLOR_ORANGE
	echo -e -n "${script_name} "
	$SETCOLOR_PURPLE
	echo -e -n "${script_version}"
	echo -e -n "\n"
	$SETCOLOR_NORMAL
}
_help()
{
	# Script parameters
	$SETCOLOR_ORANGE
	echo -e -n "\t${script_name} "
	$SETCOLOR_WHITE
	echo -e -n "-[i,d,y,s,e,c,v,h,help,-h,-help] "
	$SETCOLOR_GREEN
	echo -e -n "[URL require]"
	echo -e -n "\n"
	# Script parameters
	# Help string
	$SETCOLOR_NORMAL
	echo -e -n "Help script "
	# Version
	$SETCOLOR_PURPLE
	echo -e -n "${script_version}"
	# Version
	echo -e -n "\n"
	$SETCOLOR_NORMAL
	# Help string
	$SETCOLOR_NORMAL
	# Command string
	$SETCOLOR_CYAN
	echo -e -n "The command is:"
	echo -e -n "\n"
	# Command string
	# -i
	$SETCOLOR_BLUE
	echo -e -n "\t-i\t"
	$SETCOLOR_NORMAL
	echo -e -n "Information of count videos to best formats."
	echo -e -n "\n"
	# -i
	# -d
	$SETCOLOR_GREEN
	echo -e -n "\t-d\t"
	$SETCOLOR_NORMAL
	echo -e -n "Download to best format."
	echo -e -n "\n"
	# -d
	# -y
	$SETCOLOR_RED_BOLD
	echo -e -n "\t-y\t"
	$SETCOLOR_NORMAL
	echo -e -n "Yes playlist."
	echo -e -n "\n"
	echo -e -n "\t\t"
	echo -e -n "Only video, no playlist to default."
	echo -e -n "\n"
	# -y
	# -s
	$SETCOLOR_YELLOW
	echo -e -n "\t-s\t"
	$SETCOLOR_NORMAL
	echo -e -n "Start position to download."
	echo -e -n "\n"
	# -s
	# -e
	$SETCOLOR_RED
	echo -e -n "\t-e\t"
	$SETCOLOR_NORMAL
	echo -e -n "End position to download."
	echo -e -n "\n"
	# -e
	# -c
	$SETCOLOR_CYAN
	echo -e -n "\t-c\t"
	$SETCOLOR_NORMAL
	echo -e -n "Count. Playlist video items to download."
	echo -e -n "\n"
	echo -e -n "\t\t"
	echo -e -n "\"--playlist-items 1,2,5,8.\""
	echo -e -n "\n"
	echo -e -n "\t\t"
	echo -e -n "range: \"--playlist-items 1-3,7,10-13\""
	echo -e -n "\n"
	# -c
	# -v
	$SETCOLOR_PURPLE
	echo -e -n "\t-v\t"
	$SETCOLOR_NORMAL
	echo -e -n "Print program version and exit."
	echo -e -n "\n"
	# -v
	# -h
	# echo -e -n "\t-h\t|\n\t-help\t|\n\t--h\t|\n\t--help\tPrint this help text and exit.\n"
	$SETCOLOR_LIGHT_GREEN
	echo -e -n "\t-h"
	$SETCOLOR_NORMAL
	echo -e -n "\t|"
	$SETCOLOR_LIGHT_GREEN
	echo -e -n "\n\t-help"
	$SETCOLOR_NORMAL
	echo -e -n "\t|"
	$SETCOLOR_LIGHT_GREEN
	echo -e -n "\n\t--h"
	$SETCOLOR_NORMAL
	echo -e -n "\t|"
	echo -e -n "\n\t"
	$SETCOLOR_LIGHT_GREEN
	echo -e -n "--help\t"
	$SETCOLOR_NORMAL
	echo -e -n "Print this help text and exit."
	echo -e -n "\n"
	$SETCOLOR_NORMAL
	# -h
}
_information()
{
	if [[ $playlist_flag -eq 1 ]]; then
		youtube-dl --yes-playlist -iF "${1}" | grep -Ei "^[0-9].*" | grep -Evi "audio" | awk '{print "count -",$1,$2,$3,$4,$11}' | grep -Ei "best" | uniq -cid | sed 's/^[ \t]*//'
	else
		youtube-dl --no-playlist -iF "${1}" | grep -Ei "^[0-9].*" | grep -Evi "audio" | awk '{print "count -",$1,$2,$3,$4,$11}' | grep -Ei "best" | uniq -cid | sed 's/^[ \t]*//'
	fi
	sms "1"
	checkprocess "0"
}
_downloads()
{
	if [[ $sp_flag -eq 0 ]]; then
		if [[ $playlist_flag -eq 1 ]]; then
			youtube-dl -o '%(title)s.%(ext)s' --yes-playlist -if best "$1"
		else
			youtube-dl -o '%(title)s.%(ext)s' --no-playlist -if best "$1"
		fi
		sms "1"
		checkprocess "0"
	elif [[ $ep_flag -eq 0 ]]; then
		if [[ $playlist_flag -eq 1 ]]; then
			youtube-dl -o '%(title)s.%(ext)s' --yes-playlist -if best --playlist-start "${sp}" "$1"
		else
			youtube-dl -o '%(title)s.%(ext)s' --no-playlist -if best --playlist-start "${sp}" "$1"
		fi
		sms "1"
		checkprocess "0"
	else
		if [[ $ep -ne 0 ]]; then
			if [[ $playlist_flag -eq 1 ]]; then
				youtube-dl -o '%(title)s.%(ext)s' --yes-playlist -if best --playlist-start "${sp}" --playlist-end "${ep}" "$1"
			else
				youtube-dl -o '%(title)s.%(ext)s' --no-playlist -if best --playlist-start "${sp}" --playlist-end "${ep}" "$1"
			fi
			sms "1"
			checkprocess "0"
		else
			if [[ $playlist_flag -eq 1 ]]; then
				youtube-dl -o '%(title)s.%(ext)s' --yes-playlist -if best --playlist-start "${sp}" "$1"
			else
				youtube-dl -o '%(title)s.%(ext)s' --no-playlist -if best --playlist-start "${sp}" "$1"
			fi
			sms "1"
			checkprocess "0"
		fi
	fi
}
while [ -n "$1" ]; do
	case "$1" in
		-i) if [[ $2 != "" ]]; then
				_information "${2}"
				wait
				shift
			fi
			;;
		-d) if [[ $2 != "" ]]; then
				_downloads "$2"
				wait
				shift
			fi
			;;
		-y) playlist_flag=1
			;;
		-c) if [[ $2 != "" ]]; then
				if [[ $3 != "" ]]; then
					youtube-dl -o '%(title)s.%(ext)s' --playlist-items "$2" -if best "$3"
					wait
					shift
				fi
				wait
				shift
			fi
			;;
		-s) if [[ $2 != "" ]]; then
				sp_flag=1
				sp=${2}
				wait
				shift
			fi
			;;
		-e) if [[ $2 != "" ]]; then
				ep_flag=1
				ep=${2}
				wait
				shift
			fi
			;;
		-v) _version
			;;
		-[h?] | --help) _help;;
		*) $SETCOLOR_ERROR
			echo -e -n "Unkonwn parameter\n"
			$SETCOLOR_NORMAL
			_help
			sms "2"
			checkprocess "1"
			;;
	esac
	shift
done
exit 0
