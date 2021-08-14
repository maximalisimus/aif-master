######################################################################
##                                                                  ##
##                  Dependences configuration                       ##
##                You need the "Dialog" package                     ##
##                      for this script                             ##
##                                                                  ##
######################################################################

setcolor()
{
    SETCOLOR_SUCCESS="echo -en \\033[1;32m"
    SETCOLOR_FAILURE="echo -en \\033[1;31m"
    SETCOLOR_NORMAL="echo -en \\033[0;39m"
}
outin_success()
{
    $SETCOLOR_SUCCESS
    echo -n "$(tput hpa $(tput cols))$(tput cub 6)[OK]"
    $SETCOLOR_NORMAL
    echo
}
outin_failure()
{
    $SETCOLOR_FAILURE
    echo -n "$(tput hpa $(tput cols))$(tput cub 6)[fail]"
    $SETCOLOR_NORMAL
    echo
}
script_dependences_question()
{
    echo -e -n "\e[1;37mДля работы скрипта требуется пакет «\e[1;34mdialog\e[1;37m».\e[1;33m Установить? (\e[1;32my\e[1;33m/\e[1;31mn\e[1;33m)? \e[0m\n"
    echo -e -n "\e[1;37mНажатие на кнопку «\e[1;34mEnter\e[1;37m» аналогично действию «\e[1;32my\e[1;37m|\e[1;32mY\e[1;37m» - действие по умолчанию. \e[0m\n\n"
    echo -e -n "\e[1;37mThe «\e[1;34mdialog\e[1;37m» package is required for operation.\e[1;33m To install? (\e[1;32my\e[1;33m/\e[1;31mn\e[1;33m)? \e[0m\n"
    echo -e -n "\e[1;37mPressing the «\e[1;34mEnter\e[1;37m» button is similar to the «\e[1;32my\e[1;37m|\e[1;32mY\e[1;37m» action - default action.\e[0m\n"
}
git_dependences_question()
{
	echo -e -n "\e[1;37mДля работы скрипта требуется пакет «\e[1;git\e[1;37m».\e[1;33m Установить? (\e[1;32my\e[1;33m/\e[1;31mn\e[1;33m)? \e[0m\n"
    echo -e -n "\e[1;37mНажатие на кнопку «\e[1;34mEnter\e[1;37m» аналогично действию «\e[1;32my\e[1;37m|\e[1;32mY\e[1;37m» - действие по умолчанию. \e[0m\n\n"
    echo -e -n "\e[1;37mThe «\e[1;git\e[1;37m» package is required for operation.\e[1;33m To install? (\e[1;32my\e[1;33m/\e[1;31mn\e[1;33m)? \e[0m\n"
    echo -e -n "\e[1;37mPressing the «\e[1;34mEnter\e[1;37m» button is similar to the «\e[1;32my\e[1;37m|\e[1;32mY\e[1;37m» action - default action.\e[0m\n"
}
dependences_result()
{
    read item
    case "$item" in
        y|Y) echo -e -n "\e[1;32mПроизводится установка пакета «dialog»...\e[0m"
            outin_success
            echo -e -n "\e[1;32mThe «dialog» package is installed...\e[0m"
            outin_success
            echo ""
            sudo pacman -Syy --noconfirm
            wait
            sudo pacman-key --init
            wait
            sudo pacman-key --populate archlinux
            wait
            sudo pacman -Syy --noconfirm
            wait
            sudo pacman -S dialog --noconfirm
            wait
            ;;
        n|N) echo -e -n "\e[1;31mРабота скрипта будет прекращена!\e[0m"
            outin_failure
            echo -e -n "\e[1;31mThe script will be terminated!\e[0m"
            outin_failure
            echo ""
            exit 0
            ;;
        *) echo -e -n "\e[1;37mВыполняется действие по умолчанию...\e[0m"
          outin_success
          echo -e -n "\e[1;32mThe default action is executed...\e[0m" 
          outin_success
          echo ""
          sudo pacman -Syy --noconfirm
          wait
          sudo pacman-key --init
          wait
          sudo pacman-key --populate archlinux
          wait
          sudo pacman -Syy --noconfirm
          wait
          sudo pacman -S dialog --noconfirm
          wait
            ;;
    esac
}
dependences_git()
{
	read item
    case "$item" in
        y|Y) echo -e -n "\e[1;32mПроизводится установка пакета «git»...\e[0m"
            outin_success
            echo -e -n "\e[1;32mThe «git» package is installed...\e[0m"
            outin_success
            echo ""
            sudo pacman -Syy --noconfirm
            wait
            sudo pacman-key --init
            wait
            sudo pacman-key --populate archlinux
            wait
            sudo pacman -Syy --noconfirm
            wait
            sudo pacman -S git --noconfirm
            wait
            ;;
        n|N) echo -e -n "\e[1;31mРабота скрипта будет прекращена!\e[0m"
            outin_failure
            echo -e -n "\e[1;31mThe script will be terminated!\e[0m"
            outin_failure
            echo ""
            exit 0
            ;;
        *) echo -e -n "\e[1;37mВыполняется действие по умолчанию...\e[0m"
          outin_success
          echo -e -n "\e[1;32mThe default action is executed...\e[0m" 
          outin_success
          echo ""
          sudo pacman -Syy --noconfirm
          wait
          sudo pacman-key --init
          wait
          sudo pacman-key --populate archlinux
          wait
          sudo pacman -Syy --noconfirm
          wait
          sudo pacman -S git --noconfirm
          wait
            ;;
    esac
}
question_dialog_run()
{
	if [[ "${_how_shell[*]}" != "fish" ]]; then
		sudo pacman -Qs dialog 1>/dev/null 2>/dev/null
		if [[ $? != "0" ]]; then
			script_dependences_question
			wait
			dependences_result
		fi
		wait
		sudo pacman -Qs git 1>/dev/null 2>/dev/null
		if [[ $? != "0" ]]; then
			git_dependences_question
			wait
			dependences_git
		fi
		wait
	else
		pacman -Qs dialog 1>/dev/null 2>/dev/null
		if [[ "$STATUS" != "0" ]]; then
			script_dependences_question
			wait
			dependences_result
		fi
		wait
		pacman -Qs git 1>/dev/null 2>/dev/null
		if [[ "$STATUS" != "0" ]]; then
			git_dependences_question
			wait
			dependences_git
		fi
		wait
	fi
}
