######################################################################
##                                                                  ##
##                     Network Functions                            ##
##                                                                  ##
###################################################################### 

function outline_dhcpcd()
{
	if [[ $_dhcpcd_out_once -eq 0 ]]; then
		_dhcpcd_out_once=1
		echo "" >> ${MOUNTPOINT}/etc/dhcpcd.conf
		echo "# /etc/dhcpcd.conf" >> ${MOUNTPOINT}/etc/dhcpcd.conf
		echo "" >> ${MOUNTPOINT}/etc/dhcpcd.conf
		echo "# define static profile" >> ${MOUNTPOINT}/etc/dhcpcd.conf
		echo "# profile static_eth0" >> ${MOUNTPOINT}/etc/dhcpcd.conf
		echo "# profile static_eth0" >> ${MOUNTPOINT}/etc/dhcpcd.conf
		echo "# static ip_address=192.168.1.1" >> ${MOUNTPOINT}/etc/dhcpcd.conf
		echo "# static routers=192.168.1.23" >> ${MOUNTPOINT}/etc/dhcpcd.conf
		echo "# static domain_name_servers=192.168.1.23" >> ${MOUNTPOINT}/etc/dhcpcd.conf
		echo "" >> ${MOUNTPOINT}/etc/dhcpcd.conf
		echo "# # fallback to static profile on eth0" >> ${MOUNTPOINT}/etc/dhcpcd.conf
		echo "# interface eth0" >> ${MOUNTPOINT}/etc/dhcpcd.conf
		echo "# fallback static_eth0" >> ${MOUNTPOINT}/etc/dhcpcd.conf
	fi	
}

function netctl_template_setup()
{
	function check_ntctl_template()
	{
		if [[ $1 == *"wireless"* ]]; then
			dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_msg_wt_ttl" --msgbox "$_msg_wt_bd" 0 0
			dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_ib_ssid_ttl" --inputbox "$_ib_ssid_bd" 0 0 "" 2>${ANSWER}
			_wifi_ssid=$(cat ${ANSWER})
			dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_ib_pass_ttl" --inputbox "$_ib_pass_bd" 0 0 "" 2>${ANSWER}
			_wifi_pass=$(cat ${ANSWER})
			if [[ ${_wifi_ssid[*]} != "" ]]; then
				if [[ ${_wifi_pass[*]} != "" ]]; then
					wpa_passphrase ${_wifi_ssid[*]} ${_wifi_pass[*]} | sed -E 's/^/\# /g' >> "$2"
				fi
			fi
		fi
	}
	if [[ $_netctl_mn_once -eq 0 ]]; then
		_netctl_mn_once=1
		_netctl_template=$(find  "$_ntctl_tmp/" -maxdepth 1 -type f | rev | cut -d '/' -f1 | rev)
		_netctl_tmp=( $_netctl_template )
		unset _netctl_template
		_netctl_menu=""
		for i in ${_netctl_tmp[*]}; do
			_netctl_menu="${_netctl_menu} $i -"
		done
		_netctl_menu="${_netctl_menu} Back -"
	fi
	dialog --defaultno --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_yn_netctl_ttl" --yesno "$_yn_netctl_bd" 0 0
	if [[ $? -eq 0 ]]; then
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_yn_netctl_ttl" --menu "$_ntctl_tmpmn_bd" 0 0 16 ${_netctl_menu} 2>${ANSWER}
		_ch_netctl_mn=$(cat ${ANSWER})
		if [[ ${_ch_netctl_mn[*]} != "Back" ]]; then
			dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_inntctl_ttl" --inputbox "$_inntctl_bd" 0 0 "" 2>${ANSWER}
			_cntctl_nname=$(cat ${ANSWER})
			if [[ ${_cntctl_nname[*]} != "" ]]; then
				_ncl_oname="${_ch_netctl_mn[*]}"
				unset _chl_netctl_mn
				_ncl_nname="${_cntctl_nname[*]}"
				unset _ctctl_nname
				cp -f "$_ntctl_tmp/$_ncl_oname" "$_ntctl_fl/$_ncl_nname"
				check_ntctl_template "$_ncl_oname" "$_ntctl_fl/$_ncl_nname"
				arch_chroot "netctl start $_ncl_nname" 2>/tmp/.errlog
				arch_chroot "netctl enable $_ncl_nname" 2>/tmp/.errlog
				check_for_error
				unset _ncl_oname
				unset _ncl_nname
				wait
				sudo nano "$_ntctl_fl/$_ncl_nname"
				wait
				_netctl_edit="$_ntctl_fl/$_ncl_nname"
			fi
		else
			install_desktop_menu
		fi
	fi
}

function netctl_instalation()
{
	pacstrap ${MOUNTPOINT} ${_network_menu[0]} 2>/tmp/.errlog
	check_for_error
	wait
	install_shara_components
	wait
	netctl_template_setup
	wait
}

install_shara_components()
{
    if [[ $_shara_p == "0" ]]; then
        dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_yesno_shara_title" --yesno "$_yesno_shara_body" 0 0
        if [[ $? -eq 0 ]]; then
            _shara_p=1
            clear
            info_search_pkg
            _list_network_pkg=$(check_s_lst_pkg "${_network_pkg[*]}")
            wait
            _clist_list_network_pkg=$(check_q_lst_pkg "${_list_network_pkg[*]}")
            wait
            clear
            dialog --defaultno --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_yesno_shara_title" --yesno "$_yn_alsa_pkg_bd" 0 0
             if [[ $? -eq 0 ]]; then
                _shara_pkg_mn_list=""
                for k in ${_clist_list_network_pkg[*]}; do  
                    _shara_pkg_mn_list="${_shara_pkg_mn_list} $k - on"
                done
                dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_chl_shara_ttl" --checklist "$_chl_xpkg_bd" 0 0 16 ${_shara_pkg_mn_list} 2>${ANSWER}
                _check_shara_pkg=$(cat ${ANSWER})
                [[ ${_check_shara_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_check_shara_pkg[*]} 2>/tmp/.errlog
             else
                pacstrap ${MOUNTPOINT} ${_clist_list_network_pkg[*]} 2>/tmp/.errlog
             fi
             check_for_error
        fi
    fi
}
