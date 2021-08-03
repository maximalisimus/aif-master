#!/bin/bash
#
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
       if [[ $HIGHLIGHT_SUB != 7 ]]; then
          HIGHLIGHT_SUB=$(( HIGHLIGHT_SUB + 1 ))
       fi
    fi

    dialog --default-item ${HIGHLIGHT_SUB} --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_InstDEMenuTitle" --menu "$_InstDEMenuBody" 0 0 7 \
    "1" "$_AXITitle" \
    "2" "$_GCtitle" \
    "3" "$_InstDEMenuDE" \
    "4" "$_InstDEMenuNM" \
    "5" "$_InstDEMenuDM" \
    "6" "$_InstGeMenuGE" \
    "7" "$_Back" 2>${ANSWER}
    
    HIGHLIGHT_SUB=$(cat ${ANSWER})
    case $(cat ${ANSWER}) in
        "1") [[ AXI_INSTALLED -eq 0 ]] && install_alsa_xorg_input
            ;;
        "2") # _InstDEMenuGISD 
            setup_graphics_card 
             ;;
        "3") install_de_wm
             ;;
        "4") install_nm
             ;;
        "5") install_dm
             ;;
        "6") if [[ ${_archi[*]} == "x86_64" ]]; then
                install_gep
            else
                install_gep_old
            fi
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
       if [[ $HIGHLIGHT_SUB != 14 ]]; then
          HIGHLIGHT_SUB=$(( HIGHLIGHT_SUB + 1 ))
       fi
    fi

   dialog --default-item ${HIGHLIGHT_SUB} --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_SeeConfOptTitle" --menu "$_SeeConfOptBody" 0 0 14 \
   "1" "/etc/vconsole.conf" \
   "2" "/etc/locale.conf" \
   "3" "/etc/hostname" \
   "4" "/etc/hosts" \
   "5" "/etc/sudoers" \
   "6" "/etc/mkinitcpio.conf" \
   "7" "/etc/fstab" \
   "8" "/etc/resolv.conf" \
   "9" "/etc/sysctl.d/00-sysctl.conf" \
   "10" "/etc/dhcpcd.conf" \
   "11" "$_ncl_nname" \
   "12" "/etc/ntp.conf" \
   "13" "/etc/systemd/timesyncd.conf" \
   "14" "$BOOTLOADER" \
   "15" "$DM" \
   "16" "$_Back" 2>${ANSWER}
    
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
        "10") FILE="${MOUNTPOINT}/etc/dhcpcd.conf"
			;;
		"11") [ -e $_netctl_edit ] && FILE="$_netctl_edit"
			;;
		"12") FILE="${MOUNTPOINT}/etc/ntp.conf"
			;;
		"13") FILE="${MOUNTPOINT}/etc/systemd/timesyncd.conf"
			;;
        "14") case $BOOTLOADER in
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
        "15") case $DM in
                   "LXDM") FILE="${MOUNTPOINT}/etc/lxdm/lxdm.conf" 
                           ;;
                "LightDM") FILE="${MOUNTPOINT}/etc/lightdm/lightdm.conf" 
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

function mainmenu_finishexit()
{
	echo -n  -e "\e[1;31mPlease wait ...\e[0m"\\r
	[[ $DEEPIN_INSTALLED -eq 1 ]] && fixed_deepin_desktop
	wait
	echo -n  -e "\e[1;32mPlease wait ...\e[0m"\\r
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_yn_umprt_mn_ttl" --yesno "$_yn_umprt_mn_bd" 0 0
	if [[ $? -eq 0 ]]; then
		umount_partitions
	fi
	wait
	echo -n  -e "\e[1;31mPlease wait ...\e[0m"\\r
	clear
	pkg_manager_unset
	eml_zavershenie
	aur_pkg_finish
	rm -rf "$_pcm_tempf"
	echo -n  -e "\e[1;32mPlease wait ...\e[0m"\\r
	if [[ -f "$filesdir/remove_pkg.log" ]]; then
		dialog --defaultno --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_yesno_rmrf_ttl" --yesno "$_yesno_rmrf_bd" 0 0
		if [[ $? -eq 0 ]]; then
			clear
			echo ""
			cat "$filesdir/remove_pkg.log"
			echo ""
			rm -rf "$filesdir/remove_pkg.log"
		else
			clear
			echo ""
			cat "$filesdir/remove_pkg.log"
			echo ""
		fi
	fi
	un_us_dlgrc_conf
	exit 0
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
    "6" "$_MMInstServer" \
    "7" "$_swap_menu_title" \
    "8" "$_rsrvd_menu_title" \
    "9" "$_MMRunMkinit" \
    "10" "$_SeeConfOpt" \
    "11" "$_Done" 2>${ANSWER}

    HIGHLIGHT=$(cat ${ANSWER})
    
    # Depending on the answer, first check whether partition(s) are mounted and whether base has been installed
    if [[ $(cat ${ANSWER}) -eq 2 ]]; then
       check_mount
    fi

    if [[ $(cat ${ANSWER}) -ge 3 ]] && [[ $(cat ${ANSWER}) -le 7 ]]; then
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
        "6") server_menu
			;;
        "7") swap_menu
            ;;
        "8") rsrvd_menu
            ;;
        "9") run_mkinitcpio
             ;;
        "10") edit_configs
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
