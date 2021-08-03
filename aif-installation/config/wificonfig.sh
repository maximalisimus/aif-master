######################################################################
##                                                                  ##
##                   WiFi configuration Menu                        ##
##                                                                  ##
######################################################################

_wifi_adapter=$(ip address show | grep -Ei "^[0-9]" | awk '{print $2}' | sed 's/://g'  | grep -Evi "lo" | grep -Ei "w")
_wifi_adptr=( $_wifi_adapter )
_intrfc=""
_interface_mn=""
_intr_once=0
_wf_type=""
_wep_keypass=0
_my_ssid=""
mypass=""
function slct_intrfc()
{
	if [[ $_intr_once -eq 0 ]]; then
		_intr_once=1
		for i in ${_wifi_adptr[*]}; do
			_interface_mn="${_interface_mn} $i -"
		done
	fi
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_wifi_menu_mn_1" --menu "$_selintfc_bd" 0 0 3 ${_interface_mn} 2>${ANSWER}
	_intrfc=$(cat ${ANSWER})
	wait
	ip link set ${_intrfc[*]} up
	wait
	wifimenu
}
function type_wifi_connect()
{
	dialog --default-item 1 --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_wifi_menu_mn_2" \
    --menu "$_typewf_con_bd" 0 0 3 \
 	"1" "WPA" \
 	"2" "WEP" \
	"3" "$_Back" 2>${ANSWER}	

    case $(cat ${ANSWER}) in
        "1") _wf_type="wpa"
             ;;
        "2") _wf_type="wep"
			wep_keyorpass
             ;;
          *) wifimenu
             ;;
     esac
	 wifimenu
}
function wep_keyorpass()
{
	dialog --default-item 2 --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_wep_keyorpass_hd" \
    --menu "$_wep_keyorpass_bd" 0 0 3 \
 	"1" "$_wep_keyorpass_mn_1" \
 	"2" "$_wep_keyorpass_mn_2" \
	"3" "$_Back" 2>${ANSWER}	

    case $(cat ${ANSWER}) in
        "1") _wep_keypass=0
             ;;
        "2") _wep_keypass=1
             ;;
          *) type_wifi_connect
             ;;
     esac
	wifimenu
}
function search_wifi_ssid()
{
	_srch_ssid=$(iw dev wlan0 scan | grep -Ei "ssid" | sed 's/^[ \t]*//' | sed 's/SSID: //g')
	_ssid_mn=""
	for j in ${_srch_ssid[*]}; do
		_ssid_mn="${_ssid_mn} $j -"
	done
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_wifi_menu_mn_3" --menu "$_srch_ssid_bd" 0 0 16 ${_ssid_mn} 2>${ANSWER}
	variables=$(cat ${ANSWER})
	_my_ssid=""
	_my_ssid="${variables[*]}"
	unset variables
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_inpass_hd" --inputbox "$_inpass_bd" 0 0 "" 2>${ANSWER}
	mypass=$(cat ${ANSWER})
	wifimenu
}
function connect_wifi_network()
{
	if [[ $_wf_type == "wpa" ]]; then
		wpa_passphrase "$_my_ssid" "${mypass[*]}" > /root/example.conf
		wait
		wpa_supplicant -B -i "${_intrfc[*]}" -c /root/example.conf
		wait
	else
		if [[ $_wep_keypass -eq 0 ]]; then
			iw dev "${_intrfc[*]}" connect "$_my_ssid" key 0:${mypass[*]}
			wait
		else
			iw dev "${_intrfc[*]}" connect "$_my_ssid" key d:2:${mypass[*]}
			wait
		fi
	fi
	wait
	clear
	sudo systemctl start dhcpcd
	wait
	sudo systemctl stop dhcpcd
	wait
	sleep 3
	wait
	dhcpcd ${_intrfc[*]}
	wait
	sleep 3
	wait
	ping -c 3 ya.ru
	wait
	sleep 3
	wait
	sudo systemctl stop dhcpcd
	wait
	wifimenu
}
function wifimenu()
{
	if [[ $SUB_MENU != "wifimenu" ]]; then
	   SUB_MENU="wifimenu"
	   HIGHLIGHT_SUB=1
	else
	   if [[ $HIGHLIGHT_SUB != 5 ]]; then
	      HIGHLIGHT_SUB=$(( HIGHLIGHT_SUB + 1 ))
	   fi
	fi
	
	dialog --default-item ${HIGHLIGHT_SUB} --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_wifi_menu_hd" \
    --menu "$_wifi_menu_bd" 0 0 5 \
 	"1" "$_wifi_menu_mn_1" \
 	"2" "$_wifi_menu_mn_2" \
 	"3" "$_wifi_menu_mn_3" \
 	"4" "DHCPCD" \
	"5" "$_Done" 2>${ANSWER}	

	HIGHLIGHT_SUB=$(cat ${ANSWER})
    case $(cat ${ANSWER}) in
        "1") slct_intrfc
        ;;
        "2") type_wifi_connect
        ;;
        "3") search_wifi_ssid
		;;
		"4") connect_wifi_network
		;;
          *) clear
             ;;
     esac
     # wifimenu
}

