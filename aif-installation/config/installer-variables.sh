######################################################################
##                                                                  ##
##                   Installer Variables                            ##
##                                                                  ##
######################################################################

# Installation
_mlpcrm=0                   # Once check the pacman-contrib at the rom system to uses in the rankmirror script 
KDE_INSTALLED=0             # Has KDE been installed? Used for display manager option
GNOME_INSTALLED=0           # Has Gnome been installed? Used for display manager option
LXDE_INSTALLED=0            # Has LXDE been installed? Used for display manager option
LXQT_INSTALLED=0            # Has LXQT been installed? Used for display manager option
DM_INSTALLED=0              # Has a display manager been installed?
LIGHTDM_INSTALLED=0         # Has LIGHTDM deen installed? Used for display manager option
COMMON_INSTALLED=0          # Has the common-packages option been taken?
DEEPIN_INSTALLED=0          # Has Deepin been installed?
NM_INSTALLED=0              # Has a network connection manager been installed and enabled?
NM_COMPONENT_INSTALLED=1    # Has component NetworkManager installed?
AXI_INSTALLED=0             # Have the ALSA, Xorg, and xf86-input packages been installed?
_x_pkg_menu_cl=""
_xorg_pkg_menu=""
_ugch=""
BOOTLOADER="n/a"            # Which bootloader has been installed?
EVOBOXFM=""                 # Which file manager has been selected for EvoBox?
EVOBOXIB=""                 # Which Internet Browser has been selected for EvoBox?
DM="n/a"                    # Which display manager has been installed?
KEYMAP="us"                 # Virtual console keymap. Default is "us"
XKBMAP="us"                 # X11 keyboard layout. Default is "us"
ZONE=""                     # For time
SUBZONE=""                  # For time
_h_c=0
_sethwclock=""
LOCALE="en_US.UTF-8"        # System locale. Default is "en_US.UTF-8"
COUNTRY_LIST=""
URL=""
COUNTRY_CODE=""
LTS=0                       # Has the LTS Kernel been installed?
GRAPHIC_CARD=""             # graphics card
INTEGRATED_GC=""            # Integrated graphics card for NVIDIA
NVIDIA_INST=0               # Indicates if NVIDIA proprietary driver has been installed
OLD_NVIDIA_PACMAN_ONCE=0	# Indicates for Nvidia-390xx old proprietary driver installed
_390xx_once=0
_390xx_dkms_once=0
SHOW_ONCE=0                 # Show de_wm information only once
_nvd_dep_once=0				# Nvidia dependensis once
_nvd_dep_mn=""				# Nvidia dependensis menu
_dm_menu_once=0             # Dm menu once forms to search dm
_nm_once=0                  # Nm menu once forms to search nm
_wifi_menu=""
_dm_desktop_menu=""
_list_dm_menu=""
_ldm_menu=""
_d_menu_once=0
_listdm_menu=""
_standart_pkg_menu=""
_nm_tc_menu=""
_shara_pkg_mn_list=""
_multilib=0                                                    # Multilib additional repositoryes to qestion
_user_local=""                                                 # Forms User Locale in auto forms on Locale menu
_freefile=""                                                   # File of comand "free -h"
_swappiness=""                                                 # Variable to save parameter swappiness
_mem_file="/tmp/mem.conf"                                      # file of info memory
_mem_msg_file="/tmp/msginfo.nfo"                               # Information on swappiness
_File_of_Config="/tmp/00-sysctl.conf"                          # Temp configuration swappiness
_real_dir_swpns="${MOUNTPOINT}/etc/sysctl.d/"                  # Real dir to swappiness on config
_real_swappiness="${MOUNTPOINT}/etc/sysctl.d/00-sysctl.conf"   # File of full path swappiness config to install system
_mem_head=""
_memory=""
_mem_2=""

declare -a _devices                                            # Array scan mnt mount devices variables declare
declare -a _device_menu                                        # Array menu form on scan mnt mount devices variables declare
DEVICES=""                                                     # Array devices to clear
_isreserved=""                                                 # Percentage to setup reserved block count on root
_rsrvd_file="/tmp/rsrvd.nfo"                                   # File information to reserved block count
_tmp_fstab="/tmp/tmp.fstab"                                    # File information on tmp folder to FSTAB
_once_shwram=0                                                 # Once form memory information to mem file

_net_cntrl=0                                                   # Once run install qestion wireless programm
_shara_p=0                                                     # Once run install qestion shara programm
file_list_pkg="/tmp/flpkg.conf"                                # File to forms on new lists to pkgs

_wifi_menu_form=0                                              # Once forms wifi menu on wifi adapter your PC
_list_wifi_adapter_pkg=""                                      # Search package to wifi adapter driver
_wifi_menu=""                                                  # Forms wifi menu to save

_bltth=0                                                       # Bluetooth once setup drivers

# Variables of keyboard parameters
_is_xkb=0
_skip=0
_switch_xkb=""
_indicate_xkd=""
_xkb_mdl=""
_xkb_list=""
_xkb_var=""
xkb_model=""
xkb_layout=""
xkb_variant=""
xkb_options=""

# SHELL
_how_shell=$(echo "$SHELL" | rev | cut -d '/' -f1 | rev | tr '[:upper:]' '[:lower:]')
_once_conf_fscr=0                   # once config to windows fonts and screenfetch startup console
_usr_list=""                        # list of user to home folder
_usr_lst_menu=""                    # dialog menu list of user to home folder
_old_shell=""                       # old select shell for seccurity
_scrnf=0                            # Flag to screenfetch question setup
_bool_bash=0                        # bash once screenfetch config
_bool_fish=0                        # fish once screenfetch config
_bsh_stp_once=0                     # Once setup bash
_zsh_stp_once=0                     # Once setup zsh
_fsh_stp_once=0                     # Once setup fish
_once_slin_shll=0
_list_shells_sh=""
_list_bash_sh=""
_list_zsh_sh=""
_mn_shll_sh=""

# Architecture
ARCHI=$(uname -m)           # Display whether 32 or 64 bit system
SYSTEM="Unknown"            # Display whether system is BIOS or UEFI. Default is "unknown"
ROOT_PART=""                # ROOT partition
UEFI_PART=""                # UEFI partition
UEFI_MOUNT=""               # UEFI mountpoint
INST_DEV=""                 # Device where system has been installed
HIGHLIGHT=0                 # Highlight items for Main Menu
HIGHLIGHT_SUB=0             # Highlight items for submenus
SUB_MENU=""                 # Submenu to be highlighted

# Logical Volume Management
LVM=0                       # Logical Volume Management Detected?
LUKS=0                      # Luks Detected?
LVM_ROOT=0                  # LVM used for Root?
LVM_SEP_BOOT=0              # 1 = Seperate /boot, 2 = seperate /boot & LVM
LVM_DISABLE=0               # Option to allow user to deactive existing LVM
LVM_VG=""                   # Name of volume group to create
LVM_VG_MB=0                 # MB remaining of VG
LVM_LV_NAME=""              # Name of LV to create
LV_SIZE_INVALID=0           # Is LVM LV size entered valid?
VG_SIZE_TYPE=""             # Is VG in Gigabytes or Megabytes?

# LUKS
LUKS=0                      # Luks Detected?
LUKS_DEV=""                 # If encrypted, partition
LUKS_NAME=""                # Name given to encrypted partition
LUKS_UUID=""                # UUID used for comparison purposes
LUKS_OPT=""                 # Default or user-defined?

# Installation
MOUNTPOINT="/mnt"              # Installation
MOUNT_TYPE=""                  # "/dev/" for standard partitions, "/dev/mapper" for LVM
BTRFS=0                        # BTRFS used? "1" = btrfs alone, "2" = btrfs + subvolume(s)
BTRFS_OPTS="/tmp/.btrfs_opts"  # BTRFS Mount options
BTRFS_MNT=""                   # used for syslinux where /mnt is a btrfs subvolume
BYPASS="$MOUNTPOINT/bypass/"   # Root image mountpoint
MOUNT_OPTS="/tmp/.mnt_opts"    # Filesystem Mount options
FS_OPTS=""                     # FS mount options available
CHK_NUM=16                     # Used for FS mount options checklist length
_orders=0                      # Skip, resume installation
_sstmd_rslvd_once=0			   # Disable systemd-resolved
# _xorg_installer = $AXI_INSTALLED
_DE_INSTALLED=0					# Desktop environment installed (Deepin, Gnome, LXDE, Mate, XFCE4...)
_DM_INSTALLED=0					# Display manager installed (GDM, LXDM, LighDM, SDDM, XDM)
_NM_INSTALLED=0					# Network manager installed (Netctl, Connman, NetworkManager, WiCd, DHCPCD)
_LIGHTDM_INSTALLED=0			# LightDM installed

# Language Support
CURR_LOCALE="en_US.UTF-8"      # Default Locale
FONT=""                        # Set new font if necessary

# Edit Files
FILE=""                        # Which file is to be opened?
FILE2=""                       # Which second file is to be opened?

# Mirror string configuration variables
_mirror_conf_str=""

# Network variables
_dhcpcd_out_once=0
_ntctl_tmp="${MOUNTPOINT}/etc/netctl/examples"
_ntctl_fl="${MOUNTPOINT}/etc/netctl"
_netctl_menu=""
_netctl_mn_once=0
_netctl_edit=""

# Server variables
_sshd_conf_name="sshd_config"
_sshd_conf_dir="${MOUNTPOINT}/etc/ssh/"
_sshd_conf_file="$filesdir/config/${_sshd_conf_name}"
_sshd_conf_orig="$filesdir/config/sshd_config_original"
_ssh_setup_once=0
_ssh_run_once=0
_docker_run_once=0
_prmtrtlg_once=0
_mail_srv_once=0
_lmp_srv_once=0
_lmenu_nmpsrv=""
_ftp_srv_once=0
_menu_list_ftp=""
_list_docker_pkg=""
_firewall_once=0
_list_firewall_pkg=""
_mlist_firewall=""
_file2ban_once=0
_list_file2ban_pkg=""
_mlist_file2ban=""
_clamav_once=0
_list_clamav_pkg=""
_mn_clamav=""

# SSH Variables
_auto_sshd_nfo_once=0
_pass_authentication_once=0
_pubkey_once=0
_keyfile_once=0
_client_session_once=0
client_count_once=0
rhosts_once=0

# Network time protocol server variables
_tmsnc_init_once=0
_tmsnc_stp_once=0
_tmsnc_slsrv_once=0
_sntp_async=0
_sntp_sttmzn_once=0
_sntp_wrconf_once=0
_base_zonesubzone=""
_all_srv_zones=(africa antarctica asia europe north-america oceania south-america)
_srv_zone=""
_srv_subzone=""
_srv_mn_zone=""
_srv_mn_subzone=""
_ntp_conf_file="${MOUNTPOINT}/etc/ntp.conf"
_sntp_conf_file="${MOUNTPOINT}/etc/systemd/timesyncd.conf"
_ntpconf_once=0
_ntp_driftfile_once=0
_ntp_logfile_once=0
_ntp_restrict_once=0
_ntp_cl_str_1="restrict"
_ntp_cl_str_2="mask"
_ntp_cl_str_3="nomodify notrap"
_ntp_client_str=""

# Color dialog configurated
_dlgrc_hm_sts=0
_dlgrc_rs_sts=0
_dlgrc_rr_sts=0
_dlgrc_hm_st="$HOME/.dialogrc"
_dlgrc_rt_st="/etc/dialogrc"
_dlgrc_rt_rt="/root/.dialogrc"
_dlgrc_hm_bp="$filesdir/dlg-home.bp"
_dlgrc_rt_st_bp="$filesdir/dlg-rt-st.bp"
_dlg_rt_rt_bp="$filesdir/dlg-rt-rt.bp"

# Programming
_makecmake_once=0
_list_makecmake_pkg=""
_lmenu_makecmake=""
_arduino_once=0
_c_cpp_once=0
_list_ccpp_pkg=""
_lmenu_ccpp=""
_lmenu_arduino=""
_list_arduino_pkg=""
_mingww64_once=0
_list_mingww64_pkg=""
_lmenu_mingww64=""
_python3_once=0
_list_py3_pkg=""
_lmenu_py3=""
_python2_once=0
_list_py2_pkg=""
_lmenu_py2=""
_qtcreator_once=0
_lmenu_qtcreator=""
_list_qtcreator_pkg=""
_java_once=0
_list_java_pkg=""
_list_java_ide_pkg=""
_lmenu_java=""
_lmenu_java_ide=""
_perl_once=0
_list_perl_pkg=""
_lmenu_perl=""
_ruby_once=0
_list_ruby_pkg=""
_lmenu_ruby=""
_golang_once=0
_list_golang_pkg=""
_lmenu_golang=""
_nodejs_once=0
_list_njs_pkg=""
_nodejs_lts_once=0
_list_njs_lts_pkg=""
_lts_menu_nodejs=""

# Packages
_apps_desktop_once=0
_youtube_dl_setup=0
_wallpaper_once=0

# General Menu Package


# /config/dialogrc-conf.sh						# Color dialog interface configured
# /modules/installer-variables.sh				# list of variables
# /config/list-pkg-forms.sh						# list of packages for uses the script
# /config/setup_function.sh						# Function to setup on local package, p.c. build package in aur
# /config/dependences_function.sh				# Dependences for script
# /config/ssh-config.sh							# SSH Configuration
# /modules/core-functions.sh					# language, checks
# /modules/configuration-functions.sh			# Keyboard, locale, time zone, FSTAB, mkinitcpio, user controls
# /modules/system-partitioning.sh				# managing partitions, installing the boot
# /modules/encryption-functions.sh				# Encryption
# /modules/logical-volume.sh					# LVM control
# /modules/installation-functions.sh			# system installation functions
# /modules/swappiness-config.sh					# SWAPPINESS
# /modules/devices-config.sh					# tune2fs
# /modules/shell_installer.sh					# SHELL installer functions
# /modules/main-interfaces.sh					# main menu interface
# /modules/server.sh							# Server menu, Server utilites installation
# /modules/network.sh							# Network Function
# /modules/ntp_configuration.sh					# Network Time Synchronized protocol configuration
# /modules/programming.sh						# Programming menu
# /modules/apps-functions.sh					# Package Menu functions
