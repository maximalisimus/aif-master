#!/bin/bash

# sudo groupadd powermode
# sudo usermode -aG powermode UserName
# sudo nano /etc/sudoers
# powermode ALL=(ALL) NOPASSWD: /sbin/shutdown, /sbin/reboot, /sbin/halt, /sbin/poweroff

zenity --question --width=256 --height=64 --title="Вопрос" --text="\nВы действительно хотите выключить компьютер ?\n" --window-icon="info"

if [[ "$?" -eq 0 ]]; then
	shutdown -P now
	# shutdown -h now
	# shutdown -hF now
fi			
