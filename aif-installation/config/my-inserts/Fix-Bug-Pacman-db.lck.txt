#!/bin/bash

ANSWER="./.asf"
system=$(uname -s)
version=$(uname -r)
archi=$(uname -m)
_backtitle="${system} ${version} ${archi}"
_pass_title="Введение пароля"
_pass_body="\nВведите, пожалуйста, пароль пользователя.\n"
szPassword=""
Xdialog --backtitle "$_backtitle" --title "$_pass_title" --inputbox "$_pass_body" 0 0 "" 2>${ANSWER}
	qst=$?
	case $qst in
		0) szPassword=$(cat ${ANSWER})
			printf "%s\n" "$szPassword" | sudo --stdin rm -rf /var/lib/pacman/db.lck
			;;
	esac
rm -rf ${ANSWER}
clear
exit 0
