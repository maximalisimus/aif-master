######################################################################
##                                                                  ##
##                    List of installations                         ##
##                                                                  ##
######################################################################

## File for form in lists packages to master
##
## 23 July 2019 years
##
##
#
## Install base menu
#
_archi=$(uname -m)
_pcm_conff="/etc/pacman.conf"
_pcm_tempf="$filesdir/new.conf"
_download_dir="$filesdir/download-packages/"
_rank_mirror=(pacman-contrib)
_base_pkg=(bash btrfs-progs ntp sudo f2fs-tools dialog htop nano vi ntfs-3g linux-headers squashfs-tools upower mlocate testdisk hwinfo mkinitcpio)
_base_devel_pkg=(bash bzip2 coreutils cryptsetup device-mapper dhcpcd diffutils e2fsprogs file filesystem findutils gawk gcc-libs gettext glibc grep gzip inetutils iproute2 iputils jfsutils less licenses logrotate lvm2 man-db man-pages mdadm nano netctl pacman pciutils perl procps-ng psmisc reiserfsprogs s-nail sed shadow sysfsutils systemd-sysvcompat tar texinfo usbutils util-linux vi which xfsprogs btrfs-progs ntp sudo f2fs-tools dialog htop mc ntfs-3g bash-completion gparted net-tools linux-headers squashfs-tools upower mlocate recordmydesktop testdisk hwinfo mkinitcpio)
_lts_pkg=(linux-lts linux-lts-headers linux-lts-docs)
_krnl_pkg=(linux linux-headers linux-docs)
#
## User and Groups
#
_us_gr_users=(adm ftp games http log rfkill sys systemd-journal users uucp wheel)
_us_gr_system=(dbus kmem locate lp mail nobody proc smmsp tty utmp)
_us_gr_presystemd=(audio disk floppy input kvm optical scanner storage video)
#
## Package Network tools
#
_nm_pkg_1="netctl"
_nm_pkg_2="connman"
_nm_pkg_3="dhcpcd"
_nm_pkg_4="networkmanager"
_nm_pkg_5="wicd-gtk"
_nm_pkg_list=("$_nm_pkg_1" "$_nm_pkg_2" "$_nm_pkg_3" "$_nm_pkg_4" "$_nm_pkg_5")
_ln_menu=""
_network_pkg=(samba libwbclient smb4k smbclient smbnetfs gvfs-smb libgtop)
_connman_pkg=("$_nm_pkg_2")
_nm_applet_pkg="network-manager-applet"
_networkmanager_pkg=("$_nm_pkg_4" "$_nm_applet_pkg")
_rp_pppoe_pkg="rp-pppoe"
_p_pppoe_pkg="p-pppoe"
_net_connect_var=("$_rp_pppoe_pkg" "$_p_pppoe_pkg" networkmanager-openconnect networkmanager-openvpn networkmanager-pptp networkmanager-vpnc)
_wicd_pkg=(wicd "$_nm_pkg_5")
#
## Server list of packages
#
_ssh_pkg=(openssh)
_docker_pkg=(docker docker-compose)
_mail_srv_pkg=(postfix)
_namp_srv_pkg=(nginx apache mysql++ mariadb mariadb-clients php phpmyadmin php-fpm php-apache)
_ftp_srv_pkg=(atftp bftpd curlftpfs filezilla gftp lftp tnftp vsftpd)
_firewall=(ufw gufw)
_fail2ban=(fail2ban)
_clamav_gui="clamtk"
_clamav_pkg=(clamav "$_clamav_gui" glibc)
#
## Network time protocol server packages
#
_ntp_pkg=(ntp networkmanager-dispatcher-ntpd)
#
## Packages for wireless tools
#
_wifi_pkg=(iw wireless_tools wpa_actiond wpa_supplicant wicd)
_wifi_menu=""
_broadcom=(b43-fwcutter)
_list_broadcom=""
_intel_2100=(ipw2100-fw)
_list_intel_2100=""
_intel_2200=(ipw2200-fw)
_list_intel_2200=""
_menu_wifi=("Show_Devices" "Broadcom_802.11b/g/n" "Intel_PRO/Wireless_2100" "Intel_PRO/Wireless_2200" "All" "Back")
_bluetooth=(blueman bluez bluez-libs bluez-plugins bluez-utils bluez-tools)
#
## Package for grub and uefi menu
#
_grub_pkg=(grub os-prober)
_grub_theme_pkg=(breeze-grub grub-theme-vimix)
_grub_btrfs_pkg=(grub-btrfs)
_syslinux_pkg=(syslinux)
_grub_uefi_pkg=(grub os-prober efibootmgr dosfstools)
_reefind_pkg=(refind efibootmgr dosfstools)
_systemd_boot_pkg=(efibootmgr dosfstools)
#
## Alsa xorg packages
#
_x_pkg=(alsa-utils alsa-plugins volumeicon pavucontrol pulseaudio pulseaudio-alsa pulseaudio-bluetooth pulseaudio-equalizer pulseaudio-jack pulseeffects pulsemixer pasystray pamixer pulseview rhythmbox audacious audacity xf86-input-synaptics xf86-input-keyboard xf86-input-mouse)
#
## Aur packages download URL
#
_aur_pkgs_x64_durl="https://github.com/maximalisimus/repo/blob/master/aur-packages/x86_64/"
_aur_pkgs_x86_durl="https://github.com/maximalisimus/repo/blob/master/aur-packages/i686/"
#
## Graphic Card packages
#
_intel_pkg=(xf86-video-intel libva-intel-driver intel-ucode)
_ati_pkg=(xf86-video-ati)
_nvd_pkg=(nvidia nvidia-settings nvidia-utils lib32-nvidia-utils pangox-compat)
_nvd_lts_pkg=(nvidia-lts nvidia-settings nvidia-utils lib32-nvidia-utils pangox-compat)
_nvd_dkms_pkg=(nvidia-dkms nvidia-settings nvidia-utils lib32-nvidia-utils pangox-compat)
_nvd_dep=(cuda bumblebee mesa mesa-demos libva-utils libvdpau lib32-libvdpau lib32-virtualgl)
_nouveau=(xf86-video-nouveau)
_openchrome=(xf86-video-openchrome)
_vbox_pkg=(virtualbox-guest-utils virtualbox-guest-modules)
_vbox_lts_pkg=(virtualbox-guest-utils)
_vmware_pkg=(xf86-video-vmware xf86-input-vmmouse)
_generic_pkg=(xf86-video-fbdev)
#
## DM packages
#
_dm_pkg_1="lxdm"
_dm_pkg_2="lightdm"
_dm_pkg_3="sddm"
_dm_pkg_4="slim"
_dm_pkg_5="gdm"
_user_dm_menu=("$_dm_pkg_1" "$_dm_pkg_2" "$_dm_pkg_3" "$_dm_pkg_5" "$_dm_pkg_4")
_ldm_menu=""
_lxdm_pkg=("$_dm_pkg_1")
_dm_lightdm_1="lightdm-gtk-greeter"
_dm_lightdm_2="lightdm-gtk-greeter-settings"
_lightdm_pkg=("$_dm_pkg_2" "$_dm_lightdm_1" "$_dm_lightdm_2")
_dm_sddm_pkg="sddm-kcm"
_sddm_pkg=("$_dm_pkg_3" "$_dm_sddm_pkg")
_gdm_pkg=("$_dm_pkg_5")
_slim_pkg=("$_dm_pkg_4")
#
## Desktop environment packages
#
_desktop_menu=("Deepin" "Deepin_Deepin-Extra" "Cinnamon" "Enlightenment" "Gnome-Shell_minimal" "Gnome" "Gnome_Gnome-Extras" "KDE-5-Base_minimal" "KDE-5" "LXDE" "LXQT" "MATE" "MATE_MATE-Extras" "Xfce" "Xfce_Xfce-Extras" "Awesome-WM" "Fluxbox-WM" "i3-WM" "Ice-WM" "Openbox-WM" "Pek-WM") # WindowMaker-WM
_de_pkg_1="deepin"
_de_pkg_2="deepin-extra"
_de_pkg_3="cinnamon"
_de_pkg_4="enlightenment"
_enlmnt_extra="terminology"
_polkit_gnome="polkit-gnome"
_de_pkg_5="gnome-shell"
_de_pkg_6="gnome"
_de_pkg_7="gnome-extra"
_de_pkg_8="plasma-desktop"
_de_pkg_9="plasma"
_de_pkg_10="lxde"
_de_pkg_11="lxqt"
_lxqt_icons="oxygen-icons"
_de_pkg_12="mate"
_de_pkg_13="mate-extra"
_de_pkg_14="xfce4"
_de_pkg_15="xfce4-goodies"
_xfce4_audio_pkg="xfce4-pulseaudio-plugin"
_de_pkg_16="awesome"
_awesome_extra="vicious"
_de_pkg_17="fluxbox"
_fluxbox_news="fbnews"
_de_pkg_18="i3-wm"
_i3wm_extra_1="i3lock"
_i3wm_extra_2="i3status"
_i3wm_extra_3="dmenu"
_de_pkg_19="icewm"
_icewm_themes="icewm-themes"
_de_pkg_20="openbox"
_openbox_themes="openbox-themes"
_de_pkg_21="pekwm"
_pekwm_themes="pekwm-themes"
_de_pkg_22="windowmaker"
_d_menu=("$_de_pkg_1" "$_de_pkg_2" "$_de_pkg_3" "$_de_pkg_4" "$_de_pkg_5" "$_de_pkg_6" "$_de_pkg_7" "$_de_pkg_8" "$_de_pkg_9" "$_de_pkg_10" "$_de_pkg_11" "$_de_pkg_12" "$_de_pkg_13" "$_de_pkg_14" "$_de_pkg_15" "$_de_pkg_16" "$_de_pkg_17" "$_de_pkg_18" "$_de_pkg_19" "$_de_pkg_20" "$_de_pkg_21")
# _d_menu=(deepin deepin-extra cinnamon enlightenment gnome-shell gnome gnome-extra plasma-desktop plasma lxde lxqt mate mate-extra xfce4 xfce4-goodies awesome fluxbox i3-wm icewm openbox pekwm) # windowmaker
_deepine_pkg=("$_de_pkg_1" "$_dm_pkg_2" "$_dm_lightdm_1" "$_dm_lightdm_2")
_deepine_extra_pkg=("$_de_pkg_1" "$_de_pkg_2" "$_dm_lightdm_1" "$_dm_lightdm_2")
_cinnamon_pkg=("$_de_pkg_3")
_enlightenment_pkg=("$_de_pkg_4" "$_enlmnt_extra" "$_polkit_gnome")
_gnome_shell_pkg=("$_de_pkg_5" "$_dm_pkg_5")
_gnome_pkg=("$_de_pkg_6" "$_dm_pkg_5" "$_rp_pppoe_pkg")
_gnome_extras_pkg=("$_de_pkg_6" "$_dm_pkg_5" "$_de_pkg_7" "$_rp_pppoe_pkg")
_kde5base_pkg=("$_de_pkg_8" "$_p_pppoe_pkg")
_kde_pkg=("$_de_pkg_9" "$_rp_pppoe_pkg")
_lxde_pkg=("$_de_pkg_10")
_lxqt_pkg=("$_de_pkg_11" "$_lxqt_icons")
_mate_pkg=("$_de_pkg_12")
_mateextra_pkg=("$_de_pkg_12" "$_de_pkg_13")
_xfce4_pkg=("$_de_pkg_14" "$_polkit_gnome" "$_xfce4_audio_pkg")
_xfce4_extra_pkg=("$_de_pkg_14" "$_de_pkg_15" "$_polkit_gnome" "$_xfce4_audio_pkg")
_awesome_pkg=("$_de_pkg_16" "$_awesome_extra" "$_polkit_gnome")
_fluxbox_pkg=("$_de_pkg_17" "$_fluxbox_news" "$_polkit_gnome")
_i3wm_pkg=("$_de_pkg_18" "$_i3wm_extra_1" "$_i3wm_extra_2" "$_i3wm_extra_3" "$_polkit_gnome")
_icewm_pkg=("$_de_pkg_19" "$_icewm_themes" "$_polkit_gnome")
_openbox_pkg=("$_de_pkg_20" "$_openbox_themes" "$_polkit_gnome")
_pekwm_pkg=(pekwm "$_pekwm_themes" "$_polkit_gnome")
_windowmaker_pkg=("$_de_pkg_22" "$_polkit_gnome")
#
## List of packages SHELL
#
_screen_startup=(screenfetch)
_shells_sh=(bash fish zsh dash ksh tcsh)
_bash_sh=(bash-completion)
_zsh_sh=(zsh-completions)
#
## Common for Desktop packages
#
_general_pkg=(gnome-keyring dconf dconf-editor python2-xdg xdg-user-dirs xdg-utils rp-pppoe polkit gvfs gvfs-afc print-manager system-config-printer acpid avahi cronie)
# arch_chroot "systemctl enable acpid avahi-daemon cronie" 2>/tmp/.errlog
#
## User Package
#
_archivers_xpkg=(ark xarchiver file-roller)
_archivers_clipkg=(unzip zip unrar p7zip)
_ttf_pkg=(ttf-liberation ttf-dejavu opendesktop-fonts ttf-bitstream-vera ttf-arphic-ukai ttf-arphic-uming ttf-hanazono terminus-font)
_ttf_edit_pkg=(fontforge)
_ttf_tnr_name="ttf-times-new-roman"
_ttf_tnr_rel="3"
_ttf_tnr_vers="2.0"
_ttf_tnr_fvers="${_ttf_tnr_vers}-${_ttf_tnr_rel}"
_ttf_tnr_arch="any"
_ttf_tnr_ext="pkg.tar.zst"
_ttf_tnr_fname="${_ttf_tnr_name}-${_ttf_tnr_fvers}-${_ttf_tnr_arch}.${_ttf_tnr_ext}"
unset _ttf_tnr_rel
unset _ttf_tnr_vers
unset _ttf_tnr_fvers
unset _ttf_tnr_arch
unset _ttf_tnr_ext
# _ttf_tnr_furl="${_aur_pkgs_x64_durl}${_ttf_tnr_fname}"
_theme_pkg=(gnome-icon-theme breeze breeze-grub breeze-icons faenza-icon-theme adwaita-icon-theme)
_menu_edit_pkg=(alacarte)
#
_linuxlex8_name="LinuxLex-8"
_linuxlex8_furl="https://github.com/maximalisimus/For-Linux/raw/master/For_Linux_4/${_linuxlex8_name}.tar.gz"
#
## Man pages russian
#
_manpg_ru_name="man-pages-ru"
_manpg_ru_rel="1"
_manpg_ru_vers="5.03_2390_2390_20191017"
_manpg_ru_fvers="${_manpg_ru_vers}-${_manpg_ru_rel}"
_manpg_ru_arch="any"
_manpg_ru_ext="pkg.tar.zst"
_manpg_ru_fname="${_manpg_ru_name}-${_manpg_ru_fvers}-${_manpg_ru_arch}.${_manpg_ru_ext}"
unset _manpg_ru_rel
unset _manpg_ru_vers
unset _manpg_ru_fvers
unset _manpg_ru_arch
unset _manpg_ru_ext
# _manpg_ru_furl="${_aur_pkgs_x64_durl}${_manpg_ru_fname}"
#
_terminal_pkg=(xterm gnome-terminal lxterminal)
_cddvdiso_pkg=(brasero acetoneiso2 fuseiso cdrtools)
# mkisofs -l -o iso_name /path/to/folder
# genisoimage -o iso_name /path/to/folder
# genisoimage -v -J -r -V MY_DISK_LABEL -o /home/user/file.iso /home/user/input_dir
# https://webhamster.ru/mytetrashare/index/mtb0/1788
#
_browser_pkg=(firefox chromium opera tor torbrowser-launcher lynx links)
_messangers_pkg=(discord)
#
## SearX
#
_searx_name="searx"
_searx_rel="1"
_searx_vers="0.18.0"
_searx_fvers="${_searx_vers}-${_searx_rel}"
_searx_arch="any"
_searx_ext="pkg.tar.zst"
_searx_fname="${_searx_name}-${_searx_fvers}-${_searx_arch}.${_searx_ext}"
unset _searx_rel
unset _searx_vers
unset _searx_fvers
unset _searx_arch
unset _searx_ext
# _searx_furl="${_aur_pkgs_x64_durl}${_searx_fname}"
#
_torrent_pkg=(transmission-gtk ktorrent qbittorrent)
_download_xpkg=(gwget kget uget)
_download_pkg=(curl git wget youtube-dl)
_file_meneger_pkg=(ksysguard doublecmd-gtk2 krusader)
_graphic_pkg=(blender inkscape gimp pinta krita krita-plugin-gmic gcolor3)
_image_viewer=(viewnior gthumb gpicview)
_media_pkg=(vlc smplayer kmplayer)
_editor_pkg=(vim geany leafpad mousepad gedit micro)
_code_editor_pkg=(atom emacs geany)
_office_pkg=(libreoffice-fresh okular evince djvulibre)
#
_system_pkg=(grub-customizer galculator dmidecode)
# The type memory and full parameters information
# sudo dmidecode --type 17
#
_clipboard_pkg=(parcellite xclip clipmenu gpaste)
_cad_pkg=(kicad kicad-library kicad-library-3d)
#
_virtualization=(virtualbox qemu)
_vbox_pkg=(virtualbox virtualbox-guest-iso virtualbox-guest-utils virtualbox-host-dkms virtualbox-host-modules-arch)
_qemu_pkg(qemu qemu-arch-extra edk2-ovmf qemu-block-iscsi qemu-headless qemu-block-gluster qemu-block-rbd)
#
_games_pkg=(steam teeworlds supertuxkart xonotic warsow aisleriot kpat kmines gnome-chess gnuchess pychess gnome-sudoku hitori bomber)
#
## Programing
#
_arduino_pkg=(arduino arduino-avr-core arduino-cli arduino-builder avr-gcc avrdude avr-binutils avr-libc arduino-ctags arduino-docs)
#
if [[ "${_archi[*]}" == "x86_64" ]]; then
	_mirrorlist_url="https://www.archlinux.org/mirrorlist/?country="
	countries_list=("AU_Australia AT_Austria BY_Belarus BE_Belgium BR_Brazil BG_Bulgaria CA_Canada CL_Chile CN_China CO_Colombia CZ_Czech_Republic DK_Denmark EE_Estonia FI_Finland FR_France DE_Germany GB_United_Kingdom GR_Greece HU_Hungary IN_India IE_Ireland IL_Israel IT_Italy JP_Japan KZ_Kazakhstan KR_Korea LV_Latvia LU_Luxembourg MK_Macedonia NL_Netherlands NC_New_Caledonia NZ_New_Zealand NO_Norway PL_Poland PT_Portugal RO_Romania RU_Russia RS_Serbia SG_Singapore SK_Slovakia ZA_South_Africa ES_Spain LK_Sri_Lanka SE_Sweden CH_Switzerland TW_Taiwan TR_Turkey UA_Ukraine US_United_States UZ_Uzbekistan VN_Vietnam")
    #
	## AppImageUpdate
	_app_upd_durl="https://github.com/AppImage/AppImageUpdate/releases/download/continuous/"
	_app_upd_arch="${x86_64}"
	_app_upd_ext="AppImage"
	_app_upd_prog_name="AppImageUpdate"
	_app_upd_fprog="${_app_upd_prog_name}-${_app_upd_arch}.${_app_upd_ext}"
	_app_upd_tool_name="appimageupdatetool"
	_app_upd_ftool="${_app_upd_name_tool}-${_app_upd_arch}.${_app_upd_ext}"	
	unset _app_upd_arch
	unset _app_upd_ext
	#
	## Graphic Card AUR
	#
	## Nvidia 390xx to Github
	#
	_nvd39xx_rel="1"
	_nvd39xx_vers="390.144"
	_nvd39xx_fvers="${_nvd39xx_vers}-${_nvd39xx_rel}"
	_nvd39xx_arch="x86_64"
	_nvd39xx_ext="pkg.tar.zst"
	_nvd39xx_name="nvidia-390xx"
	_nvd39xx_utils="utils"
	_nvd39xx_settings="settings"
	_nvd39xx_lib_name="lib32"
	_nvd39xx_opencl_name="opencl"
	_nvd39xx_opencl_lib="${_nvd39xx_lib_name}-${_nvd39xx_opencl_name}"
	_nvd39xx_libx_name="libxnvctrl-390xx"
	_nvd39xx_dkms_name="dkms"
	#
	_nvd39xx_durl="https://github.com/maximalisimus/repo/raw/master/aur-nvidia-390xx/x86_64/"
	_nvd39xx_libu_pkg="${_nvd39xx_lib_name}-${_nvd39xx_name}-${_nvd39xx_utils}-${_nvd39xx_fvers}-${_nvd39xx_arch}.${_nvd39xx_ext}"
	_nvd39xx_libo_pkg="${_nvd39xx_opencl_lib}-${_nvd39xx_name}-${_nvd39xx_fvers}-${_nvd39xx_arch}.${_nvd39xx_ext}"
	_nvd39xx_libx_pkg="${_nvd39xx_libx_name}-${_nvd39xx_fvers}-${_nvd39xx_arch}.${_nvd39xx_ext}"
	_nvd39xx_pkg="${_nvd39xx_name}-${_nvd39xx_fvers}-${_nvd39xx_arch}.${_nvd39xx_ext}"
	_nvd39xx_dkms_pkg="${_nvd39xx_name}-${_nvd39xx_dkms_name}-${_nvd39xx_fvers}-${_nvd39xx_arch}.${_nvd39xx_ext}"
	_nvd39xx_stngs_pkg="${_nvd39xx_name}-${_nvd39xx_settings}-${_nvd39xx_fvers}-${_nvd39xx_arch}.${_nvd39xx_ext}"
	_nvd39xx_ut_pkg="${_nvd39xx_name}-${_nvd39xx_utils}-${_nvd39xx_fvers}-${_nvd39xx_arch}.${_nvd39xx_ext}"
	_nvd39xx_oc_pkg="${_nvd39xx_opencl_name}-${_nvd39xx_name}-${_nvd39xx_fvers}-${_nvd39xx_arch}.${_nvd39xx_ext}"
	unset _nvd39xx_rel
	unset _nvd39xx_vers
	unset _nvd39xx_fvers
	unset _nvd39xx_arch
	unset _nvd39xx_ext
	unset _nvd39xx_name
	unset _nvd39xx_utils
	unset _nvd39xx_settings
	unset _nvd39xx_lib_name
	unset _nvd39xx_opencl_name
	unset _nvd39xx_opencl_lib
	unset _nvd39xx_libx_name
	unset _nvd39xx_dkms_name
	#
	# wget -P "$filesdir/download-packages" "${_nvd39xx_download}${_nvd39xx_libu_pkg}"
	# wait
	#
	## XnViewMP
	#
	_xnviemp_name="XnViewMP"
	_xnviemp_sys="linux"
	_xnviemp_arch="x64"
	_xnviemp_ext="tgz"
	_xnviemp_fname="${_xnviemp_name}-${_xnviemp_sys}-${_xnviemp_arch}.${_xnviemp_ext}"
	#
	unset _xnviemp_sys
	unset _xnviemp_arch
	unset _xnviemp_ext
	#
	_xnviemp_furl="https://download.xnview.com/${_xnviemp_fname}"
	#
	# wget "${_xnviemp_furl}"
	# unset _xnviemp_furl
	# mkdir -p "${MOUNTPOINT}/opt"
	# tar -C "${MOUNTPOINT}/opt/" -xzf "${_xnviemp_fname}"
	# _xnviemp_str_name=$(tar -tf "${_xnviemp_fname}" | cut -d '/' -f1 | uniq -d | xargs)
	# _xnviemp_name="${_xnviemp_str_name[*]}"
	# unset _xnviemp_str_name
	# find "${MOUNTPOINT}/opt/${_xnviemp_name}/" -type f -iname "*.desktop" -exec chmod ugo+x {} \;
	# mkdir -p "${MOUNTPOINT}/usr/share/applications/"
	# find "${MOUNTPOINT}/opt/${_xnviemp_name}/" -type f -iname "*.desktop" -exec cp {} "${MOUNTPOINT}/usr/share/applications/" \;
	# unset _xnviemp_name
	# rm -rf "${_xnviemp_fname}"
	# unset _xnviemp_fname
	#
	#
	## Library to Freecad and KiCad on incompatible. Please download on FreeCad to AppImage.
	#
	#
	_fcad_name="FreeCAD"
	_fcad_release="0.19.2"
	_fcad_vers="0.19-24291"
	_fcad_compiler="Linux-Conda"
	_fcad_glibc="glibc2.12"
	_fcad_arch="x86_64"
	_fcad_ext="AppImage"
	_fcad_fname="${_fcad_name}_${_fcad_vers}-${_fcad_compiler}_${_fcad_glibc}-${_fcad_arch}.${_fcad_ext}"
	_fcad_sname="${_fcad_name}_${_fcad_vers}-${_fcad_compiler}_${_fcad_glibc}-${_fcad_arch}"
	_fcad_durl="https://github.com/FreeCAD/FreeCAD/releases/download/"
	# _fcad_furl="${_fcad_durl}${_fcad_release}/${_fcad_fname}"	
	unset _fcad_release
	unset _fcad_vers
	unset _fcad_compiler
	unset _fcad_glibc
	unset _fcad_arch
	unset _fcad_ext
	unset _fcad_durl
	#
	_fcad_icons_gz="freecad-icons.tar.gz"
	# mkdir -p "${MOUNTPOINT}"/usr/share/
	# tar -C "${MOUNTPOINT}/usr/share/" -xzf "${_fcad_icons_gz}"
	_fcad_mime="freecad.xml"
	_stl_mime="stl.xml"
	_vrml_mime="vrml.xml"
	_fcad_fmime="$filesdir/config/$_fcad_mime"
	_stl_fmime="$filesdir/config/$_stl_mime"
	_vrml_fmime="$filesdir/config/$_vrml_mime"
	#
	_fcad_mime_inst="${MOUNTPOINT}/usr/share/mime/packages/"
	_stl_vrml_mime_inst="${MOUNTPOINT}/usr/share/mime/model/"
	#
	unset _fcad_mime
	unset _stl_mime
	unset _vrml_mime
	#
	_fcad_name_desktop="FreeCad.desktop"
	_fcad_desktop="$filesdir/config/$_fcad_name_desktop"
	#
	#
	## Touchpad-config
	#
	_touchpad_conf_name="touchpad_config"
	_touchpad_conf_rel="1"
	_touchpad_conf_vers="1.0"
	_touchpad_conf_fvers="${_touchpad_conf_vers}-${_touchpad_conf_rel}"
	_touchpad_conf_arch="x86_64"
	_touchpad_conf_ext="pkg.tar.zst"
	_touchpad_conf_fname="${_touchpad_conf_name}-${_touchpad_conf_fvers}-${_touchpad_conf_arch}.${_touchpad_conf_ext}"
	# _touchpad_conf_furl="${_aur_pkgs_x64_durl}${_touchpad_conf_fname}"
	unset _touchpad_conf_rel
	unset _touchpad_conf_vers
	unset _touchpad_conf_fvers
	unset _touchpad_conf_arch
	unset _touchpad_conf_ext
	#
	## Timeshift
	#
	_timeshift_name="timeshift"
	_timeshift_rel="1"
	_timeshift_vers="20.11.1+4+gd437358"
	_timeshift_fvers="${_timeshift_vers}-${_timeshift_rel}"
	_timeshift_arch="x86_64"
	_timeshift_ext="pkg.tar.zst"
	_timeshift_fname="${_timeshift_name}-${_timeshift_fvers}-${_timeshift_arch}.${_timeshift_ext}"
	# _timeshift_furl="${_aur_pkgs_x64_durl}${_timeshift_fname}"
	# _timeshift_url="https://github.com/maximalisimus/repo/raw/master/aur-packages/x86_64/timeshift-20.11.1%2B4%2Bgd437358-1-x86_64.pkg.tar.zst"
	unset _timeshift_rel
	unset _timeshift_vers
	unset _timeshift_fvers
	unset _timeshift_arch
	unset _timeshift_ext
    #
    ## Security
    #
    _bitwarden_name="bitwarden"
    _bitwarden_rel="2"
    _bitwarden_vers="1.27.1"
    _bitwarden_fvers="${_bitwarden_vers}-${_bitwarden_rel}"
    _bitwarden_arch="x86_64"
    _bitwarden_ext="pkg.tar.zst"
    _bitwarden_fname="${_bitwarden_name}-${_bitwarden_fvers}-${_bitwarden_arch}.${_bitwarden_ext}"
    # _bitwarden_furl="${_aur_pkgs_x64_durl}${_bitwarden_fname}"
    unset _bitwarden_rel
    unset _bitwarden_vers
    unset _bitwarden_fvers
    unset _bitwarden_arch
    unset _bitwarden_ext
    #
    _wine_pkg=(wine wine-mono wine_gecko winetricks)
    _security_pkg=(keepassxc veracrypt) # truecrypt
    #
    _emulator_pkg=(dosbox desmume gens mednafen mupen64plus pcsx2 ppsspp)
	#
	## pamac-aur, pamac-classic, package-query, pikaur, yay
	#
	_pkg_mngr_durl="https://github.com/maximalisimus/repo/raw/master/package-manager/x86_64/"
	#
	_pkg_mngr_pq_name="package-query"
	_pkg_mngr_pq_rel="1"
	_pkg_mngr_pq_vers="1.12"
	_pkg_mngr_pq_fvers="${_pkg_mngr_pq_vers}-${_pkg_mngr_pq_rel}"
	_pkg_mngr_pq_arch="x86_64"
	_pkg_mngr_pq_ext="pkg.tar.zst"
	_pkg_mngr_pq_fname="${_pkg_mngr_pq_name}-${_pkg_mngr_pq_fvers}-${_pkg_mngr_pq_arch}.${_pkg_mngr_pq_ext}"
	# _pkg_mngr_pq_furl="${_pkg_mngr_durl}${_pkg_mngr_pq_fname}"
	unset _pkg_mngr_pq_rel
	unset _pkg_mngr_pq_vers
	unset _pkg_mngr_pq_fvers
	unset _pkg_mngr_pq_arch
	unset _pkg_mngr_pq_ext	
	#
	_pkg_mngr_pk_name="pikaur"
	_pkg_mngr_pk_rel="1"
	_pkg_mngr_pk_vers="1.7"
	_pkg_mngr_pk_fvers="${_pkg_mngr_pk_vers}-${_pkg_mngr_pk_rel}"
	_pkg_mngr_pk_arch="any"
	_pkg_mngr_pk_ext="pkg.tar.zst"
	_pkg_mngr_pk_fname="${_pkg_mngr_pk_name}-${_pkg_mngr_pk_fvers}-${_pkg_mngr_pk_arch}.${_pkg_mngr_pk_ext}"
	# _pkg_mngr_pk_furl="${_pkg_mngr_durl}${_pkg_mngr_pk_fname}"
	unset _pkg_mngr_pk_rel
	unset _pkg_mngr_pk_vers
	unset _pkg_mngr_pk_fvers
	unset _pkg_mngr_pk_arch
	unset _pkg_mngr_pk_ext
	#
	_pkg_mngr_yy_name="yay"
	_pkg_mngr_yy_rel="1"
	_pkg_mngr_yy_vers="10.3.1"
	_pkg_mngr_yy_fvers="${_pkg_mngr_yy_vers}-${_pkg_mngr_yy_rel}"
	_pkg_mngr_yy_arch="x86_64"
	_pkg_mngr_yy_ext="pkg.tar.zst"
	_pkg_mngr_yy_fname="${_pkg_mngr_yy_name}-${_pkg_mngr_yy_fvers}-${_pkg_mngr_yy_arch}.${_pkg_mngr_yy_ext}"
	# _pkg_mngr_yy_furl="${_pkg_mngr_durl}${_pkg_mngr_yy_fname}"
	unset _pkg_mngr_yy_rel
	unset _pkg_mngr_yy_vers
	unset _pkg_mngr_yy_fvers
	unset _pkg_mngr_yy_arch
	unset _pkg_mngr_yy_ext
	#
	_pkg_mngr_lpa_name="libpamac-aur"
	_pkg_mngr_lpa_rel="1"
	_pkg_mngr_lpa_vers="11.0.1"
	_pkg_mngr_lpa_fvers="${_pkg_mngr_lpa_vers}-${_pkg_mngr_lpa_rel}"
	_pkg_mngr_lpa_arch="x86_64"
	_pkg_mngr_lpa_ext="pkg.tar.zst"
	_pkg_mngr_lpa_fname="${_pkg_mngr_lpa_name}-${_pkg_mngr_lpa_fvers}-${_pkg_mngr_lpa_arch}.${_pkg_mngr_lpa_ext}"
	# _pkg_mngr_lpa_furl="${_pkg_mngr_durl}${_pkg_mngr_lpa_fname}"
	unset _pkg_mngr_lpa_rel
	unset _pkg_mngr_lpa_vers
	unset _pkg_mngr_lpa_fvers
	unset _pkg_mngr_lpa_arch
	unset _pkg_mngr_lpa_ext
	#
	_pkg_mngr_pa_name="pamac-aur"
	_pkg_mngr_pa_rel="1"
	_pkg_mngr_pa_vers="10.1.3"
	_pkg_mngr_pa_fvers="${_pkg_mngr_pa_vers}-${_pkg_mngr_pa_rel}"
	_pkg_mngr_pa_arch="x86_64"
	_pkg_mngr_pa_ext="pkg.tar.zst"
	_pkg_mngr_pa_fname="${_pkg_mngr_pa_name}-${_pkg_mngr_pa_fvers}-${_pkg_mngr_pa_arch}.${_pkg_mngr_pa_ext}"
	# _pkg_mngr_pa_furl="${_pkg_mngr_durl}${_pkg_mngr_pa_fname}"
	unset _pkg_mngr_pa_rel
	unset _pkg_mngr_pa_vers
	unset _pkg_mngr_pa_fvers
	unset _pkg_mngr_pa_arch
	unset _pkg_mngr_pa_ext
	#
	_pkg_mngr_pc_name="pamac-classic"
	_pkg_mngr_pc_rel="2"
	_pkg_mngr_pc_vers="7.3.0"
	_pkg_mngr_pc_fvers="${_pkg_mngr_pc_vers}-${_pkg_mngr_pc_rel}"
	_pkg_mngr_pc_arch="x86_64"
	_pkg_mngr_pc_ext="pkg.tar.zst"
	_pkg_mngr_pc_fname="${_pkg_mngr_pc_name}-${_pkg_mngr_pc_fvers}-${_pkg_mngr_pc_arch}.${_pkg_mngr_pc_ext}"
	# _pkg_mngr_pc_furl="${_pkg_mngr_durl}${_pkg_mngr_pc_fname}"
	unset _pkg_mngr_pc_rel
	unset _pkg_mngr_pc_vers
	unset _pkg_mngr_pc_fvers
	unset _pkg_mngr_pc_arch
	unset _pkg_mngr_pc_ext
	#
	#
	## Programing
	#
	_make_cmake_pkg=(make cmake)
	_gcc_cpp_pkg=(gcc gcc-libs lib32-gcc-libs binutils)
	_mingw_w64_pkg=(mingw-w64-binutils mingw-w64-crt mingw-w64-gcc mingw-w64-headers mingw-w64-winpthreads)
	_golang_pkg=(go go-tools)
	_python_pkg=(python python-pip python-setuptools python-virtualenv python-virtualenvwrapper python-wheel)
	_python2_pkg=(python2 python2-pip python2-setuptools python2-virtualenv python2-wheel)
	_qt_creator_pkg=(qtcreator qt5-base qt5-doc qt6-base qt6-doc)
	_java_pkg=(jre-openjdk jdk-openjdk)
	_java_ide=(intellij-idea-community-edition eclipse-ecj)
	_perl_pkg=(perl)
	_ruby_pkg=(ruby ruby-irb)
	_nodejs_pkg=(nodejs)
	_nodejs_lts_pkg=(nodejs-lts-fermium nodejs-lts-erbium) # nodejs-lts-fermium - For 14.X version. nodejs-lts-erbium - For 12.X version
else
	_mirrorlist_url="https://archlinux32.org/mirrorlist/?country="
	countries_list=("BY_Belarus FR_France DE_Germany IN_India JP_Japan RU_Russia SG_Singapore CH_Switzerland US_United_States")
    #
	## AppImageUpdate
	_app_upd_durl="https://github.com/AppImage/AppImageUpdate/releases/download/continuous/"
	_app_upd_arch="${i386}"
	_app_upd_ext="AppImage"
	_app_upd_prog_name="AppImageUpdate"
	_app_upd_fprog="${_app_upd_prog_name}-${_app_upd_arch}.${_app_upd_ext}"
	_app_upd_tool_name="appimageupdatetool"
	_app_upd_ftool="${_app_upd_name_tool}-${_app_upd_arch}.${_app_upd_ext}"	
	unset _app_upd_arch
	unset _app_upd_ext
	#
	## XnViewMP
	#
	_xnviemp_name="XnViewMP"
	_xnviemp_sys="linux"
	_xnviemp_ext="tgz"
	_xnviemp_fname="${_xnviemp_name}-${_xnviemp_sys}.${_xnviemp_ext}"
	#
	unset _xnviemp_sys
	unset _xnviemp_arch
	unset _xnviemp_ext
	#
	_xnviemp_furl="https://download.xnview.com/${_xnviemp_fname}"
	#
    #
    _wine_pkg=(keepassxc veracrypt)
    _security_pkg=(wine-mono winetricks) # truecrypt
    #
    _emulator_pkg=(dosbox desmume mednafen mupen64plus ppsspp)
    #
	## Programing
	#
	_make_cmake_pkg=(make cmake)
	_gcc_cpp_pkg=(gcc gcc-libs binutils)
	_mingw_w64_pkg=(mingw-w64-binutils mingw-w64-headers)
	_golang=(go go-tools)
	_python_pkg=(python python-pip python-setuptools python-virtualenv python-virtualenvwrapper python-wheel)
	_python2_pkg=(python2 python2-pip python2-setuptools python2-virtualenv python2-wheel)
	_qt_creator_pkg=(qtcreator qt5-base qt5-doc qt6-base qt6-doc)
	_java_pkg=(jre-openjdk jdk-openjdk)
	_java_ide=(intellij-idea-community-edition eclipse-ecj)
	_perl_pkg=(perl)
	_ruby_pkg=(ruby ruby-irb)
	_nodejs_pkg=(nodejs)
	_nodejs_lts_pkg=(nodejs-lts-fermium nodejs-lts-erbium) # nodejs-lts-fermium - For 14.X version. nodejs-lts-erbium - For 12.X version
fi
#
## My inserts
#
_my_scripts_pkg=(xdialog libnotify) # perl
_my_script_dir="$filesdir/config/my-inserts/"
#
