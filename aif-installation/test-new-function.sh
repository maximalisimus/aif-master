#!/bin/bash
_image_viewer=(viewnior gthumb gpicview)
_xnviemp_name="XnViewMP"
_image_viewer=("${_xnviemp_name}" "${_image_viewer[*]}")
#
_mn_image_viewer=""
for j in ${_image_viewer[*]}; do
	_mn_image_viewer="${_mn_image_viewer} $j - off"
done
function excl_pkg_array()
{
	local pkg_tmp
	pkg_tmp=("$@")
	declare -a pkg_all
	counter=0
	for j in ${pkg_tmp[*]}; do
		if [[ $counter -eq 0 ]]; then
			let counter+=1
			wait
			continue
		else
			pkg_all=("${pkg_all[*]}" "$j")
		fi
	done
	unset counter
	unset pkg_tmp
	echo "${pkg_all[*]}"
}
function check_pkg_array()
{
	local tmp_pkg
	tmp_pkg=("$@")
	pkg_str=$(excl_pkg_array "${tmp_pkg[*]}")
	declare -a all_pkg
	all_pkg=("$pkg_str")
	unset pkg_str
	check_pkg="${tmp_pkg[0]}"
	unset tmp_pkg
	rez=0
	for j in ${all_pkg[*]}; do
		if [[ "$j" == *"$check_pkg"* ]]; then
			rez=1
			break
		fi
	done
	unset check_pkg
	unset all_pkg
	echo "$rez"
}
ANSWER="./.tmp"
dialog --backtitle "VERSION - SYSTEM (ARCHI)" --title "Image editors" --checklist "\nPlease, to select package.\n" 0 0 5 ${_mn_image_viewer} 2>${ANSWER}
# --menu
wait
_chmn_img_view=$(cat ${ANSWER})
wait
_ch_pkg=$(check_pkg_array "${_xnviemp_name}" "${_chmn_img_view}")
wait
_chmn_img_view=$(excl_pkg_array "${_chmn_img_view}")
wait
clear
echo ""
if [[ "${_ch_pkg}" -eq 1 ]]; then
	echo "${_xnviemp_name} is True"
	echo "${_chmn_img_view}"
else
	echo "${_xnviemp_name} is False"
	echo "${_chmn_img_view}"
fi
echo ""
rm -rf "${ANSWER}"
#
exit 0
