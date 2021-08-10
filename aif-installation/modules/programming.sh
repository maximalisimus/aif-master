######################################################################
##                                                                  ##
##              Programing installation functions                   ##
##                                                                  ##
######################################################################

function makecmake_install()
{
	if [[ $_makecmake_once -eq 0 ]]; then
		_makecmake_once=1
		clear
		info_search_pkg
		_list_makecmake_pkg=$(check_s_lst_pkg "${_make_cmake_pkg[*]}")
		wait
		clear
		for j in ${_list_makecmake_pkg[*]}; do
			_lmenu_makecmake="${_lmenu_makecmake} $j - on"
		done
	fi
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "Arduino" --yesno "${_progr_bd} ${_list_makecmake_pkg[*]}" 0 0
	if [[ $? -eq 0 ]]; then
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "Arduino" --checklist "$_lmp_srv_bd" 0 0 7 ${_lmenu_makecmake} 2>${ANSWER}
		_chlmn_makecmake=$(cat ${ANSWER})
		[[ ${_chlmn_makecmake[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_chlmn_makecmake[*]} 2>/tmp/.errlog
		wait
		[[ ${_chlmn_makecmake[*]} != "" ]] && check_for_error
	fi
}

function arduino_install()
{
	if [[ $_arduino_once -eq 0 ]]; then
		_arduino_once=1
		clear
		info_search_pkg
		_list_arduino_pkg=$(check_s_lst_pkg "${_arduino_pkg[*]}")
		wait
		clear
		for j in ${_list_arduino_pkg[*]}; do
			_lmenu_arduino="${_lmenu_arduino} $j - on"
		done
	fi
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "Arduino" --yesno "${_progr_bd} ${_list_arduino_pkg[*]}" 0 0
	if [[ $? -eq 0 ]]; then
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "Arduino" --checklist "$_lmp_srv_bd" 0 0 7 ${_lmenu_arduino} 2>${ANSWER}
		_chlmn_arduino=$(cat ${ANSWER})
		[[ ${_chlmn_arduino[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_chlmn_arduino[*]} 2>/tmp/.errlog
		wait
		[[ ${_chlmn_arduino[*]} != "" ]] && check_for_error
	fi
}
function c_cpp_install()
{
	if [[ $_c_cpp_once -eq 0 ]]; then
		_c_cpp_once=1
		clear
		info_search_pkg
		_list_ccpp_pkg=$(check_s_lst_pkg "${_gcc_cpp_pkg[*]}")
		wait
		clear
		for j in ${_list_ccpp_pkg[*]}; do
			_lmenu_ccpp="${_lmenu_ccpp} $j - on"
		done
	fi
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "C / C++" --yesno "${_progr_bd} ${_list_ccpp_pkg[*]}" 0 0
	if [[ $? -eq 0 ]]; then
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "C / C++" --checklist "$_lmp_srv_bd" 0 0 7 ${_lmenu_ccpp} 2>${ANSWER}
		_chlmn_ccpp=$(cat ${ANSWER})
		[[ ${_chlmn_ccpp[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_chlmn_ccpp[*]} 2>/tmp/.errlog
		wait
		[[ ${_chlmn_ccpp[*]} != "" ]] && check_for_error
	fi
}
function mingww64_install()
{
	if [[ $_mingww64_once -eq 0 ]]; then
		_mingww64_once=1
		clear
		info_search_pkg
		_list_mingww64_pkg=$(check_s_lst_pkg "${_mingw_w64_pkg[*]}")
		wait
		clear
		for j in ${_list_mingww64_pkg[*]}; do
			_lmenu_mingww64="${_lmenu_mingww64} $j - on"
		done
	fi
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "MingW-W64" --yesno "${_progr_bd} ${_list_mingww64_pkg[*]}" 0 0
	if [[ $? -eq 0 ]]; then
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "MingW-W64" --checklist "$_lmp_srv_bd" 0 0 7 ${_lmenu_mingww64} 2>${ANSWER}
		_chlmn_mingww64=$(cat ${ANSWER})
		[[ ${_chlmn_mingww64[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_chlmn_mingww64[*]} 2>/tmp/.errlog
		wait
		[[ ${_chlmn_mingww64[*]} != "" ]] && check_for_error
	fi
}
function python3_install()
{
	if [[ $_python3_once -eq 0 ]]; then
		_python3_once=1
		clear
		info_search_pkg
		_list_py3_pkg=$(check_s_lst_pkg "${_python_pkg[*]}")
		wait
		clear
		for j in ${_list_py3_pkg[*]}; do
			_lmenu_py3="${_lmenu_py3} $j - on"
		done
	fi
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "Python 3" --yesno "${_progr_bd} ${_list_py3_pkg[*]}" 0 0
	if [[ $? -eq 0 ]]; then
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "Python 3" --checklist "$_lmp_srv_bd" 0 0 7 ${_lmenu_py3} 2>${ANSWER}
		_chlmn_py3=$(cat ${ANSWER})
		[[ ${_chlmn_py3[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_chlmn_py3[*]} 2>/tmp/.errlog
		wait
		[[ ${_chlmn_py3[*]} != "" ]] && check_for_error
	fi
}
function python2_install()
{
	if [[ $_python2_once -eq 0 ]]; then
		_python2_once=1
		clear
		info_search_pkg
		_list_py2_pkg=$(check_s_lst_pkg "${_python_pkg[*]}")
		wait
		clear
		for j in ${_list_py2_pkg[*]}; do
			_lmenu_py2="${_lmenu_py2} $j - on"
		done
	fi
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "Python 2" --yesno "${_progr_bd} ${_list_py2_pkg[*]}" 0 0
	if [[ $? -eq 0 ]]; then
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "Python 2" --checklist "$_lmp_srv_bd" 0 0 7 ${_lmenu_py2} 2>${ANSWER}
		_chlmn_py3=$(cat ${ANSWER})
		[[ ${_chlmn_py2[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_chlmn_py2[*]} 2>/tmp/.errlog
		wait
		[[ ${_chlmn_py2[*]} != "" ]] && check_for_error
	fi
}
function qtcreator_install()
{
	if [[ $_qtcreator_once -eq 0 ]]; then
		_qtcreator_once=1
		clear
		info_search_pkg
		_list_qtcreator_pkg=$(check_s_lst_pkg "${_qt_creator_pkg[*]}")
		wait
		clear
		for j in ${_list_qtcreator_pkg[*]}; do
			_lmenu_qtcreator="${_lmenu_qtcreator} $j - on"
		done
	fi
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "QT Creator" --yesno "${_progr_bd} ${_list_qtcreator_pkg[*]}" 0 0
	if [[ $? -eq 0 ]]; then
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "QT Creator" --checklist "$_lmp_srv_bd" 0 0 7 ${_lmenu_qtcreator} 2>${ANSWER}
		_chlmn_qtcreator=$(cat ${ANSWER})
		[[ ${_chlmn_qtcreator[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_chlmn_qtcreator[*]} 2>/tmp/.errlog
		wait
		[[ ${_chlmn_qtcreator[*]} != "" ]] && check_for_error
	fi
}
function java_install()
{
	if [[ $_java_once -eq 0 ]]; then
		_java_once=1
		clear
		info_search_pkg
		_list_java_pkg=$(check_s_lst_pkg "${_java_pkg[*]}")
		wait
		_list_java_ide_pkg=$(check_s_lst_pkg "${_java_ide[*]}")
		wait
		clear
		for j in ${_list_java_pkg[*]}; do
			_lmenu_java="${_lmenu_java} $j - on"
		done
		for i in ${_list_java_ide_pkg[*]}; do
			_lmenu_java_ide="${_lmenu_java_ide} $i - off"
		done
	fi
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "Java" --yesno "${_progr_bd} ${_list_java_pkg[*]}" 0 0
	if [[ $? -eq 0 ]]; then
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "Java" --checklist "$_lmp_srv_bd" 0 0 7 ${_lmenu_java} 2>${ANSWER}
		_chlmn_java=$(cat ${ANSWER})
		[[ ${_chlmn_java[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_chlmn_java[*]} 2>/tmp/.errlog
		wait
		[[ ${_chlmn_java[*]} != "" ]] && check_for_error
	fi
	wait
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "Java IDE" --yesno "${_progr_bd} ${_list_java_ide_pkg[*]}" 0 0
	if [[ $? -eq 0 ]]; then
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "Java IDE" --checklist "$_lmp_srv_bd" 0 0 7 ${_lmenu_java_ide} 2>${ANSWER}
		_chlmn_java_ide=$(cat ${ANSWER})
		[[ ${_chlmn_java_ide[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_chlmn_java_ide[*]} 2>/tmp/.errlog
		wait
		[[ ${_chlmn_java_ide[*]} != "" ]] && check_for_error
	fi
}
function perl_install()
{
	if [[ $_perl_once -eq 0 ]]; then
		_perl_once=1
		clear
		info_search_pkg
		_list_perl_pkg=$(check_s_lst_pkg "${_perl_pkg[*]}")
		wait
		clear
		for j in ${_list_perl_pkg[*]}; do
			_lmenu_perl="${_lmenu_perl} $j - on"
		done
	fi
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "Perl" --yesno "${_progr_bd} ${_list_perl_pkg[*]}" 0 0
	if [[ $? -eq 0 ]]; then
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "Perl" --checklist "$_lmp_srv_bd" 0 0 7 ${_lmenu_perl} 2>${ANSWER}
		_chlmn_perl=$(cat ${ANSWER})
		[[ ${_chlmn_perl[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_chlmn_perl[*]} 2>/tmp/.errlog
		wait
		[[ ${_chlmn_perl[*]} != "" ]] && check_for_error
	fi
}
function ruby_install()
{
	if [[ $_ruby_once -eq 0 ]]; then
		_ruby_once=1
		clear
		info_search_pkg
		_list_ruby_pkg=$(check_s_lst_pkg "${_ruby_pkg[*]}")
		wait
		clear
		for j in ${_list_ruby_pkg[*]}; do
			_lmenu_ruby="${_lmenu_ruby} $j - on"
		done
	fi
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "Ruby" --yesno "${_progr_bd} ${_list_ruby_pkg[*]}" 0 0
	if [[ $? -eq 0 ]]; then
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "Ruby" --checklist "$_lmp_srv_bd" 0 0 7 ${_lmenu_ruby} 2>${ANSWER}
		_chlmn_ruby=$(cat ${ANSWER})
		[[ ${_chlmn_ruby[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_chlmn_ruby[*]} 2>/tmp/.errlog
		wait
		[[ ${_chlmn_ruby[*]} != "" ]] && check_for_error
	fi
}
function golang_install()
{
	if [[ $_golang_once -eq 0 ]]; then
		_golang_once=1
		clear
		info_search_pkg
		_list_golang_pkg=$(check_s_lst_pkg "${_golang_pkg[*]}")
		wait
		clear
		for j in ${_list_golang_pkg[*]}; do
			_lmenu_golang="${_lmenu_golang} $j - on"
		done
	fi
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "GoLang" --yesno "${_progr_bd} ${_list_golang_pkg[*]}" 0 0
	if [[ $? -eq 0 ]]; then
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "GoLang" --checklist "$_lmp_srv_bd" 0 0 7 ${_lmenu_golang} 2>${ANSWER}
		_chlmn_golang=$(cat ${ANSWER})
		[[ ${_chlmn_golang[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_chlmn_golang[*]} 2>/tmp/.errlog
		wait
		[[ ${_chlmn_golang[*]} != "" ]] && check_for_error
	fi
}
function nodejs_install()
{
	if [[ $_nodejs_once -eq 0 ]]; then
		_nodejs_once=1
		clear
		info_search_pkg
		_list_njs_pkg=$(check_s_lst_pkg "${_nodejs_pkg[*]}")
		wait
	fi
	if [[ ${_list_njs_pkg} != "" ]]; then
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "Node.js" --yesno "${_progr_bd} ${_list_njs_pkg[*]}" 0 0
		if [[ $? -eq 0 ]]; then
			pacstrap ${MOUNTPOINT} ${_list_njs_pkg[*]} 2>/tmp/.errlog
			wait
			check_for_error
		else
			nodejs_menu
		fi
	else
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "Node.js" --msgbox "\nNode.js - Package not found!\n${_nodejs_pkg[*]}\n\n" 0 0
		wait
		nodejs_menu
	fi
}
function nodejs_lts_install()
{
	if [[ $_nodejs_lts_once -eq 0 ]]; then
		_nodejs_lts_once=1
		clear
		info_search_pkg
		_list_njs_lts_pkg=$(check_s_lst_pkg "${_nodejs_lts_pkg[*]}")
		wait
		clear
		for j in ${_list_njs_lts_pkg[*]}; do
			_lts_menu_nodejs="${_lts_menu_nodejs} $j -"
		done
	fi
	if [[ ${_list_njs_lts_pkg} != "" ]]; then
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_progr_hd" --menu "$_progr_bd_2" 0 0 5 \
		"1" "${_nodejs_lts_pkg[0]} (14.X version)" \
		"2" "${_nodejs_lts_pkg[1]} (12.X version)" \
		"3" "$_Back" 2>${ANSWER}
				
		 case $(cat ${ANSWER}) in
			"1") if [[ "${_list_njs_lts_pkg[*]}" == *"${_nodejs_lts_pkg[0]}"* ]]; then
					dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "Node.js" --yesno "${_progr_bd} ${_nodejs_lts_pkg[0]}" 0 0
					if [[ $? -eq 0 ]]; then
						pacstrap ${MOUNTPOINT} ${_nodejs_lts_pkg[0]} 2>/tmp/.errlog
						wait
						check_for_error
					fi
				else
					dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "Node.js LTS" --msgbox "\nNode.js LTS - Package not found!\n${_nodejs_lts_pkg[0]}\n\n" 0 0
					wait
				fi
				;;
			"2") if [[ "${_list_njs_lts_pkg[*]}" == *"${_nodejs_lts_pkg[1]}"* ]]; then
					dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "Node.js" --yesno "${_progr_bd} ${_nodejs_lts_pkg[1]}" 0 0
					if [[ $? -eq 0 ]]; then
						pacstrap ${MOUNTPOINT} ${_nodejs_lts_pkg[1]} 2>/tmp/.errlog
						wait
						check_for_error
					fi
				else
					dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "Node.js LTS" --msgbox "\nNode.js LTS - Package not found!\n${_nodejs_lts_pkg[1]}\n\n" 0 0
					wait
				fi
				;;
			*) nodejs_menu
				;;
		 esac
	else
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "Node.js LTS" --msgbox "\nNode.js LTS - Package not found!\n${_nodejs_lts_pkg[*]}\n\n" 0 0
		wait
		nodejs_menu
	fi
}
function nodejs_menu()
{
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "Node.js" --menu "$_progr_bd_2" 0 0 5 \
	"1" "Node.js" \
	"2" "Node.js LTS" \
	"3" "$_Back" 2>${ANSWER}
				
	 case $(cat ${ANSWER}) in
		"1") nodejs_install
			;;
		"2") nodejs_lts_install
			;;
		*) installing_programming
			;;
	esac
	nodejs_menu
}
installing_programming()
{
    if [[ $SUB_MENU != "programming_package" ]]; then
       SUB_MENU="programming_package"
       HIGHLIGHT_SUB=1
    else
       if [[ $HIGHLIGHT_SUB != 13 ]]; then
          HIGHLIGHT_SUB=$(( HIGHLIGHT_SUB + 1 ))
       fi
    fi
    
    dialog --default-item ${HIGHLIGHT_SUB} --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_progr_hd" --menu "$_progr_bd_2" 0 0 11 \
    "1" "Make / Cmake"
    "2" "Arduino" \
    "3" "C/C++" \
    "4" "MingW-W64" \
    "5" "GoLang" \
    "6" "Python 3" \
    "7" "Python 2" \
    "8" "QT Creator" \
    "9" "Java / Java IDE" \
    "10" "Perl" \
    "11" "Ruby" \
    "12" "Node.js" \
    "13" "$_Back" 2>${ANSWER}
    
    HIGHLIGHT_SUB=$(cat ${ANSWER})
    case $(cat ${ANSWER}) in
    "1") makecmake_install
		;;
    "2") arduino_install
         ;;
    "3") c_cpp_install
         ;;
    "4") mingww64_install
         ;;
    "5") golang_install
		 ;;
    "6") python3_install
         ;;
    "7") python2_install
         ;;
    "8") qtcreator_install
         ;;
    "9") java_install
         ;;
    "10") perl_install
         ;;
    "11") ruby_install
         ;;
    "12") nodejs_menu
		;;
      *) install_apps_menu
         ;;
    esac
    
    check_for_error
    
    install_programming
}
