######################################################################
##                                                                  ##
##                    SSH Configuration                             ##
##                                                                  ##
######################################################################

function onoff_prmrtlg()
{
	if [[ $_prmtrtlg_once -eq "0" ]]; then
		# echo "PermitRootLogin no" >> ${MOUNTPOINT}/etc/ssh/sshd_config
		sed -i "/^#PermitRootLogin/c PermitRootLogin no" ${MOUNTPOINT}/etc/ssh/sshd_config
		_prmtrtlg_once=1
		_prmtrtlg_clck=1
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_cnf_ssh_2" --msgbox "$_nff_ptrtlg_bd_2" 0 0
	else
		if [[ $_prmtrtlg_clck -eq "0" ]]; then
			sed -i "/^PermitRootLogin/c PermitRootLogin no" ${MOUNTPOINT}/etc/ssh/sshd_config
			_prmtrtlg_clck=1
			dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_cnf_ssh_2" --msgbox "$_nff_ptrtlg_bd_2" 0 0
		else
			_prmtrtlg_clck=0
			sed -i "/^PermitRootLogin/c PermitRootLogin yes" ${MOUNTPOINT}/etc/ssh/sshd_config
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
	sed -i "/^\#Port/c Port $_str" ${MOUNTPOINT}/etc/ssh/sshd_config
	sed -i "/^Port/c Port $_str" ${MOUNTPOINT}/etc/ssh/sshd_config
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_port_ssh_hd" --msgbox "${_port_ssh_msg} ${_str}." 0 0
}

function protocol_ssh()
{
	sed -i "/Port/i\Protocol 2" ${MOUNTPOINT}/etc/ssh/sshd_config
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_protocol_ssh_hd" --msgbox "$_protocol_ssh_msg" 0 0
}

function info_ssh_connect()
{
	clear
	_myip="$1"
	_usr_lst=$(ls ${MOUNTPOINT}/home/ | sed "s/lost+found//")
	_user_lists=( "${_usr_lst[*]}" )
	unset _usr_lst
	_nfo_ssh_info="${_nfo_ssh_bd} ${_myip} \n${_nfo_ssh_prmr} ${_user_lists[0]}@${_myip}"
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_msg_ssh_nfo_ttl" --msgbox "$_nfo_ssh_info" 0 0
	wait
	unset _myip
	unset _user_lists
	unset _nfo_ssh_info
}

edit_menu_sshd()
{
	SSHD_FILES="${MOUNTPOINT}/etc/ssh/sshd_config"
	if [[ -e "$SSHD_FILES" ]]; then
		nano "$SSHD_FILES"
	else
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_SeeConfErrTitle" --msgbox "$_SeeConfErrBody1" 0 0
	fi
}

menu_conf_ssh()
{
	if [[ $SUB_MENU != "ssh-config" ]]; then
       SUB_MENU="ssh-config"
       HIGHLIGHT_SUB=1
    else
       if [[ $HIGHLIGHT_SUB != 8 ]]; then
          HIGHLIGHT_SUB=$(( HIGHLIGHT_SUB + 1 ))
       fi
    fi
	
	dialog --default-item ${HIGHLIGHT_SUB} --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_ssh_2" \
	--menu "$_mn_srv_bd" 0 0 8 \
	"1" "$_msg_ssh_nfo_ttl" \
	"2" "$_auto_sshd_nfo_hd" \
	"4" "$_yn_ssh_qn" \
	"5" "$_protocol_ssh_hd"
 	"6" "$_mn_cnf_ssh_1" \
	"7" "$_mn_cnf_ssh_2" \
	"8" "$_Back" 2>${ANSWER}
	case $(cat ${ANSWER}) in
		"1") info_ssh_connect
			;;
		"2") sshd_autostart
			;;
		"3") 
			;;
		"4") dialog --defaultno --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_yn_ssh_qn" --yesno "$_yn_ssh_qn_bd" 0 0
			if [[ $? -eq 0 ]]; then
				cp -f ${_sshd_conf_file} ${_sshd_conf_dir}
			fi
			;;
		"5") protocol_ssh
			;;
		"6") port_ssh_conf
			;;
		"7") onoff_prmrtlg
			;;
		*) server_menu
			;;
	esac
	menu_conf_ssh
}
