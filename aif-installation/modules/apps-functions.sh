######################################################################
##                                                                  ##
##                   Package Menu functions                         ##
##                                                                  ##
######################################################################

list_of_apps_write()
{
	if [[ $_apps_desktop_once == "0" ]]; then
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_lst_of_apps_hd" --yesno "$_lst_of_apps_yn" 0 0
		if [[ $? -eq 0 ]]; then
			_apps_desktop_once=1
			echo "[Desktop Entry]" > "${MOUNTPOINT}/usr/share/applications/List_of_applications_EN.desktop"
			echo "Encoding=UTF-8" >> "${MOUNTPOINT}/usr/share/applications/List_of_applications_EN.desktop"
			echo "URL=https://wiki.archlinux.org/title/List_of_applications" >> "${MOUNTPOINT}/usr/share/applications/List_of_applications_EN.desktop"
			echo "Type=Link" >> "${MOUNTPOINT}/usr/share/applications/List_of_applications_EN.desktop"
			echo "Name=List of Apps EN" >> "${MOUNTPOINT}/usr/share/applications/List_of_applications_EN.desktop"
			echo "Icon=text-html" >> "${MOUNTPOINT}/usr/share/applications/List_of_applications_EN.desktop"
			echo "Categories=Network;System;" >> "${MOUNTPOINT}/usr/share/applications/List_of_applications_EN.desktop"
			echo "Comment=List of Applications EN" >> "${MOUNTPOINT}/usr/share/applications/List_of_applications_EN.desktop"
			echo "Keywords=applications;" >> "${MOUNTPOINT}/usr/share/applications/List_of_applications_EN.desktop"
			echo "" >> "${MOUNTPOINT}/usr/share/applications/List_of_applications_EN.desktop"
			chmod +x "${MOUNTPOINT}/usr/share/applications/List_of_applications_EN.desktop"
			wait
			echo "[Desktop Entry]" > "${MOUNTPOINT}/usr/share/applications/List_of_applications_RU.desktop"
			echo "Encoding=UTF-8" >> "${MOUNTPOINT}/usr/share/applications/List_of_applications_RU.desktop"
			echo "URL=https://www.linuxsecrets.com/archlinux-wiki/wiki.archlinux.org/index.php/List_of_applications_(%D0%A0%D1%2583%D1%2581%D1%2581%D0%BA%D0%B8%D0%B9).html" >> "${MOUNTPOINT}/usr/share/applications/List_of_applications_RU.desktop"
			echo "Type=Link" >> "${MOUNTPOINT}/usr/share/applications/List_of_applications_RU.desktop"
			echo "Name=List of Apps RU" >> "${MOUNTPOINT}/usr/share/applications/List_of_applications_RU.desktop"
			echo "Icon=text-html" >> "${MOUNTPOINT}/usr/share/applications/List_of_applications_RU.desktop"
			echo "Categories=Network;System;" >> "${MOUNTPOINT}/usr/share/applications/List_of_applications_RU.desktop"
			echo "Comment=List of Applications RU" >> "${MOUNTPOINT}/usr/share/applications/List_of_applications_RU.desktop"
			echo "Keywords=applications;" >> "${MOUNTPOINT}/usr/share/applications/List_of_applications_RU.desktop"
			echo "" >> "${MOUNTPOINT}/usr/share/applications/List_of_applications_RU.desktop"
			chmod +x "${MOUNTPOINT}/usr/share/applications/List_of_applications_RU.desktop"
			wait
			dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_lst_of_apps_hd" --msgbox "$_lst_of_apps_msg" 0 0
			wait
		fi
	else
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_lst_of_apps_hd" --msgbox "$_lst_of_apps_msg" 0 0
		wait
	fi	
}

install_apps_menu()
{
    if [[ $SUB_MENU != "general_package" ]]; then
       SUB_MENU="general_package"
       HIGHLIGHT_SUB=1
    else
       if [[ $HIGHLIGHT_SUB != 10 ]]; then
          HIGHLIGHT_SUB=$(( HIGHLIGHT_SUB + 1 ))
       fi
    fi
    
    if [[ ${_archi[*]} == "x86_64" ]]; then
		dialog --default-item ${HIGHLIGHT_SUB} --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_menu_gen_title" --menu "$_menu_gen_body" 0 0 10 \
		"1" "$" \
		"2" "$" \
		"3" "$" \
		"4" "$" \
		"5" "$" \
		"6" "$" \
		"7" "$_MMInstServer" \
		"8" "$_progr_hd" \
		"9" "$_lst_of_apps_hd" \
		"10" "$_Back" 2>${ANSWER}
	else
		dialog --default-item ${HIGHLIGHT_SUB} --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_menu_gen_title" --menu "$_menu_gen_body" 0 0 10 \
		"1" "$" \
		"2" "$" \
		"3" "$" \
		"4" "$" \
		"5" "$" \
		"6" "$" \
		"7" "$_MMInstServer" \
		"8" "$_progr_hd" \
		"9" "$_lst_of_apps_hd" \
		"10" "$_Back" 2>${ANSWER}
	fi
    
    HIGHLIGHT_SUB=$(cat ${ANSWER})
    case $(cat ${ANSWER}) in
    "1") 
         ;;
    "2") 
         ;;
    "3") 
         ;;
    "4") 
         ;;
    "5") 
         ;;
    "6") 
         ;;
    "7") server_menu
		;;
	"8") installing_programming
		;;
	"9") list_of_apps_write
		;;
      *) install_desktop_menu
         ;;
    esac
    
    check_for_error
    
    install_apps_menu
}
