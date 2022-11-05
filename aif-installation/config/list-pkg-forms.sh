######################################################################
##                                                                  ##
##                      List packages Forms                         ##
##                                                                  ##
###################################################################### 
##
## File for form in lists packages to master
##
## 23 July 2019 years
##
##
#
# Install base menu
_pcm_conff="/etc/pacman.conf"
_pcm_tempf="$filesdir/new.conf"
_rank_mirror=(pacman-contrib)
_base_pkg=(bash btrfs-progs ntp sudo f2fs-tools dialog htop nano vi ntfs-3g linux-headers squashfs-tools upower mlocate testdisk hwinfo mkinitcpio)
_base_devel_pkg=(bash bzip2 coreutils cryptsetup device-mapper dhcpcd diffutils e2fsprogs file filesystem findutils gawk gcc-libs gettext glibc grep gzip inetutils iproute2 iputils jfsutils less licenses logrotate lvm2 man-db man-pages mdadm nano netctl pacman pciutils perl procps-ng psmisc reiserfsprogs s-nail sed shadow sysfsutils systemd-sysvcompat tar texinfo usbutils util-linux vi which xfsprogs btrfs-progs ntp sudo f2fs-tools dialog htop mc ntfs-3g bash-completion gparted net-tools linux-headers squashfs-tools upower mlocate recordmydesktop testdisk hwinfo mkinitcpio)
_lts_pkg=(linux-lts linux-lts-headers linux-lts-docs)
_krnl_pkg=(linux linux-headers linux-docs)
#
# Theme Dependensies
#
_adwaita_dep=(adwaita-icon-theme libadwaita)
#
# User and Groups
_us_gr_users=(adm ftp games http log rfkill sys systemd-journal users uucp wheel)
_us_gr_system=(dbus kmem locate lp mail nobody proc smmsp tty utmp)
_us_gr_presystemd=(audio disk floppy input kvm optical scanner storage video)
#
# Package Network tools
_network_menu=(netctl connman networkmanager wicd-gtk)
_ln_menu=""
_network_pkg=(samba libwbclient smb4k smbclient smbnetfs libgtop)
_connman_pkg=(connman)
_networkmanager_pkg=(networkmanager network-manager-applet)
_net_connect_var=(rp-pppoe networkmanager-openconnect networkmanager-openvpn networkmanager-pptp networkmanager-vpnc)
_wicd_pkg=(wicd wicd-gtk)
#
# Network time protocol server packages
_ntp_pkg=(ntp networkmanager-dispatcher-ntpd)
#
# Packages for wireless tools
_wifi_pkg=(iw wireless_tools wpa_actiond wpa_supplicant wicd)
_wifi_menu=""
_broadcom=(b43-fwcutter)
_list_broadcom=""
_menu_wifi=("Show_Devices" "Broadcom_802.11b/g/n" "Intel_PRO/Wireless_2100" "Intel_PRO/Wireless_2200" "All" "Back")
_bluetooth=(blueman bluez bluez-libs bluez-plugins bluez-utils bluez-tools)
#
# Package for grub and uefi menu
_grub_pkg=(grub os-prober)
_syslinux_pkg=(syslinux)
_grub_uefi_pkg=(grub os-prober efibootmgr dosfstools)
_reefind_pkg=(refind efibootmgr dosfstools)
_systemd_boot_pkg=(efibootmgr dosfstools)
#
# Alsa xorg packages
_xf86_input_pkg=(xf86-input-synaptics xf86-input-keyboard xf86-input-mouse)
_alsa_pkg=(alsa-tools alsa-lib alsa-utils alsa-plugins volumeicon lib32-alsa-plugins alsa-card-profiles)
_pulseaudio_pkg=(pavucontrol pulseaudio pulseaudio-alsa pulseaudio-bluetooth pulseaudio-equalizer pulseaudio-jack pulsemixer pasystray pamixer pulseview lib32-libpulse libpulse pipewire)
_x_pkg=( ${_xf86_input_pkg[*]} ${_alsa_pkg[*]} ${_pulseaudio_pkg[*]} )
#
# Graphic Card packages
_intel_pkg=(xf86-video-intel libva-intel-driver intel-ucode)
_ati_pkg=(xf86-video-ati amd-ucode)
_nvidia_pkg=(nvidia nvidia-settings nvidia-utils lib32-nvidia-utils pangox-compat)
_nvidia_lts_pkg=(nvidia-lts nvidia-settings nvidia-utils lib32-nvidia-utils pangox-compat)
_nvd_dkms_pkg=(nvidia-dkms nvidia-settings nvidia-utils lib32-nvidia-utils pangox-compat)
_nvd_dep=(cuda bumblebee mesa mesa-demos libva-utils libvdpau lib32-libvdpau lib32-virtualgl)
_nouveau=(xf86-video-nouveau)
_openchrome=(xf86-video-openchrome)
_vbox_pkg=(virtualbox-guest-utils virtualbox-guest-modules )
_vbox_lts_pkg=(virtualbox-guest-utils)
_vmware_pkg=(xf86-video-vmware xf86-input-vmmouse)
_generic_pkg=(xf86-video-fbdev)
#
# Desktop environment packages
_desktop_menu=("Deepin" "Deepin_Deepin-Extra" "Cinnamon" "Enlightenment" "Gnome-Shell_minimal" "Gnome" "Gnome_Gnome-Extras" "KDE-5-Base_minimal" "KDE-5" "LXDE" "LXQT" "MATE" "MATE_MATE-Extras" "Xfce" "Xfce_Xfce-Extras" "Awesome-WM" "Fluxbox-WM" "i3-WM" "Ice-WM" "Openbox-WM" "Pek-WM") # WindowMaker-WM
_deepin_pkg=(deepin)
_deepin_dep_pkg=(lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings ${_adwaita_dep[*]})
_deepin_extra_pkg=(deepin deepin-extra)
_deepin_extra_dep_pkg=(lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings ${_adwaita_dep[*]})
_cinnamon_pkg=(cinnamon)
_enlightenment_pkg=(enlightenment)
_enlightenment_dep=(terminology polkit-gnome)
_gnome_shell_pkg=(gnome-shell)
_gnome_shell_dep=(gdm)
_gnome_pkg=(gnome)
_gnome_dep=(gdm rp-pppoe)
_gnome_extras_pkg=(gnome gnome-extra)
_gnome_extras_dep=(gdm rp-pppoe)
_kde5base_pkg=(plasma-desktop)
_kde5base_dep=(p-pppoe)
_kde_pkg=(plasma)
_kde_dep=(rp-pppoe)
_lxde_pkg=(lxde)
_lxqt_pkg=(lxqt)
_lxqt_dep=(oxygen-icons)
_mate_pkg=(mate)
_mate_extra_pkg=(mate mate-extra)
_xfce4_pkg=(xfce4)
_xfce4_dep=(polkit-gnome xfce4-pulseaudio-plugin xfdesktop xfwm4 xfwm4-themes)
_xfce4_extra_pkg=(xfce4 xfce4-goodies)
_xfce4_extra_dep=(polkit-gnome xfce4-pulseaudio-plugin xfdesktop xfwm4 xfwm4-themes)
_awesome_pkg=(awesome)
_awesome_dep=(vicious polkit-gnome)
_fluxbox_pkg=(fluxbox)
_fluxbox_dep=(polkit-gnome)
_i3wm_pkg=(i3-wm)
_i3wm_dep=(i3lock i3status dmenu polkit-gnome)
_icewm_pkg=(icewm)
_icewm_dep=(icewm-themes polkit-gnome)
_openbox_pkg=(openbox)
_openbox_dep=(openbox-themes polkit-gnome)
_pekwm_pkg=(pekwm)
_pekwm_dep=(pekwm-themes polkit-gnome)
_windowmaker_pkg=(windowmaker)
_windowmaker_dep=(polkit-gnome)
#
# Common for Desktop packages
_general_pkg=(gnome-keyring dconf dconf-editor lib32-dconf gsettings-desktop-schemas python2-xdg xdg-user-dirs xdg-utils rp-pppoe polkit gvfs gvfs-afc gvfs-smb acpid avahi cronie print-manager system-config-printer cups cups-pdf)
#
# DM packages
_user_dm_menu=(lxdm lightdm sddm gdm slim)
_ldm_menu=""
_lxdm_pkg=(lxdm)
_lightdm_pkg=(lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings ${_adwaita_dep[*]})
_sddm_pkg=(sddm sddm-kcm)
_gdm_pkg=(gdm)
_slim_pkg=(slim)
#
# List of packages SHELL
_screen_startup=(screenfetch)
_shells_sh=(bash fish zsh dash ksh tcsh)
_bash_sh=(bash-completion)
_zsh_sh=(zsh-completions)
#
# User Package
_archivers_pkg=(ark xarchiver unzip zip unrar p7zip file-roller)
_ttf_pkg=(ttf-liberation ttf-dejavu opendesktop-fonts ttf-bitstream-vera ttf-arphic-ukai ttf-arphic-uming ttf-hanazono terminus-font)
_theme_pkg=(gnome-icon-theme-extras breeze breeze-grub breeze-icons fontforge ${_adwaita_dep[*]} alacarte hicolor-icon-theme)
_ttf_theme_pkg=( ${_ttf_pkg[*]} ${_theme_pkg[*]} )
#
_icontheme_url="https://github.com/maximalisimus/Archivers-Configs-Linux/releases/download/v1.0/LinuxLex-8.tar.gz"
_icontheme_pkg="/tmp/LinuxLex-8.tar.gz"
_wallpapers_url="https://github.com/maximalisimus/Archivers-Configs-Linux/releases/download/v1.0/wallpapers.tar.gz"
_wallpapers_pkg="/tmp/wallpapers.tar.gz"
_wallpapers_tmp_dir="/tmp/wallpapers"
_truetype_url="https://github.com/maximalisimus/Archivers-Configs-Linux/releases/download/v1.0/MS-TrueType-Core-Fonts.tar.gz"
_truetype_pkg="/tmp/MS-TrueType-Core-Fonts.tar.gz"
_grub_theme_destiny="https://github.com/maximalisimus/Archivers-Configs-Linux/releases/download/v1.0/grub-theme-destiny.tar.gz"
_grub_theme_destiny_pkg="/tmp/grub-theme-destiny.tar.gz"
_grub_theme_destiny_tmp_dir="/tmp/grub-theme-destiny"
_grub_theme_starfield="https://github.com/maximalisimus/Archivers-Configs-Linux/releases/download/v1.0/grub-theme-starfield.tar.gz"
_grub_theme_starfield_pkg="/tmp/grub-theme-starfield.tar.gz"
_grub_theme_starfield_tmp_dir="/tmp/grub-theme-starfield"
#
# gimp gimp-help-ru
_gr_editor=(gimp)
_office=(libreoffice-fresh)
# libreoffice-fresh libreoffice-fresh-ru
_minimal_pkg=(grub-customizer xterm cmake brasero acetoneiso2 fuseiso chromium transmission-gtk curl git wget gwget ksysguard libksysguard doublecmd-gtk2 krusader blender vlc inkscape okular gedit geany mousepad parcellite gimp galculator)
_archi=$(uname -m)
if [[ "${_archi[*]}" = "x86_64" ]]; then
	_mirrorlist_url="https://archlinux.org/mirrorlist/?country="
	# https://archlinux.org/mirrorlist/?country=RU&protocol=http&protocol=https&ip_version=4&ip_version=6&use_mirror_status=on
	countries_list=("all_ALL AU_Australia AT_Austria BD_Bangladesh BY_Belarus BE_Belgium BA_Bosnia BR_Brazil BG_Bulgaria KH_Cambodia CA_Canada CL_Chile CN_China CO_Colombia HR_Croatia CZ_Czechia DK_Denmark EC_Ecuador EE_Estonia FI_Finland FR_France GE_Georgia DE_Germany GR_Greece HK_Hong_Kong HU_Hungary IS_Iceland IN_India ID_Indonesia IR_Iran IE_Ireland IL_Israel IT_Italy JP_Japan KZ_Kazakhstan KE_Kenya LV_Latvia LT_Lithuania LU_Luxembourg MX_Mexico MD_Moldova MC_Monaco NL_Netherlands NC_New_Caledonia NZ_New_Zealand MK_North_Macedonia NO_Norway PK_Pakistan PY_Paraguay PL_Poland PT_Portugal RO_Romania RU_Russia RE_Reunion RS_Serbia SG_Singapore SK_Slovakia ZA_South_Africa KR_South_Korea ES_Spain SE_Sweden CH_Switzerland TW_Taiwan TH_Thailand TR_Turkey UA_Ukraine GB_United_Kingdom US_United_States UZ_Uzbekistan VN_Vietnam")
else
	_mirrorlist_url="https://archlinux32.org/mirrorlist/?country="
	# https://archlinux32.org/mirrorlist/?country=ru&protocol=http&protocol=https&ip_version=4&ip_version=6&use_mirror_status=on
	countries_list=("ALL_ALL BY_Belarus FR_France DE_Germany GR_Greece PL_Poland RU_Russia CH_Switzerland US_United_States")
fi
