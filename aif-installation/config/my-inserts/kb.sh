#!/bin/bash
SETCOLOR_SUCCESS="echo -en \\033[1;32m"
SETCOLOR_FAILURE="echo -en \\033[1;31m"
SETCOLOR_ERROR="echo -en \\033[1;33m"
SETCOLOR_NORMAL="echo -en \\033[0;39m"
function keyboard()
{
	clear
	echo -e -n "\n"
	echo -e -n " _____________________________________________________________________________________________\n"
	echo -e -n "|Escape   | F1 | F2 | F3 |F4 |F5 |F6 |F7 |F8 |F9 |F10 |F11 |F12 |                             |\n"
	echo -e -n "|---------------------------------------------------------------------------------------------|\n"
	echo -e -n "|grave    | 1  |  2 |  3 |  4 |  5 |  6 |  7 |  8 |  9 |  0   | minus | equal |   BackSpace   |\n"
	echo -e -n "|Tab      |  | q | w | e | r | t | y | u | i | o | p | bracketleft | bracketright | backslash |\n"
	echo -e -n "|Caps_Lock|   | a | s | d | f | g | h | j | k | l | semicolon | apostrophe |      Return      |\n"
	echo -e -n "|shift    |     | z | x | c | v | b | n | m |comma|period|slash |    shift |                  |\n"
	echo -e -n "|ctrl     |   |mod4 |alt|     space         | alt | mod4 | Menu | ctrl |                      |\n"
	echo -e -n "|_____________________________________________________________________________________________|\n"
	$SETCOLOR_FAILURE
	echo -e -n "\n       Not Found — USB Keyboard."
	echo -e -n "                        Laptop Keyboard. "
	$SETCOLOR_NORMAL
	echo -e -n "Numpad.\n"
	echo -e -n " __________________________________________   _____________________________________________________\n"
	echo -e -n "| Print Screen | Scroll Lock | Pause Break | |   Home   |    End    |    Prior    |  Next          |\n"
	echo -e -n "|------------------------------------------| |-----------------------------------------------------|\n"
	echo -e -n "|   Insert     |     Home    |  Page Up    | | Num_Lock | KP_Divide | KP_Multiply | KP_Subtract    |\n"
	echo -e -n "|   Delete     |      End    |  Page Down  | | KP_Home  | KP_Up     | KP_Prior    |   KP_Add       |\n"
	echo -e -n "|------------------------------------------| | KP_Left  | KP_Begin  | KP_Right    |________________|\n"
	echo -e -n "|              |      Up     |             | | KP_End   | KP_Down   | KP_Next     |   KP_Enter     |\n"
	echo -e -n "|    Left      |     Down    |   Right     | |      KP_Insert       | KP_Delete   |________________|\n"
	echo -e -n "|__________________________________________| |_____________________________________________________|\n"
	echo -e -n ""
	echo -e -n "\n"
}
keyboard
exit 0
