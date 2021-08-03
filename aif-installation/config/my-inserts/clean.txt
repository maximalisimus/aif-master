#!/bin/bash
error_list=$(pacman -Qdt | cut -d " " -f1)
for i in ${error_list[*]}; do
	sudo pacman -Rns $i --noconfirm
done
for i in ${error_list[*]}; do
	sudo pacman -Rdd $i --noconfirm
done
pacman -Scc
exit 0
