######################################################################
##                                                                  ##
##                   Install package functions                      ##
##                                                                  ##
######################################################################

pkg_setup()
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
