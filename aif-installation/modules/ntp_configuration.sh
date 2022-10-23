######################################################################
##                                                                  ##
##                        NTP Functions                             ##
##                                                                  ##
###################################################################### 

function tmsnc_msg_stp()
{
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_tmsnc_err_ttl" --msgbox "$_tmsnc_msg_stp" 0 0
}

function tmsnc_msg_slsrv()
{
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_tmsnc_err_ttl" --msgbox "$_tmsnc_msg_zsbz" 0 0
}

function wr_ntp_conf()
{
	sed -i "/server 0/c server 0.${_base_zonesubzone}" $_ntp_conf_file
	sed -i "/server 1/c server 1.${_base_zonesubzone}" $_ntp_conf_file
	sed -i "/server 2/c server 2.${_base_zonesubzone}" $_ntp_conf_file
	sed -i "/server 3/c server 3.${_base_zonesubzone}" $_ntp_conf_file
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_tmsnc_lev1_3" --textbox $_ntp_conf_file 0 0
}

function ntp_rules_connect()
{
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_tmsnc_lev3_2" \
	--checklist "$_tmsnc_lev321_bd" 0 0 5 \
 	"kod" "$_restrinct_desc_1" "off" \
	"notrap" "$_restrinct_desc_2" "off" \
	"nomodify" "$_restrinct_desc_3" "on" \
	"nopeer" "$_restrinct_desc_4" "on" \
	"noquery" "$_restrinct_desc_5" "off" 2>${ANSWER}	
	_chl_tmsnc_rls=$(cat ${ANSWER})
	if [[ ${_chl_tmsnc_rls[*]} != "" ]]; then 
		_arr_tmsncrls=( $_chl_tmsnc_rls )
		unset _chl_tmsnc_rls
		_str_restrict="restrict default"
		for k in ${_arr_tmsncrls[*]}; do
				_str_restrict="${_str_restrict} $k"
		done
	fi
	wait
	sed -Ei "/^restrict default/c ${_str_restrict}" $_ntp_conf_file
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_tmsnc_lev1_3" --textbox $_ntp_conf_file 0 0
}

function ntp_menu_config()
{
   dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_tmsnc_lev1_3" \
	--menu "$_mn_tmsnc_bd" 0 0 5 \
 	"1" "$_mn_tmsnc_lev3_1" \
	"2" "$_mn_tmsnc_lev3_2" \
	"3" "$_Back" 2>${ANSWER}

	case $(cat ${ANSWER}) in
		"1") wr_ntp_conf
			 ;;
		"2") ntp_rules_connect
			 ;;   
		  *) time_sync_menu
			 ;;
	 esac	
	 ntp_menu_config
}

function sntp_menu_client()
{
	function wr_sntp_conf_fl()
	{
		if [[ $_sntp_wrconf_once -eq 0 ]]; then
			_sntp_str="NTP=0.${_base_zonesubzone} 1.${_base_zonesubzone} 2.${_base_zonesubzone} 3.${_base_zonesubzone}"
			_sntp_flb_str="FallbackNTP=0.arch.pool.ntp.org 1.pool.ntp.org 2.europe.pool.ntp.org 3.asia.pool.ntp.org"
			sed -Ei "/^\#NTP=/c $_sntp_str" $_sntp_conf_file
			sed -Ei "/^\#FallbackNTP=/c $_sntp_flb_str" $_sntp_conf_file
			_sntp_wrconf_once=1
		else
			_sntp_str="NTP=0.${_base_zonesubzone} 1.${_base_zonesubzone} 2.${_base_zonesubzone} 3.${_base_zonesubzone}"
			_sntp_flb_str="FallbackNTP=0.arch.pool.ntp.org 1.pool.ntp.org 2.europe.pool.ntp.org 3.asia.pool.ntp.org"
			sed -Ei "/^NTP=/c $_sntp_str" $_sntp_conf_file
			sed -Ei "/^FallbackNTP=/c $_sntp_flb_str" $_sntp_conf_file
			
		fi	
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_tmsnc_lev1_4" --textbox $_sntp_conf_file 0 0
	}
	
	function sntp_async_ends()
	{
		if [[ $_sntp_sttmzn_once -eq 0 ]]; then
			_sntp_sttmzn_once=1
			arch_chroot "timedatectl set-timezone ${ZONE}/${SUBZONE}" 2>/tmp/.errlog
			check_for_error
		fi
		dialog --defaultno --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_tmsnc_lev5_2" --yesno "$_tmsnc_yn_sntp_bd" 0 0
		if [[ $? -eq 0 ]]; then
			 if [[ $_sntp_async -eq 0 ]]; then
				_sntp_async=1
				arch_chroot "timedatectl set-ntp true" 2>/tmp/.errlog
				check_for_error
			else
				_sntp_async=0
				arch_chroot "timedatectl set-ntp false" 2>/tmp/.errlog
				check_for_error
			fi
			wait           
		fi
	}
	
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_tmsnc_lev1_4" \
	--menu "$_mn_tmsnc_bd" 0 0 3 \
 	"1" "$_mn_tmsnc_lev5_1" \
	"2" "$_mn_tmsnc_lev5_2" \
	"3" "$_Back" 2>${ANSWER}	

	case $(cat ${ANSWER}) in
		"1") wr_sntp_conf_fl
			 ;;
		"2") sntp_async_ends
			 ;;
		  *) time_sync_menu
			 ;;
	 esac
	 sntp_menu_client
}

function syncsel_simplezone()
{
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_tmsnc_lev2_1" \
	--menu "$_mn_tmsnc_bd" 0 0 7 \
 	"1" $"Worldwide" \
	"2" $"Asia" \
	"3" $"Europe" \
	"4" $"North America" \
	"5" $"Oceania" \
	"6" $"South America" \
	"7" "$_Back" 2>${ANSWER}	

	case $(cat ${ANSWER}) in
		"1") _base_zonesubzone="pool.ntp.org"
			_tmsnc_slsrv_once=1
			_tmsnc_msg_finzsbzn="${_tmsnc_zsbzn_msg_fine} Worldwide: ${_base_zonesubzone}\n"
			wait
			dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_tmsnc_lev2_2" --msgbox "$_tmsnc_msg_finzsbzn" 0 0
			unset _tmsnc_msg_finzsbzn
			 ;;
		"2") _base_zonesubzone="asia.pool.ntp.org"
			_tmsnc_slsrv_once=1
			_tmsnc_msg_finzsbzn="${_tmsnc_zsbzn_msg_fine} Asia: ${_base_zonesubzone}\n"
			wait
			dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_tmsnc_lev2_2" --msgbox "$_tmsnc_msg_finzsbzn" 0 0
			unset _tmsnc_msg_finzsbzn
			 ;;
		"3") _base_zonesubzone="europe.pool.ntp.org"
			_tmsnc_slsrv_once=1
			_tmsnc_msg_finzsbzn="${_tmsnc_zsbzn_msg_fine} Europe: ${_base_zonesubzone}\n"
			wait
			dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_tmsnc_lev2_2" --msgbox "$_tmsnc_msg_finzsbzn" 0 0
			unset _tmsnc_msg_finzsbzn
			 ;;
		 "4") _base_zonesubzone="north-america.pool.ntp.org"
			_tmsnc_slsrv_once=1
			_tmsnc_msg_finzsbzn="${_tmsnc_zsbzn_msg_fine} North America: ${_base_zonesubzone}\n"
			wait
			dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_tmsnc_lev2_2" --msgbox "$_tmsnc_msg_finzsbzn" 0 0
			unset _tmsnc_msg_finzsbzn
			 ;;
		 "5") _base_zonesubzone="oceania.pool.ntp.org"
			_tmsnc_slsrv_once=1
			_tmsnc_msg_finzsbzn="${_tmsnc_zsbzn_msg_fine} Oceania: ${_base_zonesubzone}\n"
			wait
			dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_tmsnc_lev2_2" --msgbox "$_tmsnc_msg_finzsbzn" 0 0
			unset _tmsnc_msg_finzsbzn
			 ;;
		 "6") _base_zonesubzone="south-america.pool.ntp.org"
			_tmsnc_slsrv_once=1
			_tmsnc_msg_finzsbzn="${_tmsnc_zsbzn_msg_fine} South America: ${_base_zonesubzone}\n"
			wait
			dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_tmsnc_lev2_2" --msgbox "$_tmsnc_msg_finzsbzn" 0 0
			unset _tmsnc_msg_finzsbzn
			 ;;
		  *) menu_server_sync
			 ;;
	 esac	
}

function syncsel_zonesubzone()
{
	wait
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_tmsnc_lev22_1" --menu "$_mn_tmsnc_bd" 0 0 16 ${_srv_mn_zone} 2>${ANSWER}
	wait
	variables=$(cat ${ANSWER})
	_srv_zone="${variables[*]}"
	unset variables
	URL="https://www.ntppool.org/zone/$_srv_zone"
	_ntp_files="./ntp.txt"
	wait
	rm -rf $_ntp_files
	wait
	curl -s "${URL}" | sed -e 's/<[^>]*>//g' | awk '!/^$/{print $0}' | sed 's/^[ \t]*//' | grep -Ei " [a-z]{2}.pool.ntp.org" | grep -Evi "\+|\!|-|\([a-z]" | sed -E 's/ \&#[0-9]{1,4};//g' | sed -E 's/ \([0-9]{1,4}\)//g' | tr ' ' '_' | sort -ud >> $_ntp_files
	wait
	_select_zone=$(cat $_ntp_files | rev | cut -d '_' -f2-9 | rev)
	wait
	unset _srv_mn_subzone
	_srv_mn_subzone=""
	wait
	for m in ${_select_zone[*]}; do
		_srv_mn_subzone="${_srv_mn_subzone} $m -"
	done
	wait
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_tmsnc_lev22_2" --menu "$_mn_tmsnc_bd" 0 0 16 ${_srv_mn_subzone} 2>${ANSWER}
	variables=$(cat ${ANSWER})
	_srv_subzone="${variables[*]}"
	wait
	_subzones=$(cat $_ntp_files | grep -Ei "${_srv_subzone}" | rev | cut -d '_' -f1 | rev)
	wait
	_base_zonesubzone="${_subzones[*]}"
	wait
	unset _subzones
	unset variables
	rm -rf $_ntp_files
	wait
	_tmsnc_slsrv_once=1
	wait
	_tmsnc_msg_finzsbzn="$_tmsnc_zsbzn_msg_fine ${_srv_zone}/${_srv_subzone}: ${_base_zonesubzone}\n"
	wait
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_tmsnc_lev2_2" --msgbox "$_tmsnc_msg_finzsbzn" 0 0
	wait
	unset _tmsnc_msg_finzsbzn
	wait
}

function menu_server_sync()
{
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_tmsnc_lev1_2" \
	--menu "$_mn_tmsnc_bd" 0 0 3 \
 	"1" "$_mn_tmsnc_lev2_1" \
	"2" "$_mn_tmsnc_lev2_2" \
	"3" "$_Back" 2>${ANSWER}	

	case $(cat ${ANSWER}) in
		"1") syncsel_simplezone
			 ;;
		"2") syncsel_zonesubzone
			 ;;
		  *) time_sync_menu
			 ;;
	 esac	
	menu_server_sync
}

function ntp_to_setup()
{
	function setup_ntp_pkg()
	{
		if [[ ${_list_ntp_pkg[*]} != "" ]]; then
			_tmsnc_stp_once=1
			clear
			pacstrap ${MOUNTPOINT} ${_list_ntp_pkg[*]} 2>/tmp/.errlog
			wait
			check_for_error
			wait
			arch_chroot "systemctl enable ntpd" 2>/tmp/.errlog
			wait
			check_for_error
			wait
		fi
	}
	if [[ $_tmsnc_init_once -eq 0 ]]; then
		_tmsnc_init_once=1
		clear
		info_search_pkg
		_list_ntp_pkg=$(check_s_lst_pkg "${_ntp_pkg[*]}")
		wait
		clear
		for k in ${_all_srv_zones[*]}; do
			_srv_mn_zone="${_srv_mn_zone} $k -"
		done
		wait
	fi
	if [[ $_tmsnc_stp_once -eq 0 ]]; then
		dialog --defaultno --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_tmsnc_lev1_1" --yesno "$_tmsnc_yn_stp_bd" 0 0
		if [[ $? -eq 0 ]]; then
			setup_ntp_pkg
		fi
	fi    
}

function time_sync_menu()
{
	
	# Depending on the answer, first check whether partition(s) are mounted and whether base has been installed
	if [[ $(cat ${ANSWER}) -eq 2 ]]; then
	   check_mount
	fi

	if [[ $(cat ${ANSWER}) -ge 3 ]] && [[ $(cat ${ANSWER}) -le 7 ]]; then
	   check_mount
	   check_base
	fi
	
	if [[ $SUB_MENU != "time_sync_menu" ]]; then
		SUB_MENU="time_sync_menu"
		HIGHLIGHT_SUB=1
	else
		if [[ $HIGHLIGHT_SUB != 5 ]]; then
			HIGHLIGHT_SUB=$(( HIGHLIGHT_SUB + 1 ))
		fi
	fi
	
	dialog --default-item ${HIGHLIGHT_SUB} --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_mn_tmsnc_ttl" \
	--menu "$_mn_tmsnc_bd" 0 0 5 \
	"1" "$_mn_tmsnc_lev1_1" \
	"2" "$_mn_tmsnc_lev1_2" \
	"3" "$_mn_tmsnc_lev1_3" \
	"4" "$_mn_tmsnc_lev1_4" \
	"5" "$_Back" 2>${ANSWER}	

	case $(cat ${ANSWER}) in
		"1") ntp_to_setup
			;;
		"2") if [[ $_tmsnc_stp_once -eq 0 ]]; then
				tmsnc_msg_stp
			else
				menu_server_sync
			fi
			;;
		"3") if [[ $_tmsnc_slsrv_once -eq 0 ]]; then
				tmsnc_msg_slsrv
			else
				ntp_menu_config
			fi
			;;
		"4") if [[ $_tmsnc_slsrv_once -eq 0 ]]; then
				tmsnc_msg_slsrv
			else
			   sntp_menu_client
			fi
			;;
		*) config_base_menu
			;;
	esac
	time_sync_menu
}
