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
            [[ ${_list_wifi_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_list_wifi_pkg[*]} 2>/tmp/.errlog
        fi
    fi
}

# Needed for broadcom and other network controllers
install_wireless_firmware() {
    
    if [[ $_wifi_menu_form == 0 ]]; then
        _wifi_menu_form=1
        clear
        info_search_pkg
        _list_broadcom=$(check_s_lst_pkg "${_broadcom[*]}")
        wait
        _list_intel_2100=$(check_s_lst_pkg "${_intel_2100[*]}")
        wait
        _list_intel_2200=$(check_s_lst_pkg "${_intel_2200[*]}")
        wait
        [[ ${_list_broadcom[*]} != "" ]] && _list_wifi_adapter_pkg="${_list_wifi_adapter_pkg} ${_list_broadcom[*]}"
        [[ ${_list_intel_2100[*]} != "" ]] && _list_wifi_adapter_pkg="${_list_wifi_adapter_pkg} ${_list_intel_2100[*]}"
        [[ ${_list_intel_2200[*]} != "" ]] && _list_wifi_adapter_pkg="${_list_wifi_adapter_pkg} ${_list_intel_2200[*]}"
        _wifi_menu="${_menu_wifi[0]} -"
        for i in ${_list_wifi_adapter_pkg[*]}; do
            if [[ ! $i =~ .(2100) ]] && [[ ! $i =~ .(2200) ]]; then
                _wifi_menu="${_wifi_menu} ${_menu_wifi[1]} -"
            elif [[ $i =~ .(2100) ]]; then
                _wifi_menu="${_wifi_menu} ${_menu_wifi[2]} -"
            elif [[ $i =~ .(2200) ]]; then
                _wifi_menu="${_wifi_menu} ${_menu_wifi[3]} -"
            fi
        done
        _wifi_menu="${_wifi_menu} ${_menu_wifi[4]} -"
        _wifi_menu="${_wifi_menu} ${_menu_wifi[5]} -"
        clear
    fi
    
    check_mount
    
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_WirelssFirmTitle" --menu "$_WirelssFirmBody" 0 0 6 ${_wifi_menu} 2>${ANSWER}
    
    case $(cat ${ANSWER}) in
    "${_menu_wifi[0]}") # Identify the Wireless Device 
        lspci -k | grep -i -A 2 "network controller" > /tmp/.wireless
        if [[ $(cat /tmp/.wireless) != "" ]]; then
           dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_WirelessShowTitle" --textbox /tmp/.wireless 0 0
        else
           dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_WirelessShowTitle" --msgbox "$_WirelessErrBody" 7 30
        fi
        ;;
    "${_menu_wifi[1]}") # Broadcom
         clear
         pacstrap ${MOUNTPOINT} ${_list_broadcom[*]} 2>/tmp/.errlog
         install_wireless_programm
        ;;
    "${_menu_wifi[2]}") # Intel 2100
         clear
         pacstrap ${MOUNTPOINT} ${_list_intel_2100[*]} 2>/tmp/.errlog
         install_wireless_programm
        ;;
    "${_menu_wifi[3]}") # Intel 2200
         clear
         pacstrap ${MOUNTPOINT} ${_list_intel_2200[*]} 2>/tmp/.errlog
         install_wireless_programm
        ;;
    "${_menu_wifi[4]}") # All
         clear
         pacstrap ${MOUNTPOINT} ${_list_wifi_adapter_pkg[*]} 2>/tmp/.errlog
         install_wireless_programm
        ;;
      *) install_base_menu
        ;;
    esac
    
    check_for_error
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
    if [[ _bltth == "0"  ]]; then
        dialog --defaultno --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_yesno_bluetooth_ttl" --yesno "$_yesno_bluetooth_bd" 0 0
        if [[ $? -eq 0 ]]; then
            bluetooth_install
            _bltth=1
        fi
    fi
}

