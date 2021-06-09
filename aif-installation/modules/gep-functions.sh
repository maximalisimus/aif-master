######################################################################
##                                                                  ##
##                   Package Menu functions                         ##
##                                                                  ##
######################################################################

install_gengen()
{
    _gengen_menu=""
    if [[ $_gengen_once == "0" ]]; then
        _gengen_once=1
        clear
        info_search_pkg
        _list_general_pkg=$(check_s_lst_pkg "${_general_pkg[*]}")
        wait
        _gengen_menu=""
        for i in ${_list_general_pkg[*]}; do
            _gengen_menu="${_gengen_menu} ${i} - on"
        done
        wait
        clear
    fi
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_menu_gengen" --checklist "$_ch_mn_bd" 0 0 16 ${_gengen_menu} 2>${ANSWER}
    _ch_gengen=$(cat ${ANSWER})
    clear
    [[ ${_ch_gengen[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_ch_gengen[*]} 2>/tmp/.errlog
    arch_chroot "systemctl enable acpid avahi-daemon cronie org.cups.cupsd.service systemd-timesyncd.service" 2>/tmp/.errlog
    check_for_error
}
install_archivers()
{
    if [[ $_archivers_once == "0" ]]; then
        _archivers_once=1
        clear
        info_search_pkg
        _list_archivers_pkg=$(check_s_lst_pkg "${_archivers_pkg[*]}")
        wait
        _clist_archivers_pkg=$(check_q_lst_pkg "${_list_archivers_pkg[*]}")
        wait
        for i in ${_clist_archivers_pkg[*]}; do
            archivers_menu="${archivers_menu} ${i} - on"
        done
        wait
        clear
    fi
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_menu_archivers" --checklist "$_ch_mn_bd" 0 0 16 ${archivers_menu} 2>${ANSWER}
    _ch_archivers=$(cat ${ANSWER})
    clear
    [[ ${_ch_archivers[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_ch_archivers[*]} 2>/tmp/.errlog
}

install_ttftheme()
{
    if [[ $_ttf_once == "0" ]]; then
        _ttf_once=1
        clear
        info_search_pkg
        _list_ttf_theme_pkg=$(check_s_lst_pkg "${_ttf_theme_pkg[*]}")
        wait
        _clist_ttf_theme_pkg=$(check_q_lst_pkg "${_list_ttf_theme_pkg[*]}")
        wait
        for i in ${_clist_ttf_theme_pkg[*]}; do
            _ttf_menu="${_ttf_menu} ${i} - on"
        done
        wait
        clear
    fi
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_menu_ttf_theme" --checklist "$_ch_mn_bd" 0 0 16 ${_ttf_menu} 2>${ANSWER}
    _ch_ttf=$(cat ${ANSWER})
    clear
    [[ ${_ch_ttf[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_ch_ttf[*]} 2>/tmp/.errlog
    check_for_error
}
install_standartpkg()
{
    if [[ $_stpkg_once == "0" ]]; then
        _stpkg_once=1
        clear
        info_search_pkg
        _list_gr_editor=$(check_s_lst_pkg "${_gr_editor[*]}")
        wait
        [[ ${_list_gr_editor[*]} != "" ]] && _tr_gr_editor=$(search_translit_pkg "${_gr_editor[*]}" "$_user_local")
        wait
        [[ ${_tr_gr_editor[*]} != "" ]] && _list_gr_editor="${_list_gr_editor} ${_tr_gr_editor[*]}"
        _list_office=$(check_s_lst_pkg "${_office}")
        wait
        [[ ${_list_office[*]} != "" ]] && _tr_office=$(search_translit_pkg "${_office}" "$_user_local")
        wait
        [[ ${_tr_office[*]} != "" ]] && _list_office="${_list_office} ${_tr_office[*]}"
        _list_minimal_pkg=$(check_s_lst_pkg "${_minimal_pkg[*]}")
        wait
        [[ ${_list_gr_editor[*]} != "" ]] && _list_minimal_pkg="${_list_minimal_pkg} ${_list_gr_editor[*]}"
        [[ ${_list_office[*]} != "" ]] && _list_minimal_pkg="${_list_minimal_pkg} ${_list_office[*]}"
        wait
        _clist_minimal_pkg=$(check_q_lst_pkg "${_list_minimal_pkg[*]}")
        wait
        for i in ${_clist_minimal_pkg[*]}; do
            _standart_pkg_menu="${_standart_pkg_menu} ${i} - off"
        done
        _standart_pkg_menu="${_standart_pkg_menu} ${_gr_editor[*]} - on"
        wait
        clear
    fi
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_menu_add_pkg" --checklist "$_ch_mn_bd" 0 0 16 ${_standart_pkg_menu} 2>${ANSWER}
    _ch_standart_pkg=$(cat ${ANSWER})
    clear
    [[ ${_ch_standart_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_ch_standart_pkg[*]} 2>/tmp/.errlog
}
install_otherpkg()
{
    if [[ $_other_pkg_once == "0" ]]; then
        _other_pkg_once=1
        clear
        info_search_pkg
        _list_other_pkg=$(check_s_lst_pkg "${_other_pkg[*]}")
        wait
        _clist_other_pkg=$(check_q_lst_pkg "${_list_other_pkg[*]}")
        wait
        for i in ${_clist_other_pkg[*]}; do
            _other_pkg_menu="${_other_pkg_menu} ${i} - off"
        done
        clear
    fi
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_menu_extra_pkg" --checklist "$_ch_mn_bd" 0 0 16 ${_other_pkg_menu} 2>${ANSWER}
    _ch_other_pkg=$(cat ${ANSWER})
    clear
    [[ ${_ch_other_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_ch_other_pkg[*]} 2>/tmp/.errlog
}

apps_desktop_install()
{
	if [[ $_apps_desktop_once == "0" ]]; then
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_lst_of_apps_hd" --yesno "$_lst_of_apps_yn" 0 0
		if [[ $? -eq 0 ]]; then
			_apps_desktop_once=1
			_user_lists=$(ls ${MOUNTPOINT}/home/ | sed "s/lost+found//")
			wait
			for j in ${_usr_list[*]}; do
				echo "[Desktop Entry]" > "${MOUNTPOINT}/home/${j}/List_of_applications.desktop"
				echo "Encoding=UTF-8" >> "${MOUNTPOINT}/home/${j}/List_of_applications.desktop"
				echo "URL=https://wiki.archlinux.org/title/List_of_applications" >> "${MOUNTPOINT}/home/${j}/List_of_applications.desktop"
				echo "Type=Link" >> "${MOUNTPOINT}/home/${j}/List_of_applications.desktop"
				echo "Name=List of Applications" >> "${MOUNTPOINT}/home/${j}/List_of_applications.desktop"
				echo "Icon=text-html" >> "${MOUNTPOINT}/home/${j}/List_of_applications.desktop"
				echo "" >> "${MOUNTPOINT}/home/${j}/List_of_applications.desktop"
				chmod +x "${MOUNTPOINT}/home/${j}/List_of_applications.desktop"
				wait
			done
			wait
			dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_lst_of_apps_hd" --msgbox "$_lst_of_apps_msg" 0 0
			wait
		fi
	else
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_lst_of_apps_hd" --msgbox "$_lst_of_apps_msg" 0 0
		wait
	fi	
}

install_gep()
{
    if [[ $SUB_MENU != "general_package" ]]; then
       SUB_MENU="general_package"
       HIGHLIGHT_SUB=1
    else
       if [[ $HIGHLIGHT_SUB != 10 ]]; then
          HIGHLIGHT_SUB=$(( HIGHLIGHT_SUB + 1 ))
       fi
    fi
    
    dialog --default-item ${HIGHLIGHT_SUB} --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_menu_gen_title" --menu "$_menu_gen_body" 0 0 10 \
    "1" "$_menu_gengen" \
    "2" "$_menu_archivers" \
    "3" "$_menu_ttf_theme" \
    "4" "$_menu_add_pkg" \
    "5" "$_menu_extra_pkg" \
    "6" "$_menu_pkg_meneger" \
    "7" "$_MMInstServer" \
    "8" "$_progr_hd" \
    "9" "$_lst_of_apps_hd" \
    "10" "$_Back" 2>${ANSWER}
    
    HIGHLIGHT_SUB=$(cat ${ANSWER})
    case $(cat ${ANSWER}) in
    "1") install_gengen
         ;;
    "2") install_archivers
         ;;
    "3") install_ttftheme
         ;;
    "4") install_standartpkg
         ;;
    "5") install_otherpkg
         ;;
    "6") pkg_manager_install
         ;;
    "7") server_menu
		;;
	"8") installing_programming
		;;
	"9") apps_desktop_install
		;;
      *) # Back to NAME Menu
        install_desktop_menu
         ;;
    esac
    
    check_for_error
    
    install_gep
}

# back - install_desktop_menu
install_gep_i686()
{
    if [[ $SUB_MENU != "general_package" ]]; then
       SUB_MENU="general_package"
       HIGHLIGHT_SUB=1
    else
       if [[ $HIGHLIGHT_SUB != 9 ]]; then
          HIGHLIGHT_SUB=$(( HIGHLIGHT_SUB + 1 ))
       fi
    fi
    
    dialog --default-item ${HIGHLIGHT_SUB} --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_menu_gen_title" --menu "$_menu_gen_body" 0 0 9 \
    "1" "$_menu_gengen" \
    "2" "$_menu_archivers" \
    "3" "$_menu_ttf_theme" \
    "4" "$_menu_add_pkg" \
    "5" "$_menu_extra_pkg" \
    "6" "$_MMInstServer" \
    "7" "$_progr_hd" \
    "8" "$_lst_of_apps_hd" \
    "9" "$_Back" 2>${ANSWER}
    
    HIGHLIGHT_SUB=$(cat ${ANSWER})
    case $(cat ${ANSWER}) in
    "1") install_gengen
         ;;
    "2") install_archivers
         ;;
    "3") install_ttftheme
         ;;
    "4") install_standartpkg
         ;;
    "5") install_otherpkg
         ;;
    "6") server_menu
		;;
	"7") installing_programming
		;;
	"8") apps_desktop_install
		;;
      *) # Back to NAME Menu
        install_desktop_menu
         ;;
    esac
    
    check_for_error
    
    install_gep_i686
}
