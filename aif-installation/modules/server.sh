#!/bin/bash

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

function onoff_prmrtlg()
{
	if [[ $_prmtrtlg_once -eq "0" ]]; then
		echo "PermitRootLogin no" >> ${MOUNTPOINT}/etc/ssh/sshd_config
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
				arch_chroot "systemctl enable sshd.service" 2>/tmp/.errlog
				check_for_error
				_my_ip=$(sudo ip -o address show | grep -vi "::" | grep -v "127" | awk '{print $4}' | cut -d '/' -f1)
				_myip_addr=( $_my_ip )
				unset _my_ip
				info_ssh_connect "${_myip_addr[0]}"
				unset _myip_addr
				_ssh_setup_once=1
			fi
		fi
	fi
}

menu_conf_ssh()
{
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_ssh_2" \
	--menu "$_mn_srv_bd" 0 0 4 \
 	"1" "$_mn_cnf_ssh_1" \
	"2" "$_mn_cnf_ssh_2" \
	"3" "$_Back" 2>${ANSWER}
	case $(cat ${ANSWER}) in
		"1") port_ssh_conf
			;;
		"2") onoff_prmrtlg
			;;
		*) server_menu
			;;
	esac
	menu_conf_ssh
}

ssh_menu()
{
	ssh_to_setup
	wait
	if [[ $_ssh_setup_once -eq 1 ]]; then
		menu_conf_ssh
	else
		server_menu
	fi
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
	--menu "$_mn_srv_bd" 0 0 6 \
 	"1" "$_mn_srv_1" \
	"2" "$_mn_srv_2" \
	"3" "$_mn_srv_3" \
	"4" "$_mn_srv_4" \
	"5" "$_Back" 2>${ANSWER}

	case $(cat ${ANSWER}) in
		"1") ssh_menu
			;;
		"2") email_srv_setup
			;;
		"3") namp_srv_setup
			;;
		"4") ftp_server_setup
			;;
		*) main_menu_online
			;;
	esac
	server_menu
}


