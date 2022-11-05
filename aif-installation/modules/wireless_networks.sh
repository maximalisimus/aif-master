######################################################################
##                                                                  ##
##                  Wireless Network Functions                      ##
##                                                                  ##
######################################################################  

install_wireless_programm()
{
    if [[ $_net_cntrl == "0" ]]; then
        dialog --defaultno --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_yesno_iwp_title" --yesno "$_yesno_iwp_body" 0 0
        if [[ $? -eq 0 ]]; then
            _net_cntrl=1
            clear
            info_search_pkg
            _list_wifi_pkg=$(check_s_lst_pkg "${_wifi_pkg[*]}")
            wait
            clear
            [[ ${_list_wifi_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_list_wifi_pkg[*]} 2>>/tmp/.errlog
        fi
    fi
}

# Needed for broadcom and other network controllers
install_wireless_firmware() {
	
	if [[ $SUB_MENU != "wireless_firmware" ]]; then
		SUB_MENU="wireless_firmware"
		HIGHLIGHT_SUB=1
	else
		if [[ $HIGHLIGHT_SUB != 3 ]]; then
			HIGHLIGHT_SUB=$(( HIGHLIGHT_SUB + 1 ))
		fi
	fi
	
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_WirelssFirmTitle" --menu "$_WirelssFirmBody" 0 0 3 \
	"1" "${_SeeWirelessDev}" \
	"2" "Broadcom_802.11b/g/n" \
	"3" "$_Back" 2>${ANSWER}
	
	case $(cat ${ANSWER}) in
		"1") # Identify the Wireless Device 
				lspci -k | grep -i -A 2 "network controller" > /tmp/.wireless
				wait
				if [[ $(cat /tmp/.wireless) != "" ]]; then
					dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_WirelessShowTitle" --textbox /tmp/.wireless 0 0
				else
					dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_WirelessShowTitle" --msgbox "$_WirelessErrBody" 7 30
				fi
			;;
		"2") # Broadcom
				clear
				_list_broadcom=$(check_s_lst_pkg "${_broadcom[*]}")
				[[ "${_list_broadcom[*]}" != "" ]] && pacstrap ${MOUNTPOINT} ${_list_broadcom[*]} 2>/tmp/.errlog
				wait
				install_wireless_programm
			;;
		*) install_base_menu
			;;
	esac
	wait
	check_for_error
	wait
	install_wireless_firmware
}

bluetooth_install()
{
    clear
    info_search_pkg
    _list_bluetooth=$(check_s_lst_pkg "${_bluetooth[*]}")
    wait
    clear
    if [[ ${_list_bluetooth[*]} != "" ]]; then
        ps_in_pkg "${_list_bluetooth[*]}"
        
        sed -i 's/\#AutoEnable=false/AutoEnable=true/' ${MOUNTPOINT}/etc/bluetooth/main.conf
        if [ -e ${MOUNTPOINT}/etc/modprobe.d ]; then
                if [ -e ${MOUNTPOINT}/etc/modprobe.d/disable_bluetooth_ertm.conf ]; then
                    echo "options bluetooth disable_ertm=1" >> ${MOUNTPOINT}/etc/modprobe.d/disable_bluetooth_ertm.conf
                else
                    echo "options bluetooth disable_ertm=1" > ${MOUNTPOINT}/etc/modprobe.d/disable_bluetooth_ertm.conf
                fi
            else
                sudo mkdir /etc/modprobe.d
                if [ -e ${MOUNTPOINT}/etc/modprobe.d/disable_bluetooth_ertm.conf ]; then
                    echo "options bluetooth disable_ertm=1" >> ${MOUNTPOINT}/etc/modprobe.d/disable_bluetooth_ertm.conf
                else
                    echo "options bluetooth disable_ertm=1" > ${MOUNTPOINT}/etc/modprobe.d/disable_bluetooth_ertm.conf
                fi
        fi
        arch_chroot "systemctl enable bluetooth.service" 2>/tmp/.errlog
    fi  
    check_for_error
}

bluetooth_question()
{
	if [[ "${_bltth}" == "0"  ]]; then
		dialog --defaultno --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_yesno_bluetooth_ttl" --yesno "$_yesno_bluetooth_bd" 0 0
		if [[ $? -eq 0 ]]; then
			bluetooth_install
			_bltth=1
		fi
	fi
}

