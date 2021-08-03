#!/bin/bash
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
# Server list of packages
_ssh_pkg=(openssh)
_mail_srv_pkg=(postfix)
_namp_srv_pkg=(nginx apache mysql php phpmyadmin php-fpm php-apache php-mcrypt)
_ftp_srv_pkg=(atftp bftpd curlftpfs filezilla gftp lftp tnftp vsftpd)
#
# Network time protocol server packages
_ntp_pkg=(ntp networkmanager-dispatcher-ntpd)
#
# Packages for wireless tools
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
# Package for grub and uefi menu
_grub_pkg=(grub os-prober)
_syslinux_pkg=(syslinux)
_grub_uefi_pkg=(grub os-prober efibootmgr dosfstools)
_reefind_pkg=(refind-efi efibootmgr dosfstools)
_systemd_boot_pkg=(efibootmgr dosfstools)
#
# Alsa xorg packages
_x_pkg=(alsa-utils alsa-plugins volumeicon pavucontrol pulseaudio pulseaudio-alsa pulseaudio-bluetooth pulseaudio-equalizer pulseaudio-jack pulseeffects pulsemixer pasystray pamixer pulseview rhythmbox audacious audacity xf86-input-synaptics xf86-input-keyboard xf86-input-mouse)
#
# Graphic Card packages
_intel_pkg=(xf86-video-intel libva-intel-driver intel-ucode)
_ati_pkg=(xf86-video-ati)
_nvidia_pkg=(nvidia nvidia-utils pangox-compat nvidia-settings)
_nvidia_lts_pkg=(nvidia-lts nvidia-utils nvidia-settings pangox-compat)
_nvidia_name=""
_nouveau=(xf86-video-nouveau)
_openchrome=(xf86-video-openchrome)
_vbox_pkg=(virtualbox-guest-utils virtualbox-guest-modules )
_vbox_lts_pkg=(virtualbox-guest-utils)
_vmware_pkg=(xf86-video-vmware xf86-input-vmmouse)
_generic_pkg=(xf86-video-fbdev)
#
# Desktop environment packages
_desktop_menu=("Deepin" "Deepin_Deepin-Extra" "Cinnamon" "Enlightenment" "Gnome-Shell_minimal" "Gnome" "Gnome_Gnome-Extras" "KDE-5-Base_minimal" "KDE-5" "LXDE" "LXQT" "MATE" "MATE_MATE-Extras" "Xfce" "Xfce_Xfce-Extras" "Awesome-WM" "Fluxbox-WM" "i3-WM" "Ice-WM" "Openbox-WM" "Pek-WM") # WindowMaker-WM
_d_menu=(deepin deepin-extra cinnamon enlightenment gnome-shell gnome gnome-extra plasma-desktop plasma lxde lxqt mate mate-extra xfce4 xfce4-goodies awesome fluxbox i3-wm icewm openbox pekwm) # windowmaker
_deepin_pkg=(deepin lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings)
_deepine_pkg=(deepin deepin-extra lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings)
_cinnamon_pkg=(cinnamon)
_enlightenment_pkg=(enlightenment terminology polkit-gnome)
_gnome_shell_pkg=(gnome-shell gdm)
_gnome_pkg=(gnome gdm rp-pppoe)
_gnome_extras_pkg=(gnome gdm gnome-extra rp-pppoe)
_kde5base_pkg=(plasma-desktop p-pppoe)
_kde_pkg=(plasma rp-pppoe)
_lxde_pkg=(lxde)
_lxqt_pkg=(lxqt oxygen-icons)
_mate_pkg=(mate)
_mateextra_pkg=(mate mate-extra)
_xfce4_pkg=(xfce4 polkit-gnome xfce4-pulseaudio-plugin)
_xfce4_extra_pkg=(xfce4 xfce4-goodies polkit-gnome xfce4-pulseaudio-plugin)
_awesome_pkg=(awesome vicious polkit-gnome)
_fluxbox_pkg=(fluxbox fbnews polkit-gnome)
_i3wm_pkg=(i3-wm i3lock i3status dmenu polkit-gnome)
_icewm_pkg=(icewm icewm-themes polkit-gnome)
_openbox_pkg=(openbox openbox-themes polkit-gnome)
_pekwm_pkg=(pekwm pekwm-themes polkit-gnome)
_windowmaker_pkg=(windowmaker polkit-gnome)
#
# Common for Desktop packages
_general_pkg=(gnome-keyring dconf dconf-editor python2-xdg xdg-user-dirs xdg-utils rp-pppoe polkit gvfs gvfs-afc gvfs-smb print-manager system-config-printer acpid avahi cups cronie)
#
# DM packages
_user_dm_menu=(lxdm lightdm sddm gdm slim)
_ldm_menu=""
_lxdm_pkg=(lxdm)
_lightdm_pkg=(lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings)
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
_ttf_theme_pkg=(gnome-icon-theme ttf-liberation ttf-dejavu opendesktop-fonts ttf-bitstream-vera ttf-arphic-ukai ttf-arphic-uming ttf-hanazono terminus-font breeze breeze-grub breeze-icons fontforge faenza-icon-theme adwaita-icon-theme alacarte)
# gimp gimp-help-ru
_gr_editor=(gimp)
_office=(libreoffice-fresh)
# libreoffice-fresh libreoffice-fresh-ru
_minimal_pkg=(grub-customizer xterm gnome-terminal lxterminal cmake brasero acetoneiso2 fuseiso chromium opera transmission-gtk curl git wget gwget ksysguard doublecmd-gtk2 krusader blender vlc inkscape okular gedit geany leafpad parcellite gimp galculator)
emulator_packages=(desmume gens mednafen mupen64plus pcsx2 ppsspp)
_archi=$(uname -m)
if [[ "${_archi[*]}" = "x86_64" ]]; then
    _other_pkg=(keepassxc veracrypt virtualbox kicad kicad-library kicad-library-3d smplayer wine wine-mono wine_gecko winetricks supertuxkart) # truecrypt
    emulator_packages=(desmume gens mednafen mupen64plus pcsx2 ppsspp)
    _eml_folder="$filesdir/packages/emulators"
    _aur_pkg_folder="$filesdir/packages"
    _pkg_manager_folder="$filesdir/packages/package-manager"
    _rmt_rpstr_info="$filesdir/rmt.nfo"
    _aur_pkg_winfnts="$filesdir/config/windowsfonts.tar.gz"
    _aif_temp_folder="$filesdir/aif-temp"
    _aif_temp_aur_dir="$_aif_temp_folder/aif-installation/packages"
    _aif_temp_eml_dir="$_aif_temp_aur_dir/emulators"
    _aif_temp_pm_dir="$_aif_temp_aur_dir/package-manager"
else
    _other_pkg=(keepassxc veracrypt virtualbox kicad kicad-library kicad-library-3d smplayer wine-mono winetricks supertuxkart) # truecrypt
    emulator_packages=(desmume mednafen mupen64plus ppsspp)
    _eml_folder="$filesdir/packages_x86/emulators"
    _aur_pkg_folder="$filesdir/packages_x86"
    _pkg_manager_folder="$filesdir/packages_x86/package-manager"
    _rmt_rpstr_info="$filesdir/rmt.nfo"
    _aur_pkg_winfnts="$filesdir/config/windowsfonts.tar.gz"
    _aif_temp_folder="$filesdir/aif-temp"
    _aif_temp_aur_dir="$_aif_temp_folder/aif-installation/packages_x86"
    _aif_temp_eml_dir="$_aif_temp_aur_dir/emulators"
    _aif_temp_pm_dir="$_aif_temp_aur_dir/package-manager"
fi
aif_master_git="https://github.com/maximalisimus/aif-master.git"

