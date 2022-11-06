######################################################################
##                                                                  ##
##                    Bootloader Functions                          ##
##                                                                  ##
######################################################################  

bootloader_update(){
	clear
	case $BOOTLOADER in
		"Grub") arch-chroot $MOUNTPOINT /bin/bash -c "grub-mkconfig -o /boot/grub/grub.cfg" 2>/tmp/.errlog
				check_for_error
				wait
				if [[ "${_refind_is_install}" == "1" ]]; then
					arch-chroot $MOUNTPOINT /bin/bash -c "refind-install" 2>/tmp/.errlog
					check_for_error
				fi
				;;
		"Syslinux") case $_syslinux_type in 
						"2") arch-chroot $MOUNTPOINT /bin/bash -c "syslinux-install_update -iam" 2>/tmp/.errlog
							check_for_error
							;;
						"3") arch-chroot $MOUNTPOINT /bin/bash -c "syslinux-install_update -i" 2>/tmp/.errlog
							check_for_error
							;;
					esac
					;;
		"systemd-boot") arch_chroot "bootctl update" 2>/tmp/.errlog
						check_for_error
						;;
		"n/a") bootloader_searches
				wait
				bootloader_check_and_uses
				wait
				if [[ "$BOOTLOADER" == "n/a" ]]; then
					dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " Error! " --msgbox "\nBootloaders Not Found!\n" 0 0
				else
					bootloader_update
				fi
			;;
	esac
	wait
}

bootloader_searches()
{
	if [[ "$SYSTEM" == "BIOS" ]]; then
		_grub_search=$(search_q_pkg "${_grub_pkg[0]}" | sed '2,$d' | wc -l)
		_syslinux_search=$(search_q_pkg "${_syslinux_pkg[0]}" | sed '2,$d' | wc -l)
	else
		_grub_search=$(search_q_pkg "${_grub_uefi_pkg[0]}" | sed '2,$d' | wc -l)
		_refind_sarch=$(search_q_pkg "${_reefind_pkg[0]}" | sed '2,$d' | wc -l)
		_susytemd_boot_search=$(search_q_pkg "${_systemd_boot_pkg[0]}" | sed '2,$d' | wc -l)
	fi
}

bootloader_check_and_uses()
{
	if [[ "$SYSTEM" == "BIOS" ]]; then
		[[ "${_syslinux_search[*]}" == "1" ]] && BOOTLOADER="Syslinux"
		[[ "${_grub_search[*]}" == "1" ]] && BOOTLOADER="Grub"
	else
		if [[ "${_grub_search[*]}" == 1 ]]; then
			[[ "${_refind_sarch[*]}" == "1" ]] && _refind_is_install=1
			BOOTLOADER="Grub"
			_bootloader="Grub"
		else
			[[ "${_susytemd_boot_search[*]}" == "1" ]] && BOOTLOADER="systemd-boot"
			[[ "${_susytemd_boot_search[*]}" == "1" ]] && _bootloader="systemd-boot"
		fi
	fi
}

grub_theme_menu(){
	dialog --default-item 2 --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_grub_theme_stp_ttl" --menu "$_grub_theme_stp_menu" 0 0 4 \
	"1" "No Theme" \
	"2" "Destiny" \
	"3" "Starfield" \
	"4" "$_Back" 2>${ANSWER}
	
	case $(cat ${ANSWER}) in
		"1") no_grub_theme_setup
			;;
		"2") grub_theme_destiny_setup
			;;
		"3") grub_theme_starfield_setup
			;; 
		*) install_base_menu
			;;
	esac
}

grub_bios_install(){
	# Grub
	clear
	info_search_pkg
	_list_grub_pkg=$(check_s_lst_pkg "${_grub_pkg[*]}")
	wait
	clear
	[[ ${_list_grub_pkg[*]} != "" ]] && ps_in_pkg "${_list_grub_pkg[*]}"
	 
	 # An LVM VG/LV can consist of multiple devices. Where LVM used, user must select the device manually.
	 if [[ $LVM_ROOT -eq 1 ]]; then
		select_grub_device
	 else
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_InstGrubDevTitle" --yesno "$_InstGrubDevBody ($INST_DEV)?$_InstGrubDevBody2" 0 0
		
		if [[ $? -eq 0 ]]; then
			clear
			dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " Grub-install " --infobox "$_PlsWaitBody" 0 0
			sleep 1 
			arch_chroot "grub-install --target=i386-pc --recheck ${INST_DEV}" 2>/tmp/.errlog
			check_for_error
		else   
			select_grub_device
		fi
	 fi
	wait
	clear
	 arch_chroot "grub-mkconfig -o /boot/grub/grub.cfg" 2>/tmp/.errlog
	 check_for_error
	 
	 # if /boot is LVM then amend /boot/grub/grub.cfg accordingly
	 if ( [[ $LVM_ROOT -eq 1 ]] && [[ $LVM_SEP_BOOT -eq 0 ]] ) || [[ $LVM_SEP_BOOT -eq 2 ]]; then
		sed -i '/### BEGIN \/etc\/grub.d\/00_header ###/a insmod lvm' ${MOUNTPOINT}/boot/grub/grub.cfg
	 fi
	wait
	osprober_configuration
	wait
	 BOOTLOADER="Grub"
	 wait
	 grub_theme_menu
}

syslinux_bios_install(){
	# Syslinux
	clear
	info_search_pkg
	_list_syslinux_pkg=$(check_s_lst_pkg "${_syslinux_pkg[*]}")
	wait
	clear
	[[ ${_list_syslinux_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_list_syslinux_pkg[*]} 2>/tmp/.errlog
  
	 # Install to MBR or root partition, accordingly
	 [[ $(cat ${ANSWER}) == "2" ]] && arch_chroot "syslinux-install_update -iam" 2>>/tmp/.errlog
	 [[ $(cat ${ANSWER}) == "2" ]] && _syslinux_type=2
	 [[ $(cat ${ANSWER}) == "3" ]] && arch_chroot "syslinux-install_update -i" 2>>/tmp/.errlog
	 [[ $(cat ${ANSWER}) == "3" ]] && _syslinux_type=3
	 check_for_error
	 
	 # Amend configuration file depending on whether lvm used or not for root.
	 if [[ $LVM_ROOT -eq 0 ]]; then
		sed -i "s/sda[0-9]/${ROOT_PART}/g" ${MOUNTPOINT}/boot/syslinux/syslinux.cfg
	 else
		sed -i "s/APPEND.*/APPEND root=\/dev\/mapper\/${ROOT_PART} rw/g" ${MOUNTPOINT}/boot/syslinux/syslinux.cfg
	 fi
	 
	 # Amend configuration file for LTS kernel and/or btrfs subvolume as root
	 [[ $LTS -eq 1 ]] && sed -i 's/linux/linux-lts/g' ${MOUNTPOINT}/boot/syslinux/syslinux.cfg
	 [[ $BTRFS_MNT != "" ]] && sed -i "s/rw/rw $BTRFS_MNT/g" ${MOUNTPOINT}/boot/syslinux/syslinux.cfg
	 
	 BOOTLOADER="Syslinux"
}

grub_uefi_install(){
	# Grub2
	  clear
	  info_search_pkg
	  _list_grub_uefi_pkg=$(check_s_lst_pkg "${_grub_uefi_pkg[*]}")
	 wait
	 clear
	 [[ ${_list_grub_uefi_pkg[*]} != "" ]] && ps_in_pkg "${_list_grub_uefi_pkg[*]}"
	  
	  dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " Grub-install " --infobox "$_PlsWaitBody" 0 0
	  sleep 1
	  arch_chroot "grub-install --target=x86_64-efi --efi-directory=${UEFI_MOUNT} --bootloader-id=arch_grub --recheck" 2>/tmp/.errlog
	  wait
	  arch-chroot $MOUNTPOINT /bin/bash -c "grub-install --target=x86_64-efi --efi-directory=${UEFI_MOUNT} --bootloader-id=arch_grub --recheck" 2>>/tmp/.errlog
	  wait
	  clear
	  arch_chroot "grub-mkconfig -o /boot/grub/grub.cfg" 2>>/tmp/.errlog
	  wait
	  arch-chroot $MOUNTPOINT /bin/bash -c "grub-mkconfig -o /boot/grub/grub.cfg" 2>>/tmp/.errlog
	  wait
	  check_for_error
	  if [[ "${_multiple_system}" == "0" ]]; then
		  # Ask if user wishes to set Grub as the default bootloader and act accordingly
		  dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_SetGrubDefTitle" --yesno "$_SetGrubDefBody ${UEFI_MOUNT}/EFI/boot $_SetGrubDefBody2" 0 0
		  
		  if [[ $? -eq 0 ]]; then
			 arch_chroot "mkdir -p ${UEFI_MOUNT}/EFI/boot" 2>/tmp/.errlog
			 arch_chroot "cp -r ${UEFI_MOUNT}/EFI/arch_grub/grubx64.efi ${UEFI_MOUNT}/EFI/boot/bootx64.efi" 2>>/tmp/.errlog
			 check_for_error
			 dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_SetDefDoneTitle" --infobox "\nGrub $_SetDefDoneBody" 0 0
			 sleep 2
		  fi
	  fi
	  wait
	  osprober_configuration
	  wait
	  BOOTLOADER="Grub"
	  wait
	  grub_theme_menu
}

refind_uefi_install(){
	# rEFInd
   # Ensure that UEFI partition has been mounted to /boot/efi due to bug in script. Could "fix" it for installation, but
   # This could result in unknown consequences should the script be updated at some point.
   if [[ $UEFI_MOUNT == "/boot/efi" ]]; then      
	  clear
	  info_search_pkg
	  _list_reefind_pkg=$(check_s_lst_pkg "${_reefind_pkg[*]}")
	  wait
	  clear
	  [[ ${_list_reefind_pkg[*]} != "" ]] && ps_in_pkg "${_list_reefind_pkg[*]}"
	  
	  wait
	  
	  clear
	  
	  #if [[ "${_refind_question[*]}" -eq 0 ]]; then
		#	arch_chroot "refind-install --usedefault ${UEFI_PART} --alldrivers" 2>/tmp/.errlog
	  #else
		#	arch_chroot "refind-install" 2>/tmp/.errlog
	  #fi
	  
	  wait
	  
	  dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_SetRefiDefTitle" --yesno "$_SetRefiDefBody ${UEFI_MOUNT}/EFI/boot $_SetRefiDefBody2" 0 0
	  
	   if [[ $? -eq 0 ]]; then
		 clear
		 arch_chroot "refind-install --usedefault ${UEFI_PART} --alldrivers" 2>/tmp/.errlog
		 wait
		 arch-chroot $MOUNTPOINT /bin/bash -c "refind-install --usedefault ${UEFI_PART} --alldrivers" 2>>/tmp/.errlog
		 wait
	  else   
		clear
		arch_chroot "refind-install" 2>/tmp/.errlog
		wait
		arch-chroot $MOUNTPOINT /bin/bash -c "refind-install" 2>>/tmp/.errlog
		wait
	  fi   
	  
	  check_for_error
	  
	  # Now generate config file to pass kernel parameters. Default read only (ro) changed to read-write (rw),
	  # and amend where using btfs subvol root
	  arch_chroot "refind-mkrlconf" 2>/tmp/.errlog
	  check_for_error
	  sed -i 's/ro /rw /g' ${MOUNTPOINT}/boot/refind_linux.conf
	  [[ $BTRFS_MNT != "" ]] && sed -i "s/rw/rw $BTRFS_MNT/g" ${MOUNTPOINT}/boot/refind_linux.conf
	  
	  #BOOTLOADER="rEFInd"
	  _refind_is_install=1
   else 
	  dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_RefiErrTitle" --msgbox "$_RefiErrBody" 0 0
	  uefi_bootloader
   fi
   wait
   refind_configuration
   wait
}

refind_istallation_question()
{
	if [[ "${UEFI_MOUNT}" == "/boot/efi" ]]; then
		if [[ "${_refind_question[*]}" == "0" ]]; then
			dialog --defaultno --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_refind_yn_title" --yesno "rEFInd is not found. ${_refind_yn_body_else}" 0 0
			
			if [[ $? -eq 0 ]]; then
				refind_uefi_install
			fi
		else
			dialog --defaultno --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_refind_yn_title" --yesno "rEFInd is found.\n${_refind_yn_body_2}\n" 0 0
			
			if [[ $? -eq 0 ]]; then
				refind_uefi_install
			fi
		fi
	fi
}

systemd_boot_uefi_install(){
	# systemd-boot
	  clear
	  info_search_pkg
	  _list_systemd_boot_pkg=$(check_s_lst_pkg "${_systemd_boot_pkg[*]}")
	  wait
	  clear
	  [[ ${_list_systemd_boot_pkg[*]} != "" ]] && ps_in_pkg "${_list_systemd_boot_pkg[*]}"
	  
	  arch_chroot "bootctl --path=${UEFI_MOUNT} install" 2>>/tmp/.errlog
	  check_for_error
	  
	  # Deal with LVM Root
	  if [[ $LVM_ROOT -eq 0 ]]; then
		 sysdb_root=$(blkid -s PARTUUID $"/dev/"${ROOT_PART} | sed 's/.*=//g' | sed 's/"//g')
	  else
		 sysdb_root="/dev/mapper/${ROOT_PART}" 
	  fi
	   
	  # Deal with LTS Kernel
	  if [[ $LTS -eq 1 ]]; then
		echo -e "title\tArch Linux\nlinux\t/vmlinuz-linux-lts\ninitrd\t/initramfs-linux-lts.img\noptions\troot=PARTUUID=${sysdb_root} rw" > ${MOUNTPOINT}${UEFI_MOUNT}/loader/entries/arch.conf
	  else
		echo -e "title\tArch Linux\nlinux\t/vmlinuz-linux\ninitrd\t/initramfs-linux.img\noptions\troot=PARTUUID=${sysdb_root} rw" > ${MOUNTPOINT}${UEFI_MOUNT}/loader/entries/arch.conf
	  fi
	  
	  # Fix LVM Root installations, and deal with btrfs root subvolume mounting
	  [[ $LVM_ROOT -eq 1 ]] && sed -i "s/PARTUUID=//g" ${MOUNTPOINT}/boot/loader/entries/arch.conf
	  [[ $BTRFS_MNT != "" ]] && sed -i "s/rw/rw $BTRFS_MNT/g" ${MOUNTPOINT}/boot/loader/entries/arch.conf
	  
	  BOOTLOADER="systemd-boot"
	  # Set the loader file  
	  echo -e "default  arch\ntimeout  5" > ${MOUNTPOINT}${UEFI_MOUNT}/loader/loader.conf 2>/tmp/.errlog
	  check_for_error
	  wait
	  systemdboot_configuration
	  wait
	  clear
	  arch_chroot "bootctl update" 2>/tmp/.errlog
	  check_for_error
	  wait
}

bios_bootloader() { 
    
   dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_InstBiosBtTitle" \
    --menu "$_InstBiosBtBody" 0 0 3 \
    "1" $"Grub2" \
    "2" $"Syslinux [MBR]" \
    "3" $"Syslinux [/]" \
    "4" "$_Back" 2>${ANSWER}
    
    clear
    
    case $(cat ${ANSWER}) in
        "1") grub_bios_install
             ;;          
		"2"|"3") syslinux_bios_install
             ;;
          *) install_base_menu
             ;;
   esac
}

uefi_bootloader() {

	#Ensure again that efivarfs is mounted
	[[ -z $(mount | grep /sys/firmware/efi/efivars) ]] && mount -t efivarfs efivarfs /sys/firmware/efi/efivars
	
	if [[ "${_bootloader}" == "n/a" ]]; then
		dialog --default-item 1 --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_InstUefiBtTitle" \
		--menu "$_InstUefiBtBody" 0 0 3 \
		"1" "Grub2" \
		"2" "systemd-boot" \
		"3" "$_Back" 2>${ANSWER}

		case $(cat ${ANSWER}) in
			"1") grub_uefi_install
				;;
			"2") systemd_boot_uefi_install
				;;
			*) install_base_menu
				;;
		esac
	else
		case ${_bootloader} in
			"systemd-boot") systemd_boot_uefi_install
							;;
			"Grub") grub_uefi_install
					;;
		esac
	fi
}

# Adapted from AIS. Integrated the configuration elements.
install_bootloader() {

    check_mount
    # Set the default PATH variable
    arch_chroot "PATH=/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/core_perl" 2>/tmp/.errlog
    check_for_error
	
	if [[ "${_refind_setup_once}" == "0" ]]; then
		_refind_setup_once=1
		_refind_question=$(find ${MOUNTPOINT}/boot/efi/ -type f -iname "refind*" | grep -Ei "conf" | wc -l)
	fi
	
    if [[ $SYSTEM == "BIOS" ]]; then
       if [[ "${_multiple_system}" == "0" ]]; then
			bios_bootloader
			wait
       else
			grub_bios_install
			wait
       fi
    else
		if [[ "${UEFI_MOUNT}" == "" ]]; then
			dialog --default-item 2 --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_MntUefiTitle" --menu "$_MntUefiBody"  0 0 3 \
			   "1" "/boot" \
			   "2" "/boot/efi" \
			   "3" "$_Back" 2>${ANSWER}
			   
			   case $(cat ${ANSWER}) in
				"1") UEFI_MOUNT="/boot"
					_bootloader="n/a"
					 ;;
				"2") UEFI_MOUNT="/boot/efi"
					_bootloader="n/a"
					 ;;
				  *) _bootloader="n/a"
					install_base_menu
					 ;;
			   esac
		fi
		wait
		if [[ "${_multiple_system}" == "0" ]]; then
			uefi_bootloader
			wait
			refind_istallation_question
			wait
       else
			grub_uefi_install
			wait
			if [[ "${_refind_question[*]}" == "0" ]]; then
				dialog --defaultno --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_refind_yn_title" --yesno "rEFInd is not found.\n ${_InstUefiBtBody}${_refind_yn_body_else}" 0 0
				
				if [[ $? -eq 0 ]]; then
					if [[ "${UEFI_MOUNT}" == "/boot/efi" ]]; then
						refind_uefi_install
					else
						dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $_OptUefiTitle " --msgbox "${_UefiPartErrBody}${_RefiErrBody}" 0 0
					fi
				fi
			else
				dialog --defaultno --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_refind_yn_title" --yesno "rEFInd is found. $_refind_yn_body_full" 0 0
				 
				if [[ $? -eq 0 ]]; then
					if [[ "${UEFI_MOUNT}" == "/boot/efi" ]]; then
						refind_uefi_install
					else
						dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $_OptUefiTitle " --msgbox "${_UefiPartErrBody}${_RefiErrBody}" 0 0
					fi
				fi
			fi
       fi
    fi
}

