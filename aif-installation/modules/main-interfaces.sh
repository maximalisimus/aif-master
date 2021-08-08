######################################################################
##                                                                  ##
##                 Main Interfaces                                  ##
##                                                                  ##
######################################################################

# Greet the user when first starting the installer
greeting() {

dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_WelTitle $VERSION " --msgbox "$_WelBody" 0 0    

}

# Preparation
prep_menu() {
    
    if [[ $SUB_MENU != "prep_menu" ]]; then
       SUB_MENU="prep_menu"
       HIGHLIGHT_SUB=1
    else
       if [[ $HIGHLIGHT_SUB != 8 ]]; then
          HIGHLIGHT_SUB=$(( HIGHLIGHT_SUB + 1 ))
       fi
    fi
    
   dialog --default-item ${HIGHLIGHT_SUB} --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_PrepTitle" \
    --menu "$_PrepBody" 0 0 8 \
    "1" "$_ConfBseVirtCon" \
    "2" "$_PrepMirror" \
    "3" "$_DevShowOpt" \
    "4" "$_PrepPartDisk" \
    "5" "$_PrepLUKS" \
    "6" "$_PrepLVM" \
    "7" "$_PrepMntPart" \
    "8" "$_Back" 2>${ANSWER}

    HIGHLIGHT_SUB=$(cat ${ANSWER})
    case $(cat ${ANSWER}) in
        "1") set_keymap 
             ;;
        "2") configure_mirrorlist
             ;;
        "3") show_devices
             ;;
        "4") umount_partitions
             select_device
             create_partitions
             ;;
        "5") luks_menu
            ;;
        "6") detect_lvm
             deactivate_lvm
             find_lvm_partitions
             create_lvm
             ;;
        "7") mount_partitions
             ;;        
          *) main_menu_online
             ;;
    esac
    
    prep_menu   
    
}

# Base Installation
install_base_menu() {

    if [[ $SUB_MENU != "install_base_menu" ]]; then
       SUB_MENU="install_base_menu"
       HIGHLIGHT_SUB=1
    else
       if [[ $HIGHLIGHT_SUB != 6 ]]; then
          HIGHLIGHT_SUB=$(( HIGHLIGHT_SUB + 1 ))
       fi
    fi

   dialog --default-item ${HIGHLIGHT_SUB} --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_InstBsMenuTitle" --menu "$_InstBseMenuBody" 0 0 6 \
    "1" "$_PrepPacKey" \
    "2" "$_InstBse" \
    "3" "$_InstBootldr" \
    "4" "$_InstWirelessFirm" \
    "5" "$_yesno_bluetooth_ttl" \
    "6" "$_Back" 2>${ANSWER}    
    
    HIGHLIGHT_SUB=$(cat ${ANSWER})
    case $(cat ${ANSWER}) in
        "1") clear
             pacman-key --init
             pacman-key --populate archlinux
             pacman-key --refresh-keys
             pacman -S archlinux-keyring --noconfirm
             ;;
        "2") install_base
             ;;
        "3") install_bootloader
             ;;
        "4") install_wireless_firmware
             ;;
        "5") bluetooth_question
             ;;
          *) main_menu_online
             ;;
     esac
    
    install_base_menu   
}

# Base Configuration
config_base_menu() {
    
    # Set the default PATH variable
    arch_chroot "PATH=/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/core_perl" 2>/tmp/.errlog
    check_for_error
    
    if [[ $SUB_MENU != "config_base_menu" ]]; then
       SUB_MENU="config_base_menu"
       HIGHLIGHT_SUB=1
    else
       if [[ $HIGHLIGHT_SUB != 8 ]]; then
          HIGHLIGHT_SUB=$(( HIGHLIGHT_SUB + 1 ))
       fi
    fi

    dialog --default-item ${HIGHLIGHT_SUB} --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_ConfBseTitle" --menu "$_ConfBseBody" 0 0 8 \
    "1" "$_ConfBseFstab" \
    "2" "$_ConfBseHost" \
    "3" "$_ConfBseTime" \
    "4" "$_ConfBseHWC" \
    "5" "$_mn_tmsnc_ttl" \
    "6" "$_ConfBseSysLoc" \
    "7" "$_PrepKBLayout" \
    "8" "$_Back" 2>${ANSWER}    
    
    HIGHLIGHT_SUB=$(cat ${ANSWER})
    case $(cat ${ANSWER}) in
        "1") generate_fstab 
             ;;
        "2") set_hostname
             ;;
        "3") set_timezone
             ;;
        "4") set_hw_clock
             ;;
		"5") time_sync_menu
			;;
        "6") set_locale
             ;;
        "7") set_xkbmap
             ;;           
          *) main_menu_online
             ;;
    esac
    config_base_menu
}

# Root and User Configuration
config_user_menu() {

    if [[ $SUB_MENU != "config_user_menu" ]]; then
       SUB_MENU="config_user_menu"
       HIGHLIGHT_SUB=1
    else
       if [[ $HIGHLIGHT_SUB != 4 ]]; then
          HIGHLIGHT_SUB=$(( HIGHLIGHT_SUB + 1 ))
       fi
    fi

    dialog --default-item ${HIGHLIGHT_SUB} --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_ConfUsrTitle" --menu "$_ConfUsrBody" 0 0 4 \
    "1" "$_ConfUsrRoot" \
    "2" "$_ConfUsrNew" \
    "3" "$_shell_friendly_menu" \
    "4" "$_Back" 2>${ANSWER}
    
    HIGHLIGHT_SUB=$(cat ${ANSWER})
    case $(cat ${ANSWER}) in
    "1") set_root_password 
         ;;
    "2") create_new_user
         ;;
    "3") shell_friendly_setup
        ;;
      *) main_menu_online
         ;;
    esac
    
    config_user_menu
}


install_desktop_menu() {

    if [[ $SUB_MENU != "install_deskop_menu" ]]; then
       SUB_MENU="install_deskop_menu"
       HIGHLIGHT_SUB=1
    else
       if [[ $HIGHLIGHT_SUB != 8 ]]; then
          HIGHLIGHT_SUB=$(( HIGHLIGHT_SUB + 1 ))
       fi
    fi
	
	if [[ $_LIGHTDM_INSTALLED -eq 0 ]]; then	
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_InstDEMenuTitle" --menu "$_InstDEMenuBody" 0 0 8 \
		"1" "$_AXITitle" \
		"2" "$_InstDEMenuDE" \
		"3" "$_InstDEMenuDM" \
		"4" "$_wallp_yn_hd" \
		"5" "$_InstDEMenuNM" \
		"6" "$_GCtitle" \
		"7" "$_InstGeMenuGE" \
		"8" "$_Back" 2>${ANSWER}    
    else
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_InstDEMenuTitle" --menu "$_InstDEMenuBody" 0 0 8 \
		"1" "$_AXITitle" \
		"2" "$_InstDEMenuDE" \
		"3" "$_InstDEMenuDM" \
		"4" "$_ldm_greeter_qs_hd" \
		"5" "$_InstDEMenuNM" \
		"6" "$_GCtitle" \
		"7" "$_InstGeMenuGE" \
		"8" "$_Back" 2>${ANSWER}
    fi
    
    HIGHLIGHT_SUB=$(cat ${ANSWER})
    case $(cat ${ANSWER}) in
        "1") if [[ $AXI_INSTALLED -eq 0 ]]; then
				install_alsa_xorg_input
			fi
            ;;
        "2") check_xorg
			install_de_wm 
             ;;
        "3") check_xorg 
			 check_de
			 install_dm
             ;;
        "4") check_xorg
			check_de
			check_dm 
			if [[ $_LIGHTDM_INSTALLED -eq 0 ]]; then
				wallpaper_install
			else
				ldm_form_edit
			fi
			;;
        "5") install_nm
             ;;
        "6") check_xorg
			 check_de
			 check_dm
			 install_graphics_card
             ;;
        "7") install_apps_menu
             ;;
          *) main_menu_online
             ;;
    esac
    
    install_desktop_menu
    
}

edit_configs() {
    
    # Clear the file variables
    FILE=""
    FILE2=""
    user_list=""
    
    if [[ $SUB_MENU != "edit configs" ]]; then
       SUB_MENU="edit configs"
       HIGHLIGHT_SUB=1
    else
       if [[ $HIGHLIGHT_SUB != 19 ]]; then
          HIGHLIGHT_SUB=$(( HIGHLIGHT_SUB + 1 ))
       fi
    fi

   dialog --default-item ${HIGHLIGHT_SUB} --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_SeeConfOptTitle" --menu "$_SeeConfOptBody" 0 0 11 \
   "1" "/etc/vconsole.conf" \
   "2" "/etc/locale.conf" \
   "3" "/etc/hostname" \
   "4" "/etc/hosts" \
   "5" "/etc/sudoers" \
   "6" "/etc/mkinitcpio.conf" \
   "7" "/etc/fstab" \
   "8" "/etc/resolv.conf" \
   "9" "/etc/sysctl.d/00-sysctl.conf" \
   "10" "/etc/sysctl.d/40-ipv6.conf" \
   "11" "/etc/sysctl.d/30-ipforward.conf" \
   "12" "/etc/dhcpcd.conf" \
   "13" "$_ncl_nname" \
   "14" "/etc/ntp.conf" \
   "15" "/etc/systemd/timesyncd.conf" \
   "16" "/etc/ssh/sshd_config" \
   "17" "$BOOTLOADER" \
   "18" "$DM" \
   "19" "$_Back" 2>${ANSWER}
    
    HIGHLIGHT_SUB=$(cat ${ANSWER})
    case $(cat ${ANSWER}) in
        "1") FILE="${MOUNTPOINT}/etc/vconsole.conf"
             ;;
        "2") FILE="${MOUNTPOINT}/etc/locale.conf" 
             ;;
        "3") FILE="${MOUNTPOINT}/etc/hostname"
             ;;
        "4") FILE="${MOUNTPOINT}/etc/hosts"
             ;;
        "5") FILE="${MOUNTPOINT}/etc/sudoers"
             ;;
        "6") FILE="${MOUNTPOINT}/etc/mkinitcpio.conf"
             ;;
        "7") FILE="${MOUNTPOINT}/etc/fstab"
             ;;
        "8") FILE="${MOUNTPOINT}/etc/resolv.conf"
             ;;
        "9") FILE="${MOUNTPOINT}/etc/sysctl.d/00-sysctl.conf"
            ;;
        "10") FILE="${MOUNTPOINT}/etc/sysctl.d/40-ipv6.conf"
			;;
		"11") FILE="${MOUNTPOINT}/etc/sysctl.d/30-ipforward.conf"
			;;
        "12") FILE="${MOUNTPOINT}/etc/dhcpcd.conf"
			;;
		"13") [ -e $_netctl_edit ] && FILE="$_netctl_edit"
			;;
		"14") FILE="${MOUNTPOINT}/etc/ntp.conf"
			;;
		"15") FILE="${MOUNTPOINT}/etc/systemd/timesyncd.conf"
			;;
		"16") FILE="${MOUNTPOINT}/etc/ssh/sshd_config"
			;;
        "17") case $BOOTLOADER in
                   "Grub") FILE="${MOUNTPOINT}/etc/default/grub"
                           ;;
               "Syslinux") FILE="${MOUNTPOINT}/boot/syslinux/syslinux.cfg"
                           ;;
           "systemd-boot") FILE="${MOUNTPOINT}${UEFI_MOUNT}/loader/entries/arch.conf" 
                           FILE2="${MOUNTPOINT}${UEFI_MOUNT}/loader/loader.conf"
                           ;;
                 "rEFInd") [[ -e ${MOUNTPOINT}${UEFI_MOUNT}/EFI/refind/refind.conf ]] \
                           && FILE="${MOUNTPOINT}${UEFI_MOUNT}/EFI/refind/refind.conf" || FILE="${MOUNTPOINT}${UEFI_MOUNT}/EFI/BOOT/refind.conf"
                           FILE2="${MOUNTPOINT}/boot/refind_linux.conf"
                           ;;
              esac
            ;;
        "18") case $DM in
                   "LXDM") FILE="${MOUNTPOINT}/etc/lxdm/lxdm.conf" 
                           ;;
                "LightDM") FILE="${MOUNTPOINT}/etc/lightdm/lightdm.conf"
							FILE2="${MOUNTPOINT}/etc/lightdm/lightdm-gtk-greeter.conf"
                           ;;
                   "SDDM") FILE="${MOUNTPOINT}/etc/sddm.conf"
                           ;;
                   "SLiM") FILE="${MOUNTPOINT}/etc/slim.conf"
                           ;;
              esac
            ;;
         *) main_menu_online
            ;;
     esac
     
        # open file(s) with nano   
        if [[ -e $FILE ]] && [[ $FILE2 != "" ]]; then
           nano $FILE $FILE2
        elif [[ -e $FILE ]]; then 
           nano $FILE
        else
           dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_SeeConfErrTitle" --msgbox "$_SeeConfErrBody1" 0 0
        fi
     
     edit_configs
}

main_menu_online() {
    
    if [[ $HIGHLIGHT != 11 ]]; then
       HIGHLIGHT=$(( HIGHLIGHT + 1 ))
    fi
    
    dialog --default-item ${HIGHLIGHT} --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_MMTitle" \
    --menu "$_MMBody" 0 0 11 \
    "1" "$_MMPrep" \
    "2" "$_MMInstBse" \
    "3" "$_MMConfBse" \
    "4" "$_MMConfUsr" \
    "5" "$_MMInstDE" \
    "6" "$_swap_menu_title" \
    "7" "$_rsrvd_menu_title" \
    "8" "$_MMRunMkinit" \
    "9" "$_SeeConfOpt" \
    "10" "$_Done" 2>${ANSWER}

    HIGHLIGHT=$(cat ${ANSWER})
    
    # Depending on the answer, first check whether partition(s) are mounted and whether base has been installed
    if [[ $(cat ${ANSWER}) -eq 2 ]]; then
       check_mount
    fi

    if [[ $(cat ${ANSWER}) -ge 3 ]] && [[ $(cat ${ANSWER}) -le 9 ]]; then
       check_mount
       check_base
    fi
    
    case $(cat ${ANSWER}) in
        "1") prep_menu 
             ;;
        "2") install_base_menu
             ;;
        "3") config_base_menu
             ;;
        "4") config_user_menu
             ;;            
        "5") install_desktop_menu
             ;;
        "6") swap_menu
            ;;
        "7") rsrvd_menu
            ;;
        "8") run_mkinitcpio
             ;;
        "9") edit_configs
             ;;            
          *) dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --yesno "$_CloseInstBody" 0 0
          
             if [[ $? -eq 0 ]]; then
                mainmenu_finishexit
             else
                main_menu_online
             fi
             
             ;;
    esac
    
    main_menu_online 
    
}
