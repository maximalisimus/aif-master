#!/bin/bash
ustanovka_pocketov()
{
   _dir="$1"
   _pkg="$2"
   _pkg_full=$(find $_dir -maxdepth 1 -type f -iname "$_pkg*")
   _pkg_name=$(echo "${_pkg_full[*]}" | rev | cut -d '/' -f1 | rev)
   cp -f ${_pkg_full[*]} /var/lib/pacman/local/
   cp -f ${_pkg_full[*]} ${MOUNTPOINT}/var/lib/pacman/local/
   pacman --root ${MOUNTPOINT} --dbpath ${MOUNTPOINT}/var/lib/pacman -U /var/lib/pacman/local/${_pkg_name[*]} --noconfirm
   # DEBUG
   # echo "$_pkg_full"
   # echo "$_pkg_full" >> "$filesdir"/setup-pkgs.txt
   # echo "$_pkg_name"
   # DEBUG
   unset _dir
   unset _pkg
   unset _pkg_full
   unset _pkg_name
}

function create_script()
{
	echo "" | sed 's/^/\#/' | sed 's/$/\!/' | sed 's/$/\/bin\/bash/' >> "$1"
}

function ps_in_pkg()
{
	local _tmp_pkg
	_tmp_pkg=("$@")
	_tmp_pkg_mn=""
	declare -a _babd_pkg
	for k in ${_tmp_pkg[*]}; do
		if [[ $k == "base" ]]; then
			_babd_pkg=("${_babd_pkg[*]}" "$k")
		elif [[ $k == "base-devel" ]]; then
			_babd_pkg=("${_babd_pkg[*]}" "$k")
		else
			_tmp_pkg_mn="${_tmp_pkg_mn} $k - on"
		fi
		wait
	done
	wait
	dialog --defaultno --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_yn_psinpkg_ttl" --yesno "$_yn_psinpkg_bd" 0 0
	if [[ $? -eq 0 ]]; then
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_yn_psinpkg_ttl" --checklist "$_psinpkg_mn_bd" 0 0 16 ${_tmp_pkg_mn} 2>${ANSWER}
		_ch_psin_pkg=$(cat ${ANSWER})
		clear
		[[ ${_babd_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_babd_pkg[*]} 2>/tmp/.errlog
		[[ ${_babd_pkg[*]} != "" ]] && check_for_error
		[[ ${_ch_psin_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_ch_psin_pkg[*]} 2>/tmp/.errlog
		[[ ${_ch_psin_pkg[*]} != "" ]] && check_for_error
	else
		[[ ${_tmp_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_tmp_pkg[*]} 2>/tmp/.errlog
		[[ ${_tmp_pkg[*]} != "" ]] && check_for_error
	fi
	unset _babd_pkg
	unset _ch_psin_pkg
	unset _tmp_pkg
	unset _tmp_pkg_mn
}

function mirror_config()
{
	dialog --defaultno --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_Mirror_Conf_ttl" --yesno "$_yn_mirror_conf_bd" 0 0
	if [[ $? -eq 0 ]]; then
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "_Mirror_Conf_ttl" \
		--checklist "_Mirror_Conf_bd" 0 0 5 \
		"1" "http" "on" \
		"2" "https" "on" \
		"3" "IPv4" "on" \
		"4" "IPv6" "on" \
		"5" "Use Mirror status" "on" 2>${ANSWER}
		clear
		var=$(cat ${ANSWER} | sed 's/[ \t]*/\n/g' | awk '!/^$/{print $0}' | sed s/[^0-9]//g)
		# [ -f ./tmp.log ] && rm -rf ./tmp.log
		# cat ${ANSWER} | sed 's/[ \t]*/\n/g' | awk '!/^$/{print $0}' | sed s/[^0-9]//g >> ./tmp.log
		# var=""
		# while read line; do
		#	var="${var} $line"
		# done < ./tmp.log
		# [ -f ./tmp.log ] && rm -rf ./tmp.log
		arr=( $var )
		unset var
		for i in ${arr[*]}; do
			case $i in
				"1") _mirror_conf_str="${_mirror_conf_str}&protocol=http"
					;;
				"2") _mirror_conf_str="${_mirror_conf_str}&protocol=https"
					;;
				"3") _mirror_conf_str="${_mirror_conf_str}&ip_version=4"
					;;
				"4") _mirror_conf_str="${_mirror_conf_str}&ip_version=6"
					;;
				"5") _mirror_conf_str="${_mirror_conf_str}&use_mirror_status=on"
					;;    
			esac
		done
		unset arr
	else
		_mirror_conf_str="&protocol=http&protocol=https&ip_version=4&ip_version=6&use_mirror_status=on"
	fi
		
}
# mirror_config
# echo "${_mirror_conf_str}"
