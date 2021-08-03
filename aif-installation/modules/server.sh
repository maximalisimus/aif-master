######################################################################
##                                                                  ##
##                Server installation functions                     ##
##                                                                  ##
######################################################################

function ftp_server_setup()
{
	if [[ $_ftp_srv_once -eq 0 ]]; then
		_ftp_srv_once=1
		_menu_list_ftp=""
		clear
		info_search_pkg
		_list_ftp_srv_pkg=$(check_s_lst_pkg "${_ftp_srv_pkg[*]}")
		wait
		clear
		for j in ${_list_ftp_srv_pkg[*]}; do
			_menu_list_ftp="${_menu_list_ftp} $j -"
		done
		_menu_list_ftp="${_menu_list_ftp} Back -"
	fi
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_srv_4" --menu "$_ftpsrv_mn_bd" 0 0 10 ${_menu_list_ftp} 2>${ANSWER}	
	_chl_ftpsrv=$(cat ${ANSWER})
	if [[ ${_chl_ftpsrv[*]} != "Back" ]]; then
		pacstrap ${MOUNTPOINT} ${_chl_ftpsrv[*]} 2>/tmp/.errlog
		check_for_error
	else
		server_menu
	fi
	server_menu
}

function namp_srv_setup()
{
	if [[ $_lmp_srv_once -eq 0 ]]; then
		_lmp_srv_once=1
		clear
		info_search_pkg
		_list_namp_srv=$(check_s_lst_pkg "${_namp_srv_pkg[*]}")
		wait
		clear
		for j in ${_list_namp_srv[*]}; do
			_lmenu_nmpsrv="${_lmenu_nmpsrv} $j - off"
		done
	fi
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_srv_3" --checklist "$_lmp_srv_bd" 0 0 7 ${_lmenu_nmpsrv} 2>${ANSWER}
	_chlmn_nmpsrv=$(cat ${ANSWER})
	[[ ${_chlmn_nmpsrv[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_chlmn_nmpsrv[*]} 2>/tmp/.errlog
	[[ ${_chlmn_nmpsrv[*]} != "" ]] && check_for_error
	[[ ${_chlmn_nmpsrv[*]} == *"nginx"* ]] && arch_chroot "systemctl enable nginx.service" 2>/tmp/.errlog
	[[ ${_chlmn_nmpsrv[*]} != "" ]] && check_for_error
}

function email_srv_setup()
{
	if [[ $_mail_srv_once -eq 0 ]]; then
		_mail_srv_once=1
		clear
		info_search_pkg
		_list_mail_srv=$(check_s_lst_pkg "${_mail_srv_pkg[*]}")
		wait
		clear
	fi
	dialog --defaultno --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_srv_2" --yesno "$_yn_mlsrv_bd" 0 0
	if [[ $? -eq 0 ]]; then
		[[ ${_list_mail_srv[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_list_mail_srv[*]} 2>/tmp/.errlog
		[[ ${_list_mail_srv[*]} != "" ]] && check_for_error
	fi
}

function docker_menu_setup()
{
	if [[ $_docker_run_once -eq 0 ]]; then
		clear
		_docker_run_once=1
		info_search_pkg
		_list_docker_pkg=$(check_s_lst_pkg "${_docker_pkg[*]}")
		wait
		clear
	fi
	dialog --defaultno --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_yn_mn_docker" --yesno "$_yn_mn_docker_bd" 0 0
	if [[ $? -eq 0 ]]; then
		pacstrap ${MOUNTPOINT} ${_list_docker_pkg[*]} 2>/tmp/.errlog
		wait
		check_for_error
		wait
		arch_chroot "systemctl enable docker.service" 2>/tmp/.errlog
		wait
		check_for_error
		wait
	fi
}
function antivirus_setup()
{
	if [[ $_clamav_once -eq 0 ]]; then
		clear
		_clamav_once=1
		info_search_pkg
		_list_clamav_pkg=$(check_s_lst_pkg "${_clamav_pkg[*]}")
		wait
		for j in ${_list_clamav_pkg[*]}; do
			_mn_clamav="${_mn_clamav} $j - off"
		done
		clear
	fi
	dialog --defaultno --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_antivirus_hd" --yesno "$_antivirus_yn_bd" 0 0
	if [[ $? -eq 0 ]]; then
		dialog --backtitle "VERSION - SYSTEM (ARCHI)" --title "$_antivirus_hd" --checklist "$_antivirus_bd" 0 0 5 ${_mn_clamav} 2>${ANSWER}
		wait
		variable=$(cat ${ANSWER})
		if [[ "${variable[*]}" == *"$_clamav_gui"* ]]; then
			dialog --defaultno --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_antivirus_hd" --yesno "$_antivirus_ctk_hd" 0 0
			if [[ $? -eq 0 ]]; then
				check_xorg
				wait
				check_de
				wait
				check_dm
				wait
				pacstrap ${MOUNTPOINT} ${variable[*]} 2>/tmp/.errlog
				wait
				check_for_error
				wait
			else
				antivirus_setup
			fi
		else
			pacstrap ${MOUNTPOINT} ${variable[*]} 2>/tmp/.errlog
			wait
			check_for_error
			wait
		fi
	fi
}
function sshd_autostart()
{
	if [[ $_auto_sshd_nfo_once -eq 0 ]]; then
		dialog --defaultno --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_auto_sshd_nfo_hd" --yesno "$_auto_sshd_nfo_bd" 0 0
		if [[ $? -eq 0 ]]; then
			_auto_sshd_nfo_once=1
			wait
			arch_chroot "systemctl enable sshd.service" 2>/tmp/.errlog
			wait
			check_for_error
			wait
			dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_auto_sshd_nfo_hd" --msgbox "$_auto_sshd_nfo_msg" 0 0
			wait
		fi
	else
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_auto_sshd_nfo_hd" --msgbox "$_auto_sshd_nfo_msg" 0 0
		wait
		dialog --defaultno --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_auto_sshd_nfo_hd" --yesno "$_auto_sshd_nfo_bd2" 0 0
		if [[ $? -eq 0 ]]; then
			_auto_sshd_nfo_once=0
			wait
			arch_chroot "systemctl disable sshd.service" 2>/tmp/.errlog
			wait
			check_for_error
			wait
			dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_auto_sshd_nfo_hd" --msgbox "$_auto_sshd_nfo_msg2" 0 0
			wait
		fi
	fi
}
function ssh_to_setup()
{
	if [[ $_ssh_run_once -eq 0 ]]; then
		clear
		info_search_pkg
		_list_ssh_pkg=$(check_s_lst_pkg "${_ssh_pkg[*]}")
		wait
		clear
		_ssh_run_once=1
	fi
	if [[ $_ssh_setup_once -eq 0 ]]; then
		dialog --defaultno --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_ssh_1" --yesno "$_yn_ssh_stp_bd" 0 0
		if [[ $? -eq 0 ]]; then
			if [[ ${_list_ssh_pkg[*]} != "" ]]; then
				pacstrap ${MOUNTPOINT} ${_list_ssh_pkg[*]} 2>/tmp/.errlog
				check_for_error
				wait
				sshd_autostart
				wait
				_my_ip=$(sudo ip -o address show | grep -vi "::" | grep -v "127" | awk '{print $4}' | cut -d '/' -f1)
				wait
				_myip_addr=( $_my_ip )
				unset _my_ip
				wait
				info_ssh_connect "${_myip_addr[0]}"
				wait
				unset _myip_addr
				wait
				_ssh_setup_once=1
			fi
			menu_conf_ssh
		fi
	else
		menu_conf_ssh
	fi
}

function firewall_install()
{
	if [[ $_firewall_once -eq 0 ]]; then
		_firewall_once=1
		clear
		info_search_pkg
		_list_firewall_pkg=$(check_s_lst_pkg "${_firewall[*]}")
		wait
		clear
		for j in ${_list_firewall_pkg[*]}; do
			_mlist_firewall="${_mlist_firewall} $j - on"
		done
	fi
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_yn_fw_hd" --yesno "${_progr_bd} ${_list_firewall_pkg[*]]}" 0 0
	if [[ $? -eq 0 ]]; then
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_yn_fw_hd" --checklist "$_yn_fw_bd" 0 0 7 ${_mlist_firewall} 2>${ANSWER}
		_chlmn_firewall=$(cat ${ANSWER})
		[[ ${_chlmn_firewall[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_chlmn_firewall[*]} 2>/tmp/.errlog
		wait
		[[ ${_chlmn_firewall[*]} != "" ]] && check_for_error
	fi
	server_menu
}
function file2ban_install()
{
	if [[ $_file2ban_once -eq 0 ]]; then
		_file2ban_once=1
		clear
		info_search_pkg
		_list_file2ban_pkg=$(check_s_lst_pkg "${_fail2ban[*]}")
		wait
		clear
		for j in ${_list_file2ban_pkg[*]}; do
			_mlist_file2ban="${_mlist_file2ban} $j - on"
		done
	fi
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_yn_f2b_hd" --yesno "${_progr_bd} ${_list_file2ban_pkg[*]]}" 0 0
	if [[ $? -eq 0 ]]; then
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_yn_f2b_hd" --checklist "$_yn_f2b_bd" 0 0 7 ${_mlist_file2ban} 2>${ANSWER}
		_chlmn_file2ban=$(cat ${ANSWER})
		[[ ${_chlmn_file2ban[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_chlmn_file2ban[*]} 2>/tmp/.errlog
		wait
		[[ ${_chlmn_file2ban[*]} != "" ]] && check_for_error
	fi
	server_menu
}
server_menu()
{
	# Depending on the answer, first check whether partition(s) are mounted and whether base has been installed
    if [[ $(cat ${ANSWER}) -eq 2 ]]; then
       check_mount
    fi

    if [[ $(cat ${ANSWER}) -ge 3 ]] && [[ $(cat ${ANSWER}) -le 7 ]]; then
       check_mount
       check_base
    fi
	
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_srv_ttl" \
	--menu "$_mn_srv_bd" 0 0 8 \
 	"1" "$_mn_srv_1" \
 	"2" "docker docker-compose" \
	"3" "$_mn_srv_2" \
	"4" "$_mn_srv_3" \
	"5" "$_mn_srv_4" \
	"6" "$_yn_fw_hd" \
	"7" "$_yn_f2b_hd" \
	"8" "$_antivirus_hd" \
	"9" "$_Back" 2>${ANSWER}

	case $(cat ${ANSWER}) in
		"1") ssh_to_setup
			;;
		"2") docker_menu_setup
			;;
		"3") email_srv_setup
			;;
		"4") namp_srv_setup
			;;
		"5") ftp_server_setup
			;;
		"6") firewall_install
			;;
		"7") file2ban_install
			;;
		"8") antivirus_setup
			;;
		*) install_apps_menu
			;;
	esac
	server_menu
}

