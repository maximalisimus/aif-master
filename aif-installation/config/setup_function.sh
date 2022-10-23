#!/bin/bash

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
		_current_pkgs="${_ch_psin_pkg[*]}"
	else
		[[ ${_tmp_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_tmp_pkg[*]} 2>/tmp/.errlog
		[[ ${_tmp_pkg[*]} != "" ]] && check_for_error
		_current_pkgs="${_tmp_pkg[*]}"
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

multilib_question()
{
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_yesno_multilib_title" --yesno "$_yesno_multilib_body" 0 0

    if [[ $? -eq 0 ]]; then
       sed -i '/^#\s*\[multilib\]$/{N;s/^#\s*//gm}' ${MOUNTPOINT}/etc/pacman.conf
       _multilib=1
    else
        _multilib=0
    fi
}

mirrorlist_question()
{
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_MirrorlistTitle" --yesno "$_yesno_mirrorlist_body" 0 0

    if [[ $? -eq 0 ]]; then
        sudo cp -f /etc/pacman.d/mirrorlist ${MOUNTPOINT}/etc/pacman.d/mirrorlist
    fi
}

info_search_pkg()
{
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_nfo_search_pkg_title" --infobox "$_nfo_search_pkg_body" 0 0
}

search_translit_pkg()
{
    stp=$(pacman -Ss | grep -Ei "core|extra|community|multilib|archlinuxcn" | sed 's/extra\///' | sed 's/core\///' | sed 's/community\///' | sed 's/multilib\///' | sed 's/archlinuxcn\///' | grep -E "^$1" | awk '{print $1}' | grep -E "$2$" | grep -Ei "${2}" | xargs)
    echo "${stp[*]}"
}

search_pkg()
{
    stp=$(pacman -Ss | grep -Ei "core|extra|community|multilib|archlinuxcn" | sed 's/extra\///' | sed 's/core\///' | sed 's/community\///' | sed 's/multilib\///' | sed 's/archlinuxcn\///' | grep -E "^$1" | awk '{print $1}' | sed '2,$d')
    echo "${stp[*]}"
}

search_dm_pkg()
{
    stp=$(pacman -Ss | grep -Ei "core|extra|community|multilib|archlinuxcn" | sed 's/extra\///' | sed 's/core\///' | sed 's/community\///' | sed 's/multilib\///' | sed 's/archlinuxcn\///' | grep -E "^$1" | awk '{print $1}')
    echo "${stp[*]}"
}

search_q_pkg()
{
    stp=$(pacman --root ${MOUNTPOINT} --dbpath ${MOUNTPOINT}/var/lib/pacman -Qs | grep -Ei "local" | sed 's/local\///' | grep -E "^$1" | awk '{print $1}' | grep -E "$2$" | grep -Ei "${2}")
    echo "${stp[*]}"
}

function check_s_lst_pkg(){
	local temp_pkg
	temp_pkg=("$@")
	declare -a new_pkg
	temp=""
	for i in ${temp_pkg[*]}; do
		temp=$(search_pkg "${i}")
		new_pkg=("${new_pkg[*]}" "${temp[*]}")
	done
	echo ${new_pkg[*]}
}

function check_dm_lst_pkg(){
	local temp_pkg
	temp_pkg=("$@")
	declare -a new_pkg
	temp=""
	for i in ${temp_pkg[*]}; do
		temp=$(search_dm_pkg "${i}")
		new_pkg=("${new_pkg[*]}" "${temp[*]}")
	done
	echo ${new_pkg[*]}
}

function check_q_lst_pkg(){
    local temp_pkg
    temp_pkg=("$@")
    declare -a new_pkg
    temp=""
    declare -a out_pkg
    for i in ${temp_pkg[*]}; do
       temp=$(search_q_pkg "${i}")
       new_pkg=("${new_pkg[@]}" "${temp[*]}")
    done
    out_pkg=$(python "$filesdir"/config/${check_q_py} "${temp_pkg[*]}" "${new_pkg[*]}")
    echo ${out_pkg[*]}
}

osprober_configuration(){
	prober_detect=$(echo "${_current_pkgs[*]}" | grep -oi "os-prober" | wc -l)
	if [[ ${prober_detect[*]} == 1 ]]; then
		mkdir -p ${MOUNTPOINT}/etc/default/
		sed -i '/GRUB_DISABLE_OS_PROBER/s/#GRUB_DISABLE_OS_PROBER/GRUB_DISABLE_OS_PROBER/' ${MOUNTPOINT}/etc/default/grub
		sed -i '/GRUB_DISABLE_OS_PROBER/s/true/false/' ${MOUNTPOINT}/etc/default/grub
	fi
}

refind_configuration(){
	refind_detect=$(echo "${_current_pkgs[*]}" | grep -oi "refind" | wc -l)
	if [[ ${refind_detect[*]} == 1 ]]; then
		mkdir -p ${MOUNTPOINT}/etc/pacman.d/hooks/
		echo "[Trigger]" > ${MOUNTPOINT}/etc/pacman.d/hooks/refind.hook
		echo "Operation=Upgrade" >> ${MOUNTPOINT}/etc/pacman.d/hooks/refind.hook
		echo "Type=Package" >> ${MOUNTPOINT}/etc/pacman.d/hooks/refind.hook
		echo "Target=refind" >> ${MOUNTPOINT}/etc/pacman.d/hooks/refind.hook
		echo "" >> ${MOUNTPOINT}/etc/pacman.d/hooks/refind.hook
		echo "[Action]" >> ${MOUNTPOINT}/etc/pacman.d/hooks/refind.hook
		echo "Description = Updating rEFInd on ESP" >> ${MOUNTPOINT}/etc/pacman.d/hooks/refind.hook
		echo "When=PostTransaction" >> ${MOUNTPOINT}/etc/pacman.d/hooks/refind.hook
		echo "Exec=/usr/bin/refind-install" >> ${MOUNTPOINT}/etc/pacman.d/hooks/refind.hook
	fi
}

systemd_configuration(){
	systemd_detect=$(echo "${_current_pkgs[*]}" | grep -oi "efibootmgr" | wc -l)
	if [[ ${systemd_detect[*]} == 1 ]]; then
		mkdir -p ${MOUNTPOINT}/etc/pacman.d/hooks/
		echo "[Trigger]" > ${MOUNTPOINT}/etc/pacman.d/hooks/systemd-boot.hook
		echo "Type = Package" >> ${MOUNTPOINT}/etc/pacman.d/hooks/systemd-boot.hook
		echo "Operation = Upgrade" >> ${MOUNTPOINT}/etc/pacman.d/hooks/systemd-boot.hook
		echo "Target = systemd" >> ${MOUNTPOINT}/etc/pacman.d/hooks/systemd-boot.hook
		echo "" >> ${MOUNTPOINT}/etc/pacman.d/hooks/systemd-boot.hook
		echo "[Action]" >> ${MOUNTPOINT}/etc/pacman.d/hooks/systemd-boot.hook
		echo "Description = Updating systemd-boot..." >> ${MOUNTPOINT}/etc/pacman.d/hooks/systemd-boot.hook
		echo "When = PostTransaction" >> ${MOUNTPOINT}/etc/pacman.d/hooks/systemd-boot.hook
		echo "Exec = /usr/bin/bootctl update" >> ${MOUNTPOINT}/etc/pacman.d/hooks/systemd-boot.hook
	fi
}

xdg_configuration(){
	xdg_detect=$(echo "${_current_pkgs[*]}" | grep -oi "xdg-user-dirs" | wc -l)
	if [[ ${xdg_detect[*]} == 1 ]]; then
		_user_list=$(ls ${MOUNTPOINT}/home/ | sed "s/lost+found//")
		declare -a _list_user
		_list_user=( $_user_list )
		unset _user_list
		for i in ${_list_user[*]}; do
			mkdir -p ${MOUNTPOINT}/home/"${i}"/.config/
			touch ${MOUNTPOINT}/home/"${i}"/.config/user-dirs.dirs
			echo "XDG_DESKTOP_DIR=\"\$HOME/Desktop\""  > ${MOUNTPOINT}/home/"${i}"/.config/user-dirs.dirs
			echo "XDG_DOWNLOAD_DIR=\"\$HOME/Downloads\"" >> ${MOUNTPOINT}/home/"${i}"/.config/user-dirs.dirs
			echo "XDG_TEMPLATES_DIR=\"\$HOME/Templates\"" >> ${MOUNTPOINT}/home/"${i}"/.config/user-dirs.dirs
			echo "XDG_PUBLICSHARE_DIR=\"\$HOME/Public\"" >> ${MOUNTPOINT}/home/"${i}"/.config/user-dirs.dirs
			echo "XDG_DOCUMENTS_DIR=\"\$HOME/Documents\"" >> ${MOUNTPOINT}/home/"${i}"/.config/user-dirs.dirs
			echo "XDG_MUSIC_DIR=\"\$HOME/Music\"" >> ${MOUNTPOINT}/home/"${i}"/.config/user-dirs.dirs
			echo "XDG_PICTURES_DIR=\"\$HOME/Images\"" >> ${MOUNTPOINT}/home/"${i}"/.config/user-dirs.dirs
			echo "XDG_VIDEOS_DIR=\"\$HOME/Videos\"" >> ${MOUNTPOINT}/home/"${i}"/.config/user-dirs.dirs
			arch_chroot "xdg-user-dirs-update"
		done
	fi
}

icontheme_configuration(){
	if [[ $_icontheme_once == "0" ]]; then
		_icontheme_once=1
		wget "${_icontheme_url[*]}" -O "${_icontheme_pkg[*]}"
		wait
		_user_list=$(ls ${MOUNTPOINT}/home/ | sed "s/lost+found//")
		for i in ${_user_list[*]}; do
			mkdir -p ${MOUNTPOINT}/home/"${i}"/.icons/
			wait
			tar -C ${MOUNTPOINT}/home/"${i}"/.icons/ -xvzf "${_icontheme_pkg[*]}"
			wait
		done
		wait
		rm -rf "${_icontheme_pkg[*]}"
	fi
}

wallpapers_configuration(){
	wget "${_wallpapers_url[*]}" -O "${_wallpapers_pkg[*]}"
	wait
	mkdir -p ${MOUNTPOINT}/usr/share/wallpapers/
	wait
	tar -C ${MOUNTPOINT}/usr/share/wallpapers/ --strip-components=1 -xvzf "${_wallpapers_pkg[*]}" wallpapers/Full-HD/
	wait
	tar -C ${MOUNTPOINT}/usr/share/wallpapers/ --strip-components=1 -xvzf "${_wallpapers_pkg[*]}" wallpapers/Carbon-Mesh/
	wait
	rm -rf "${_wallpapers_pkg[*]}"
}

greeter_configuration(){
	if [[ $_greeter_once == "0" ]]; then
		_greeter_once=1
		wallpapers_configuration
		wait
		if [[ -e ${MOUNTPOINT}/usr/share/wallpapers/Carbon-Mesh/carbon_mesh_arch.png  ]]; then
			echo "[greeter]" > ${MOUNTPOINT}/etc/lightdm/lightdm-gtk-greeter.conf
			echo "theme-name = Adwaita" >> ${MOUNTPOINT}/etc/lightdm/lightdm-gtk-greeter.conf
			echo "icon-theme-name = Adwaita" >> ${MOUNTPOINT}/etc/lightdm/lightdm-gtk-greeter.conf
			echo "background = /usr/share/wallpapers/Carbon-Mesh/carbon_mesh_arch.png" >> ${MOUNTPOINT}/etc/lightdm/lightdm-gtk-greeter.conf
			echo "default-user-image = #avatar-default-symbolic" >> ${MOUNTPOINT}/etc/lightdm/lightdm-gtk-greeter.conf
			echo "panel-position = bottom" >> ${MOUNTPOINT}/etc/lightdm/lightdm-gtk-greeter.conf
			echo -e -n "indicators = ~spacer;~separator;~session;~separator;~layout;" >> ${MOUNTPOINT}/etc/lightdm/lightdm-gtk-greeter.conf
			echo -e -n "~separator;~language;~separator;~a11y;~separator;~power;" >> ${MOUNTPOINT}/etc/lightdm/lightdm-gtk-greeter.conf
			echo -e -n "~separator;~spacer;~host;~spacer;~clock;~spacer" >> ${MOUNTPOINT}/etc/lightdm/lightdm-gtk-greeter.conf
		else
			echo "[greeter]" > ${MOUNTPOINT}/etc/lightdm/lightdm-gtk-greeter.conf
			echo "theme-name = Adwaita" >> ${MOUNTPOINT}/etc/lightdm/lightdm-gtk-greeter.conf
			echo "icon-theme-name = Adwaita" >> ${MOUNTPOINT}/etc/lightdm/lightdm-gtk-greeter.conf
			echo "background = " >> ${MOUNTPOINT}/etc/lightdm/lightdm-gtk-greeter.conf
			echo "default-user-image = #avatar-default-symbolic" >> ${MOUNTPOINT}/etc/lightdm/lightdm-gtk-greeter.conf
			echo "panel-position = bottom" >> ${MOUNTPOINT}/etc/lightdm/lightdm-gtk-greeter.conf
			echo -e -n "indicators = ~spacer;~separator;~session;~separator;~layout;" >> ${MOUNTPOINT}/etc/lightdm/lightdm-gtk-greeter.conf
			echo -e -n "~separator;~language;~separator;~a11y;~separator;~power;" >> ${MOUNTPOINT}/etc/lightdm/lightdm-gtk-greeter.conf
			echo -e -n "~separator;~spacer;~host;~spacer;~clock;~spacer" >> ${MOUNTPOINT}/etc/lightdm/lightdm-gtk-greeter.conf
		fi
	fi
}

fonts_configuration(){
	if [[ $_truetype_once == "0" ]]; then
		_truetype_once=1
		wget "${_truetype_url[*]}" -O "${_truetype_pkg[*]}"
		wait
		tar -C ${MOUNTPOINT}/usr/share/fonts/ -xvzf "${_truetype_pkg[*]}"
		wait
		rm -rf "${_truetype_pkg[*]}"
		wait
		arch-chroot $MOUNTPOINT /bin/bash -c "fc-cache –fv" 2>/tmp/.errlog
		wait
		check_for_error
	fi
}
