######################################################################
##                                                                  ##
##                   Configuration functions                        ##
##                                                                  ##
######################################################################

pc_conf_prcss()
{
    echo "#" > "$2"
    while read line; do
        if [[ $line == "#[multilib]" ]]; then
            _next=1
            echo "[multilib]" >> "$2"
            echo "Include = /etc/pacman.d/mirrorlist" >> "$2"
        else
            if [[ $_next == "1" ]]; then
                _next=0
                continue
            else
                echo "$line" >> "$2"
            fi
        fi
    done < "$1"
    cp -f "$2" "$1"
}

multilib_question()
{
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_yesno_multilib_title" --yesno "$_yesno_multilib_body" 0 0

    if [[ $? -eq 0 ]]; then
       pc_conf_prcss "$_pcm_conff" "$_pcm_tempf"
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

function out_greeter_conf()
{
	echo "# /etc/lightdm/lightdm-gtk-greeter.conf" > "${MOUNTPOINT}/etc/lightdm/lightdm-gtk-greeter.conf"
	echo "[greeter]" >> "${MOUNTPOINT}/etc/lightdm/lightdm-gtk-greeter.conf"
	echo "theme-name = Adwaita" >> "${MOUNTPOINT}/etc/lightdm/lightdm-gtk-greeter.conf"
	echo "icon-theme-name = Adwaita" >> "${MOUNTPOINT}/etc/lightdm/lightdm-gtk-greeter.conf"
	if [[ "$1" != "" ]]; then
		echo "background = ${1}" >> "${MOUNTPOINT}/etc/lightdm/lightdm-gtk-greeter.conf"
	else
		echo "background = /usr/share/wallpapers/Carbon-Mesh/carbon_mesh_arch.png" >> "${MOUNTPOINT}/etc/lightdm/lightdm-gtk-greeter.conf"
	fi
	echo "default-user-image = #avatar-default-symbolic" >> "${MOUNTPOINT}/etc/lightdm/lightdm-gtk-greeter.conf"
	echo "panel-position = bottom" >> "${MOUNTPOINT}/etc/lightdm/lightdm-gtk-greeter.conf"
	echo "indicators = ~spacer;~separator;~session;~separator;~layout;~separator;~language;~separator;~a11y;~separator;~power;~separator;~spacer;~host;~spacer;~clock;~spacer" >> "${MOUNTPOINT}/etc/lightdm/lightdm-gtk-greeter.conf"
	echo "" >> "${MOUNTPOINT}/etc/lightdm/lightdm-gtk-greeter.conf"
}

function find_images()
{
	_img_files=$(find "${1}" -type f -iname "*.${2}" | rev | cut -d '/' -f1 | rev | xargs)
	declare -a _img_array
	_img_array=("${_img_files}")
	unset _img_files
	_img_mn=""
	for j in ${_img_array[*]}; do
		_img_mn="${_img_mn} $j -"
	done
	unset _img_array
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_img_sel_bd" --menu "$_img_sel_hd" 0 0 11 ${_img_mn} 2>${ANSWER}
	wait
	variables=$(cat ${ANSWER})
	wait
	unset _img_mn
	clear
	out_greeter_conf "${variables}"
}

function select_images()
{
	if [[ $_wallpaper_once -eq 0 ]]; then
		_wallpaper_once=1
		tar -C "${MOUNTPOINT}/usr/share/" -xzf "$filesdir/config/wallpapers.tar.gz"
		wait
		sudo chown -R $USER:users "${MOUNTPOINT}/usr/share/wallpapers/Carbon-Mesh"
		sudo chmod -R 755 "${MOUNTPOINT}/usr/share/wallpapers/Carbon-Mesh"
		wait
		sudo chown -R $USER:users "${MOUNTPOINT}/usr/share/wallpapers/Full-HD"
		sudo chmod -R 755 "${MOUNTPOINT}/usr/share/wallpapers/Full-HD"
	fi
	wait
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_img_sel_bd" --yesno "$_img_ctg_hd" 0 0
	if [[ $? -eq 0 ]]; then	
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_img_ctg_bd" --menu "$_img_ctg_mn" 0 0 11 \
		"1" "Carbon-Mesh" \
		"2" "Full-HD" 2>${ANSWER}
		case $(cat ${ANSWER}) in
			"1") find_images "${MOUNTPOINT}/usr/share/wallpapers/Carbon-Mesh" "png"
				
				;;
			"2") find_images "${MOUNTPOINT}/usr/share/wallpapers/Full-HD" "jpg"
				
				;;
		esac
	else
		out_greeter_conf
	fi
}

function ldm_form_edit()
{
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_ldm_greeter_qs_bd" --yesno "$_ldm_greeter_qs_hd" 0 0
	if [[ $? -eq 0 ]]; then
		select_images
	fi
}
