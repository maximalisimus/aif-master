#!/bin/bash
zenity --question --width=256 --height=64 --title="Вопрос" --text="\nВы действительно хотите перезагрузить компьютер ?\n" --window-icon="info"

if [[ "$?" -eq 0 ]]; then
	shutdown -r now
fi			
