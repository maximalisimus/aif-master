######################################################################
##                                                                  ##
##                    SSH Configuration                             ##
##                                                                  ##
######################################################################

info_ssh_connect()
{
	clear
	_myip="$1"
	_usr_lst=$(ls "${MOUNTPOINT}"/home/ | sed "s/lost+found//")
	_user_lists=( "${_usr_lst[*]}" )
	unset _usr_lst
	_nfo_ssh_info="${_nfo_ssh_bd} ${_myip} \n${_nfo_ssh_prmr} ${_user_lists[0]}@${_myip}"
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_msg_ssh_nfo_ttl" --msgbox "$_nfo_ssh_info" 0 0
	wait
	unset _myip
	unset _user_lists
	unset _nfo_ssh_info
}

edit_file_sshd()
{
	SSHD_FILES="${MOUNTPOINT}/etc/ssh/sshd_config"
	if [[ -e "$SSHD_FILES" ]]; then
		nano "$SSHD_FILES"
		wait
	else
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_SeeConfErrTitle" --msgbox "$_SeeConfErrBody1" 0 0
		wait
	fi
	menu_conf_ssh
}

function onoff_prmrtlg()
{
	if [[ $_prmtrtlg_once -eq "0" ]]; then
		# echo "PermitRootLogin no" >> ${MOUNTPOINT}/etc/ssh/sshd_config
		sed -i "/^#PermitRootLogin/c PermitRootLogin no" "${MOUNTPOINT}"/etc/ssh/sshd_config
		_prmtrtlg_once=1
		_prmtrtlg_clck=1
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_cnf_ssh_2" --msgbox "$_nff_ptrtlg_bd_2" 0 0
	else
		if [[ $_prmtrtlg_clck -eq "0" ]]; then
			sed -i "/^PermitRootLogin/c PermitRootLogin no" "${MOUNTPOINT}"/etc/ssh/sshd_config
			_prmtrtlg_clck=1
			dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_cnf_ssh_2" --msgbox "$_nff_ptrtlg_bd_2" 0 0
		else
			_prmtrtlg_clck=0
			sed -i "/^PermitRootLogin/c PermitRootLogin yes" "${MOUNTPOINT}"/etc/ssh/sshd_config
			dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_cnf_ssh_2" --msgbox "$_nff_ptrtlg_bd_1" 0 0
		fi
	fi
}

function port_ssh_conf()
{
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_cnf_ssh_1" --inputbox "$_sshcnf_port_bd" 0 0 "" 2>${ANSWER}
	declare -i _ch_sshcnf_port
	_ch_sshcnf_port=$(cat ${ANSWER})
	clear
	while [[ $_ch_sshcnf_port -le 1025 ]]; do
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_nfo_ssh_port_ttl" --msgbox "$_nfo_ssh_port_bd" 0 0
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_cnf_ssh_1" --inputbox "$_sshcnf_port_bd" 0 0 "" 2>${ANSWER}
		_ch_sshcnf_port=$(cat ${ANSWER})
		while [[ $_ch_sshcnf_port -ge 65536 ]]; do
			dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_nfo_ssh_port_ttl" --msgbox "$_nfo_ssh_port_bd" 0 0
			dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_cnf_ssh_1" --inputbox "$_sshcnf_port_bd" 0 0 "" 2>${ANSWER}
			_ch_sshcnf_port=$(cat ${ANSWER})
		done
	done
	while [[ $_ch_sshcnf_port -ge 65536 ]]; do
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_nfo_ssh_port_ttl" --msgbox "$_nfo_ssh_port_bd" 0 0
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_cnf_ssh_1" --inputbox "$_sshcnf_port_bd" 0 0 "" 2>${ANSWER}
		_ch_sshcnf_port=$(cat ${ANSWER})
		while [[ $_ch_sshcnf_port -le 1025 ]]; do
			dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_nfo_ssh_port_ttl" --msgbox "$_nfo_ssh_port_bd" 0 0
			dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_cnf_ssh_1" --inputbox "$_sshcnf_port_bd" 0 0 "" 2>${ANSWER}
			_ch_sshcnf_port=$(cat ${ANSWER})
		done
	done
	clear
	_str="${_ch_sshcnf_port[*]}"
	unset _ch_sshcnf_port
	sed -i "/^\#Port/c Port $_str" "${MOUNTPOINT}"/etc/ssh/sshd_config
	sed -i "/^Port/c Port $_str" "${MOUNTPOINT}"/etc/ssh/sshd_config
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_port_ssh_hd" --msgbox "${_port_ssh_msg} ${_str}." 0 0
}

function protocol_ssh()
{
	_protocol_str=$(cat "${MOUNTPOINT}"/etc/ssh/sshd_config | grep -Ei "Protocol")
	wait
	if [[ ${_protocol_str} == "" ]]; then
		dialog --defaultno --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_yn_ssh_qn" --yesno "$_protocol_ssh_bd" 0 0
		if [[ $? -eq 0 ]]; then
			sed -i "/Port/i\Protocol 2" "${MOUNTPOINT}"/etc/ssh/sshd_config
			dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_protocol_ssh_hd" --msgbox "$_protocol_ssh_msg" 0 0
		fi
	else
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_protocol_ssh_hd" --msgbox "$_protocol_ssh_msg" 0 0
	fi
}

function pass_auth_conf()
{
	if [[ $_pass_authentication_once -eq 0 ]]; then
		sed -i "/^\#PasswordAuthentication/s/\#//g" "${MOUNTPOINT}"/etc/ssh/sshd_config
		_pass_authentication_once=1
	fi
	wait
	_pass_auth_state=$(cat "${MOUNTPOINT}"/etc/ssh/sshd_config | grep -Ei "^PasswordAuthentication" | cut -d ' ' -f2)
	if [[ "$_pass_auth_state" == *"yes"* ]]; then
		sed -i "/^PasswordAuthentication/s/yes/no/g" "${MOUNTPOINT}"/etc/ssh/sshd_config
		wait
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_pass_auth_hd" --msgbox "$_pass_auth_st_1" 0 0
	else
		sed -i "/^PasswordAuthentication/s/no/yes/g" "${MOUNTPOINT}"/etc/ssh/sshd_config
		wait
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_pass_auth_hd" --msgbox "$_pass_auth_st_2" 0 0
	fi
}

function pubkey_auth_conf()
{
	if [[ $_pubkey_once -eq 0 ]]; then
		sed -i "/^\#PubkeyAuthentication/s/\#//g" "${MOUNTPOINT}"/etc/ssh/sshd_config
		_pubkey_once=1
	else
		wait
		_pabkey_auth_state=$(cat "${MOUNTPOINT}"/etc/ssh/sshd_config | grep -Ei "^PubkeyAuthentication" | cut -d ' ' -f2)
		if [[ "$_pabkey_auth_state" == *"yes"* ]]; then
			sed -i "/^PubkeyAuthentication/s/yes/no/g" "${MOUNTPOINT}"/etc/ssh/sshd_config
			wait
			dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_auth_publ_hd" --msgbox "$_auth_publ_st_2" 0 0
		else
			sed -i "/^PubkeyAuthentication/s/no/yes/g" "${MOUNTPOINT}"/etc/ssh/sshd_config
			wait
			dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_auth_publ_hd" --msgbox "$_auth_publ_st_1" 0 0
		fi
	fi
}

function keyfile_config()
{
	if [[ $_keyfile_once -eq 0 ]]; then
		_keyfile_once=1
		sed -i "/^\#AuthorizedKeysFile/s/\#//g" "${MOUNTPOINT}"/etc/ssh/sshd_config
	fi
	_keyfile_read=$(cat "${MOUNTPOINT}"/etc/ssh/sshd_config | grep -Ei "^AuthorizedKeysFile" | awk '{print $2}')
	dialog --defaultno --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_auth_keyf_hd" --yesno "${_auth_keyf_default}\n${_keyfile_read}\n${_auth_keyf_bd}\n" 0 0
	if [[ $? -eq 0 ]]; then
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_auth_keyf_edit_hd" --inputbox "$_auth_keyf_edit_bd" 0 0 "" 2>${ANSWER}
		new_ssh_keyfile=$(cat ${ANSWER})
		if [ -e "${new_ssh_keyfile}" ]; then
			sed -i "/^AuthorizedKeysFile/c AuthorizedKeysFile ${new_ssh_keyfile}" "${MOUNTPOINT}"/etc/ssh/sshd_config
		else
			touch "${new_ssh_keyfile}" || echo "" > "${new_ssh_keyfile}"
			sed -i "/^AuthorizedKeysFile/c AuthorizedKeysFile ${new_ssh_keyfile}" "${MOUNTPOINT}"/etc/ssh/sshd_config
		fi
	fi
}

function alive_interval_config()
{
	if [[ $_client_session_once -eq 0 ]]; then
		_client_session_once=1
		sed -i "/^\#ClientAliveInterval/s/\#//g" "${MOUNTPOINT}"/etc/ssh/sshd_config
	fi
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_client_session_hd_1" --inputbox "$_client_session_bd_1" 0 0 "" 2>${ANSWER}
	time_session=$(cat ${ANSWER})
	sed -i "/^ClientAliveInterval/c ClientAliveInterval ${time_session}" "${MOUNTPOINT}"/etc/ssh/sshd_config
}

function alive_count_config()
{
	if [[ $client_count_once -eq 0 ]]; then
		client_count_once=1
		sed -i "/^\#ClientAliveCountMax/s/\#//g" "${MOUNTPOINT}"/etc/ssh/sshd_config
	fi
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_client_session_hd_2" --inputbox "$_client_session_bd_2" 0 0 "" 2>${ANSWER}
	count_session=$(cat ${ANSWER})
	sed -i "/^ClientAliveCountMax/c ClientAliveCountMax ${count_session}" "${MOUNTPOINT}"/etc/ssh/sshd_config
}

menu_sshd_config()
{
	if [[ $SUB_MENU != "sshd-config" ]]; then
       SUB_MENU="sshd-config"
       HIGHLIGHT_SUB=1
    else
       if [[ $HIGHLIGHT_SUB != 18 ]]; then
          HIGHLIGHT_SUB=$(( HIGHLIGHT_SUB + 1 ))
       fi
    fi
    
    dialog --default-item ${HIGHLIGHT_SUB} --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_edit_sshd_hd2" \
	--menu "$_edit_sshd_bd" 0 0 11 \
	"1" "$_yn_ssh_qn" \
	"2" "$_protocol_ssh_hd" \
 	"3" "$_mn_cnf_ssh_1" \
 	"4" "$_pass_auth_hd" \
 	"5" "$_auth_publ_hd" \
 	"6" "$_auth_keyf_hd" \
 	"7" "$_client_session_hd_1" \
 	"8" "$_client_session_hd_2" \
 	"9" "$_rhosts_hd" \
 	"10" "$_host_auth_hd" \
	"11" "$_mn_cnf_ssh_2" \
	"12" "$_empty_pass_hd" \
	"13" "$_logs_ssh_hd" \
	"14" "$_x11_ssh_hd" \
	"15" "$_allow_users_hd" \
	"16" "$_deny_users_hd" \
	"17" "$_allow_group_hd" \
	"18" "$_Back" 2>${ANSWER}
	case $(cat ${ANSWER}) in
		"1") dialog --defaultno --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_yn_ssh_qn" --yesno "$_yn_ssh_qn_bd" 0 0
			if [[ $? -eq 0 ]]; then
				cp -f ${_sshd_conf_file} ${_sshd_conf_dir}
			fi
			;;
		"2") protocol_ssh
			;;
		"3") port_ssh_conf
			;;
		"4") pass_auth_conf
			;;
		"5") pubkey_auth_conf
			;;
		"6") keyfile_config
			;;
		"7") alive_interval_config
			;;
		"8") alive_count_config
			;;
		"9") 
			;;
		"10") 
			;;
		"11") onoff_prmrtlg
			;;
		"12") 
			;;
		"13") 
			;;
		"14") 
			;;
		"15") 
			;;
		"16") 
			;;
		"17") 
			;;
		*) menu_conf_ssh
			;;
	esac
	menu_sshd_config
}

menu_conf_ssh()
{
	if [[ $SUB_MENU != "ssh-config" ]]; then
       SUB_MENU="ssh-config"
       HIGHLIGHT_SUB=1
    else
       if [[ $HIGHLIGHT_SUB != 5 ]]; then
          HIGHLIGHT_SUB=$(( HIGHLIGHT_SUB + 1 ))
       fi
    fi
	
	dialog --default-item ${HIGHLIGHT_SUB} --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_ssh_2" \
	--menu "$_mn_srv_bd" 0 0 5 \
	"1" "$_msg_ssh_nfo_ttl" \
	"2" "$_auto_sshd_nfo_hd" \
	"3" "$_edit_sshd_hd" \
	"4" "$_edit_sshd_hd2" \
	"5" "$_Back" 2>${ANSWER}
	case $(cat ${ANSWER}) in
		"1") info_ssh_connect
			;;
		"2") sshd_autostart
			;;
		"3") edit_file_sshd
			;;
		"4") menu_sshd_config
			;;
		*) server_menu
			;;
	esac
	menu_conf_ssh
}
