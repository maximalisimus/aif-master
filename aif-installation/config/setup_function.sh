######################################################################
##                                                                  ##
##                   Install package functions                      ##
##                                                                  ##
######################################################################

info_search_pkg()
{
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_nfo_search_pkg_title" --infobox "$_nfo_search_pkg_body" 0 0
}

search_translit_pkg()
{
    stp=$(pacman -Ss | grep -Ei "core|extra|community|multilib" | sed 's/extra\///' | sed 's/core\///' | sed 's/community\///' | sed 's/multilib\///' | grep -E "^$1" | awk '{print $1}' | grep -Ei "$2$")
    echo "${stp[*]}"
}

function check_s_lst_pkg {
    local temp_pkg
    temp_pkg=("$@")
    declare -a new_pkg
    temp=""
    for i in ${temp_pkg[*]}; do
        pacman -Ss $i 1>/dev/null 2>/dev/null
        err=$?
        if [[ $err -eq 0 ]]; then 
            new_pkg=("${new_pkg[*]}" "$i")
        fi
    done
    echo ${new_pkg[*]}
}

manual_pkg_setup()
{
   _full_pkg="${1}"
   _full_name="${2}"
   cp -f ${_full_pkg} ${MOUNTPOINT}/var/lib/pacman/local/
   pacman --root ${MOUNTPOINT} --dbpath ${MOUNTPOINT}/var/lib/pacman -U ${MOUNTPOINT}/var/lib/pacman/local/${_full_name} --noconfirm
   # DEBUG
   # echo "$_full_pkg"
   # echo "$_full_name"
   # DEBUG
   rm -rf "$_full_pkg"
   unset _full_pkg
   unset _full_name
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
