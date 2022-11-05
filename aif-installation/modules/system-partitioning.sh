######################################################################
##                                                                  ##
##            System and Partitioning Functions                     ##
##                                                                  ##
######################################################################



# Unmount partitions.
umount_partitions(){
    
  MOUNTED=""
  MOUNTED=$(mount | grep "${MOUNTPOINT}" | awk '{print $3}' | sort -r)
  swapoff -a
  
  for i in ${MOUNTED[@]}; do
      umount $i >/dev/null 2>>/tmp/.errlog
  done
  
  check_for_error

}

# Adapted from AIS
confirm_mount() {
    if [[ $(mount | grep $1) ]]; then   
      dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_MntStatusTitle" --infobox "$_MntStatusSucc" 0 0
      sleep 2
      PARTITIONS="$(echo $PARTITIONS | sed s/${PARTITION}$' -'//)"
      NUMBER_PARTITIONS=$(( NUMBER_PARTITIONS - 1 ))
    else
      dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_MntStatusTitle" --infobox "$_MntStatusFail" 0 0
      sleep 2
      prep_menu
    fi
}

# btrfs specific for subvolumes
confirm_mount_btrfs() {
    if [[ $(mount | grep $1) ]]; then
      dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_MntStatusTitle" --infobox "$_MntStatusSucc\n$(cat ${BTRFS_OPTS})",subvol="${BTRFS_MSUB_VOL}\n\n" 0 0
      sleep 2
    else
      dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_MntStatusTitle" --infobox "$_MntStatusFail" 0 0
      sleep 2
      prep_menu
    fi
}

# Adapted from AIS. However, this does not assume that the formatted device is the Root
# installation device; more than one device may be formatted. This is now set in the
# mount_partitions function, when the Root is chosen.
select_device() {
    
    DEVICE=""
    devices_list=$(lsblk -d | awk '{print "/dev/" $1}' | grep 'sd\|hd\|vd\|nvme\|mmc');
    
    for i in ${devices_list[@]}; do
        DEVICE="${DEVICE} ${i} -"
    done
    
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_DevSelTitle" --menu "$_DevSelBody" 0 0 4 ${DEVICE} 2>${ANSWER} || prep_menu
    DEVICE=$(cat ${ANSWER})
 
  }

# Same as above, but goes to install_base_menu instead where cancelling, and otherwise installs Grub.
select_grub_device() {
    
    GRUB_DEVICE=""
    grub_devices_list=$(lsblk -d | awk '{print "/dev/" $1}' | grep 'sd\|hd\|vd');
    
    for i in ${grub_devices_list[@]}; do
        GRUB_DEVICE="${GRUB_DEVICE} ${i} -"
    done
    
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_DevSelGrubTitle" --menu "$_DevSelBody" 0 0 4 ${GRUB_DEVICE} 2>${ANSWER} || install_base_menu
    GRUB_DEVICE=$(cat ${ANSWER})
    clear
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " Grub-install " --infobox "$_PlsWaitBody" 0 0
    sleep 1
    arch_chroot "grub-install --target=i386-pc --recheck ${GRUB_DEVICE}" 2>/tmp/.errlog
    check_for_error
 
  }

# Originally adapted from AIS.
create_partitions(){

# This only creates the minimum number of partition(s) necessary. Users wishing for other schemes will
# have to learn to use a partitioning application.
auto_partition(){

# Hooray for tac! Deleting partitions in reverse order deals with logical partitions easily.
delete_partitions(){
    
    parted -s ${DEVICE} print | awk '/^ / {print $1}' > /tmp/.del_parts
    
    for del_part in $(tac /tmp/.del_parts); do
        parted -s ${DEVICE} rm ${del_part} 2>/tmp/.errlog
        check_for_error
    done


}
 
 # Identify the partition table
 part_table=$(parted -s ${DEVICE} print | grep -i 'partition table' | awk '{print $3}')

 # Autopartition for BIOS systems 
 if [[ $SYSTEM == "BIOS" ]]; then
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " Auto-Partition (BIOS/MBR) " --yesno "$_AutoPartBody1 $DEVICE $_AutoPartBIOSBody2" 0 0
    
    if [[ $? -eq 0 ]]; then
        delete_partitions
        if [[ $part_table != "msdos" ]]; then
           parted -s ${DEVICE} mklabel msdos 2>/tmp/.errlog
           check_for_error
        fi
        parted -s ${DEVICE} mkpart primary ext3 1MiB 100% 2>/tmp/.errlog    
        parted -s ${DEVICE} set 1 boot on 2>>/tmp/.errlog
        check_for_error
        echo -e "Partition Scheme:\n" > /tmp/.devlist
        lsblk ${DEVICE} -o NAME,TYPE,FSTYPE,SIZE > /tmp/.devlist
        dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "" --textbox /tmp/.devlist 0 0
    else
        create_partitions
    fi
 
 # Autopartition for UEFI systems   
 else
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " Auto-Partition (UEFI/GPT) " --yesno "$_AutoPartBody1 $DEVICE $_AutoPartUEFIBody2" 0 0
    
    if [[ $? -eq 0 ]]; then
        delete_partitions
        if [[ $part_table != "gpt" ]]; then
           parted -s ${DEVICE} mklabel gpt 2>/tmp/.errlog
           check_for_error
        fi
        parted -s ${DEVICE} mkpart ESP fat32 1MiB 513MiB 2>/tmp/.errlog
        parted -s ${DEVICE} set 1 boot on 2>>/tmp/.errlog
        parted -s ${DEVICE} mkpart primary ext3 513MiB 100% 2>>/tmp/.errlog
        echo -e "Partition Scheme:\n" > /tmp/.devlist
        lsblk ${DEVICE} -o NAME,TYPE,FSTYPE,SIZE >> /tmp/.devlist
        dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "" --textbox /tmp/.devlist 0 0
    else
        create_partitions
    fi
    
 fi

}

	if [[ "${SYSTEM}" == "BIOS" ]]; then
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_PartToolTitle" \
		--menu "$_PartToolBody" 0 0 6 \
		"auto" $"Auto Partition (BIOS)" \
		"parted" $"Parted (BIOS)" \
		"cfdisk" $"CFDisk (BIOS/MBR)" \
		"fdisk" $"FDisk  (BIOS)" \
		"back" "$_Back" 2>${ANSWER}
	else
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_PartToolTitle" \
		--menu "$_PartToolBody" 0 0 6 \
		"auto" $"Auto Partition (UEFI)" \
		"parted" $"Parted (UEFI)" \
		"cgdisk" $"CGDisk (UEFI/GPT)" \
		"fdisk" $"FDisk  (UEFI)" \
		"gdisk" $"GDisk  (UEFI/GPT)" \
		"back" "$_Back" 2>${ANSWER}
	fi

	case $(cat ${ANSWER}) in
		"auto") auto_partition
				;;
		"parted") clear
				parted ${DEVICE}
				;;
		"cfdisk") cfdisk ${DEVICE}
				;;
		"cgdisk") cgdisk ${DEVICE}
				;;       
		"fdisk") clear
				fdisk ${DEVICE}
				;;
		"gdisk") clear
				gdisk ${DEVICE}
				;;
		*) prep_menu
			;;
	esac    
}   

# find all available partitions and generate a list of them
# This also includes partitions on different devices.
find_partitions() {

    PARTITIONS=""
    NUMBER_PARTITIONS=0
    partition_list=$(lsblk -l | grep 'part\|lvm' | sed 's/[\t ].*//' | sort -u)
    
    for i in ${partition_list[@]}; do
        PARTITIONS="${PARTITIONS} ${i} -"
        NUMBER_PARTITIONS=$(( NUMBER_PARTITIONS + 1 ))
    done
    
    # Deal with incorrect partitioning
    if [[ $NUMBER_PARTITIONS -lt 2 ]] && [[ $SYSTEM == "UEFI" ]]; then
        dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_UefiPartErrTitle" --msgbox "$_UefiPartErrBody" 0 0
        create_partitions
    fi
    
    if [[ $NUMBER_PARTITIONS -eq 0 ]] && [[ $SYSTEM == "BIOS" ]]; then
        dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_BiosPartErrTitle" --msgbox "$_BiosPartErrBody" 0 0  
        create_partitions
    fi
}

# Set static list of filesystems rather than on-the-fly. Partially as most require additional flags, and 
# partially because some don't seem to be viable.
select_filesystem(){

# Clear special FS type flags
BTRFS=0

dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_FSTitle" \
    --menu "$_FSBody" 0 0 12 \
    "1" "$_FSSkip" \
    "2" $"btrfs" \
    "3" $"ext2" \
    "4" $"ext3" \
    "5" $"ext4" \
    "6" $"f2fs" \
    "7" $"jfs" \
    "8" $"nilfs2" \
    "9" $"ntfs" \
    "10" $"reiserfs" \
    "11" $"vfat" \
    "12" $"xfs" \
    "13" "$_Back" 2>${ANSWER} 

    case $(cat ${ANSWER}) in
        "1") FILESYSTEM="skip"
			_filesystem="skip"
			_mount_opts_run=0
             ;;
        "2") FILESYSTEM="mkfs.btrfs -f"
			 _filesystem="btrfs"
             modprobe btrfs
             _mount_opts_run=1
             dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_btrfsSVTitle" --yesno "$_btrfsSVBody" 0 0
             if [[ $? -eq 0 ]];then
                BTRFS=2
             else
                BTRFS=1
             fi
             ;;
        "3") FILESYSTEM="mkfs.ext2 -F"
			_filesystem="ext2"
			 _mount_opts_run=1
             ;;
        "4") FILESYSTEM="mkfs.ext3 -F"
			 _filesystem="ext3"
			 _mount_opts_run=1
             ;;            
        "5") FILESYSTEM="mkfs.ext4 -F"
			 _filesystem="ext4"
			 _mount_opts_run=1
             ;;
        "6") FILESYSTEM="mkfs.f2fs"
			 _filesystem="f2fs"
             modprobe f2fs
             _mount_opts_run=1
             ;;
        "7") FILESYSTEM="mkfs.jfs -q"
			 _filesystem="jfs"
			 _mount_opts_run=1
             ;;
        "8") FILESYSTEM="mkfs.nilfs2 -f"
			 _filesystem="nilfs2"
			 _mount_opts_run=1
             ;;  
        "9") FILESYSTEM="mkfs.ntfs -q"
			 _filesystem="ntfs"
			 _mount_opts_run=0
             ;;  
        "10") FILESYSTEM="mkfs.reiserfs -f -f"
			 _filesystem="reiserfs"
			 _mount_opts_run=1
             ;;  
       "11") FILESYSTEM="mkfs.vfat -F32"
			 _filesystem="vfat"
			 _mount_opts_run=1
             ;;  
       "12") FILESYSTEM="mkfs.xfs -f"
			 _filesystem="xfs"
			 _mount_opts_run=1
             ;; 
          *) prep_menu
             ;;
    esac

  }

# Seperate subfunction for neatness.
mount_opts() {
	
	echo "" > ${MOUNT_OPTS}
	case ${_filesystem} in
		"skip") clear
					echo -e -n "\n\nSkip mount options ...\n"
					sleep 2
				;;
		"ntfs") clear
					echo -e -n "\n\NTFS not mount options ...\n"
					sleep 2
				;;
		"btrfs") btrfs_mounted_options
			;;
		"ext2") ext2_mounted_options
			;;
		"ext3") ext3_mounted_options
			;;
		"ext4") ext4_mounted_options
			;;
		"f2fs") f2fs_mounted_options
			;;
		"jfs") jfs_mounted_options
				;;
		"nilfs2") nilfs2_mounted_options
				;;
		"reiserfs") reiserfs_mounted_options
					;;
		"vfat") vfat_mounted_options
				;;
		"xfs") xfs_mounted_options
				;;
	esac
}

mount_partitions() {

# function created to save repetition of code. Checks and determines if standard partition or LVM LV,
# and sets the prefix accordingly.
set_mount_type() {

[[ $(echo ${PARTITION} | grep 'sd\|hd\|vd[a-z][1-99]') != "" ]] && MOUNT_TYPE="/dev/" || MOUNT_TYPE="/dev/mapper/"
    
}

btrfs_subvols() {

 BTRFS_MSUB_VOL=""
 BTRFS_OSUB_VOL=""
 BTRFS_MNT=""
 BTRFS_VOL_LIST="/tmp/.vols"
 echo "" > ${BTRFS_VOL_LIST}
 BTRFS_OSUB_NUM=1
 
 dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_btrfsSVTitle" --inputbox "$_btrfsMSubBody1 ${MOUNTPOINT}${MOUNT} $_btrfsMSubBody2" 0 0 "" 2>${ANSWER} || select_filesystem
 BTRFS_MSUB_VOL=$(cat ${ANSWER})
 # if root, then create boot flag for syslinux, systemd-boot and rEFInd bootloaders 
 [[ ${MOUNT} == "" ]] && BTRFS_MNT="rootflags=subvol="$BTRFS_MSUB_VOL

 # Loop while subvolume is blank or has spaces.
 while [[ ${#BTRFS_MSUB_VOL} -eq 0 ]] || [[ $BTRFS_MSUB_VOL =~ \ |\' ]]; do
       dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_btrfsSVErrTitle" --inputbox "$_btrfsSVErrBody" 0 0 "" 2>${ANSWER} || select_filesystem
       BTRFS_MSUB_VOL=$(cat ${ANSWER})
       # if root, then create flag for syslinux, systemd-boot and rEFInd bootloaders
       [[ ${MOUNT} == "" ]] && BTRFS_MNT="rootflags=subvol="$BTRFS_MSUB_VOL
 done
 
 # change dir depending on whether root partition or not
 [[ ${MOUNT} == "" ]] && cd ${MOUNTPOINT} || cd ${MOUNTPOINT}${MOUNT} 2>/tmp/.errlog
 btrfs subvolume create ${BTRFS_MSUB_VOL} 2>>/tmp/.errlog
 cd
 umount ${MOUNT_TYPE}${PARTITION} 2>>/tmp/.errlog
 check_for_error
 
 # Get any mount options and mount
 btrfs_mount_opts
 if [[ $(cat ${BTRFS_OPTS}) != "" ]]; then
    [[ ${MOUNT} == "" ]] && mount -o $(cat ${BTRFS_OPTS})",subvol="${BTRFS_MSUB_VOL} ${MOUNT_TYPE}${PARTITION} ${MOUNTPOINT} 2>/tmp/.errlog || mount -o $(cat ${BTRFS_OPTS})",subvol="${BTRFS_MSUB_VOL} ${MOUNT_TYPE}${PARTITION} ${MOUNTPOINT}${MOUNT} 2>/tmp/.errlog
 else
    [[ ${MOUNT} == "" ]] && mount -o "subvol="${BTRFS_MSUB_VOL} ${MOUNT_TYPE}${PARTITION} ${MOUNTPOINT} 2>/tmp/.errlog || mount -o "subvol="${BTRFS_MSUB_VOL} ${MOUNT_TYPE}${PARTITION} ${MOUNTPOINT}${MOUNT} 2>/tmp/.errlog
 fi
 
 # Check for error and confirm successful mount
 check_for_error  
 [[ ${MOUNT} == "" ]] && confirm_mount_btrfs ${MOUNTPOINT} || confirm_mount_btrfs ${MOUNTPOINT}${MOUNT}
 
 # Now create the subvolumes   
 [[ ${MOUNT} == "" ]] && cd ${MOUNTPOINT} || cd ${MOUNTPOINT}${MOUNT} 2>/tmp/.errlog
 check_for_error
 
 # Loop while the termination character has not been entered
 while [[ $BTRFS_OSUB_VOL != "*" ]]; do
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_btrfsSVTitle ($BTRFS_MSUB_VOL) " --inputbox "$_btrfsSVBody1 $BTRFS_OSUB_NUM $_btrfsSVBody2 $BTRFS_MSUB_VOL.$_btrfsSVBody3 $(cat ${BTRFS_VOL_LIST})" 0 0 "" 2>${ANSWER} || select_filesystem
    BTRFS_OSUB_VOL=$(cat ${ANSWER}) 

    # Loop while subvolume is blank or has spaces.
    while [[ ${#BTRFS_OSUB_VOL} -eq 0 ]] || [[ $BTRFS_SUB_VOL =~ \ |\' ]]; do
       dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_btrfsSVErrTitle ($BTRFS_MSUB_VOL) " --inputbox "$_btrfsSVErrBody ($BTRFS_OSUB_NUM)." 0 0 "" 2>${ANSWER} || select_filesystem
       BTRFS_OSUB_VOL=$(cat ${ANSWER})
    done
 
    btrfs subvolume create ${BTRFS_OSUB_VOL} 2>/tmp/.errlog 
    check_for_error
    BTRFS_OSUB_NUM=$(( BTRFS_OSUB_NUM + 1 ))
    echo $BTRFS_OSUB_VOL" " >> ${BTRFS_VOL_LIST}
 done
 
 # Show the subvolumes created
 echo -e "btrfs subvols:\n" > /tmp/.subvols
 ls  >> /tmp/.subvols
 dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --textbox /tmp/.subvols 0 0
 cd
}

    # LVM Detection. If detected, activate.
    detect_lvm
    if [[ $LVM -eq 1 ]]; then
       dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_LvmDetTitle" --infobox "$_LvmDetBody2" 0 0
       sleep 2   
       modprobe dm-mod 2>/tmp/.errlog
       check_for_error
       vgscan >/dev/null 2>&1
       vgchange -ay >/dev/null 2>&1
    fi

    # Ensure partitions are unmounted (i.e. where mounted previously), and then list available partitions
    umount_partitions
    find_partitions
    
    # Identify and mount root
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_SelRootTitle" --menu "$_SelRootBody" 0 0 4 ${PARTITIONS} 2>${ANSWER} || prep_menu
    PARTITION=$(cat ${ANSWER})
    ROOT_PART=${PARTITION}
    set_mount_type
    
    # This is to identify the device for Grub installations.
    if [[ $MOUNT_TYPE == "/dev/" ]]; then   
       LVM_ROOT=0
       INST_DEV=${MOUNT_TYPE}$(cat ${ANSWER} | sed 's/[0-9]*//g')
    else
       LVM_ROOT=1
    fi
        
    select_filesystem
    [[ $FILESYSTEM != "skip" ]] && ${FILESYSTEM} ${MOUNT_TYPE}${PARTITION} >/dev/null 2>/tmp/.errlog
    check_for_error
    
    # Make the root directory
    mkdir -p ${MOUNTPOINT} 2>/tmp/.errlog

    # If btrfs without subvolumes has been selected, get the mount options
    [[ $BTRFS -eq 1 ]] && mount_opts
    
    # If btrfs has been selected without subvolumes - and at least one btrfs mount option selected - then
    # mount with options. Otherwise, basic mount.
    if [[ $BTRFS -eq 1 ]] && [[ $(cat ${BTRFS_OPTS}) != "" ]]; then
       mount -o $(cat ${BTRFS_OPTS}) ${MOUNT_TYPE}${PARTITION} ${MOUNTPOINT} 2>>/tmp/.errlog
    else
        # BIOS
       # Get mounting options for appropriate filesystems
       [[ "${_mount_opts_run}" == "1" ]] && mount_opts
       # Use special mounting options if selected, else standard mount
       if [[ $(cat ${MOUNT_OPTS}) != "" ]]; then
           mount -o $(cat ${MOUNT_OPTS}) ${MOUNT_TYPE}${PARTITION} ${MOUNTPOINT} 2>>/tmp/.errlog
       else
           mount ${MOUNT_TYPE}${PARTITION} ${MOUNTPOINT} 2>>/tmp/.errlog
       fi
    fi
      
    # Check for error, confirm mount, and deal with BTRFS with subvolumes if applicable  
    check_for_error
    confirm_mount ${MOUNTPOINT}
    [[ $BTRFS -eq 2 ]] && btrfs_subvols
    
    # Identify and create swap, if applicable
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_SelSwpTitle" --menu "$_SelSwpBody" 0 0 4 "$_SelSwpNone" $"-" "$_SelSwpFile" $"-" ${PARTITIONS} 2>${ANSWER} || prep_menu  
    if [[ $(cat ${ANSWER}) != "$_SelSwpNone" ]]; then    
       PARTITION=$(cat ${ANSWER})
       
       if [[ $PARTITION == "$_SelSwpFile" ]]; then
          total_memory=`grep MemTotal /proc/meminfo | awk '{print $2/1024}' | sed 's/\..*//'`
          fallocate -l ${total_memory}M ${MOUNTPOINT}/swapfile >/dev/null 2>/tmp/.errlog
          check_for_error
          chmod 600 ${MOUNTPOINT}/swapfile >/dev/null 2>&1
          mkswap ${MOUNTPOINT}/swapfile >/dev/null 2>&1
          swapon ${MOUNTPOINT}/swapfile >/dev/null 2>&1
       else
          set_mount_type
          # Only create a swap if not already in place
          [[ $(lsblk -o FSTYPE  ${MOUNT_TYPE}${PARTITION} | grep -i "swap") != "swap" ]] &&  mkswap  ${MOUNT_TYPE}${PARTITION} >/dev/null 2>/tmp/.errlog
          swapon  ${MOUNT_TYPE}${PARTITION} >/dev/null 2>>/tmp/.errlog
          check_for_error
          # Since a partition was used, remove that partition from the list
          PARTITIONS="$(echo $PARTITIONS | sed s/${PARTITION}$' -'//)"
          NUMBER_PARTITIONS=$(( NUMBER_PARTITIONS - 1 ))
       fi
    fi
    
    # All other partitions
       while [[ $NUMBER_PARTITIONS > 0 ]]; do 
             dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_ExtPartTitle" --menu "$_ExtPartBody" 0 0 4 "$_Done" $"-" ${PARTITIONS} 2>${ANSWER} || config_base_menu 
             PARTITION=$(cat ${ANSWER})
             set_mount_type
             
             if [[ $PARTITION == ${_Done} ]]; then
                break;
             else
                MOUNT=""
                
                select_filesystem 
                [[ $FILESYSTEM != "skip" ]] && ${FILESYSTEM} ${MOUNT_TYPE}${PARTITION} >/dev/null 2>/tmp/.errlog
                check_for_error
                
                # Don't give /boot as an example for UEFI systems!
                if [[ $SYSTEM == "UEFI" ]]; then
                   dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_ExtNameTitle $PARTITON " --inputbox "$_ExtNameBodyUefi" 0 0 "/" 2>${ANSWER} || config_base_menu
                else
                   dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_ExtNameTitle $PARTITON " --inputbox "$_ExtNameBodyBios" 0 0 "/" 2>${ANSWER} || config_base_menu
                fi
                MOUNT=$(cat ${ANSWER})
                
                # loop if the mountpoint specified is incorrect (is only '/', is blank, or has spaces). 
                while [[ ${MOUNT:0:1} != "/" ]] || [[ ${#MOUNT} -le 1 ]] || [[ $MOUNT =~ \ |\' ]]; do
                      dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_ExtErrTitle" --msgbox "$_ExtErrBody" 0 0
                      
                      # Don't give /boot as an example for UEFI systems!
                      if [[ $SYSTEM == "UEFI" ]]; then
                         dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_ExtNameTitle $PARTITON " --inputbox "$_ExtNameBodyUefi" 0 0 "/" 2>${ANSWER} || config_base_menu
                      else
                         dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_ExtNameTitle $PARTITON " --inputbox "$_ExtNameBodyBios" 0 0 "/" 2>${ANSWER} || config_base_menu
                      fi
                      MOUNT=$(cat ${ANSWER})                     
                done

                # Create directory and mount. This step will only be reached where the loop has been skipped or broken.
                mkdir -p ${MOUNTPOINT}${MOUNT} 2>/tmp/.errlog
                
                # If btrfs without subvolumes has been selected, get the mount options
                [[ $BTRFS -eq 1 ]] && mount_opts
    
                # If btrfs has been selected without subvolumes - and at least one btrfs mount option selected - then
                # mount with options. Otherwise, basic mount.
                if [[ $BTRFS -eq 1 ]] && [[ $(cat ${BTRFS_OPTS}) != "" ]]; then
                    mount -o $(cat ${BTRFS_OPTS}) ${MOUNT_TYPE}${PARTITION} ${MOUNTPOINT}${MOUNT} 2>>/tmp/.errlog
                else
                    # BIOS
                    # Get mounting options for appropriate filesystems
                    [[ "${_mount_opts_run}" == "1" ]] && mount_opts
                    # Use special mounting options if selected, else standard mount
                    if [[ $(cat ${MOUNT_OPTS}) != "" ]]; then
                        mount -o $(cat ${MOUNT_OPTS}) ${MOUNT_TYPE}${PARTITION} ${MOUNTPOINT}${MOUNT} 2>>/tmp/.errlog
                    else
                        mount ${MOUNT_TYPE}${PARTITION} ${MOUNTPOINT}${MOUNT} 2>>/tmp/.errlog
                    fi  
                    # mount ${MOUNT_TYPE}${PARTITION} ${MOUNTPOINT}${MOUNT} 2>>/tmp/.errlog
                fi
      
                # Check for error, confirm mount, and deal with BTRFS with subvolumes if applicable  
                check_for_error
                confirm_mount ${MOUNTPOINT}${MOUNT}
                [[ $BTRFS -eq 2 ]] && btrfs_subvols
                
                # Determine if a seperate /boot is used, and if it is LVM or not
                LVM_SEP_BOOT=0
                if [[ $MOUNT == "/boot" ]]; then
                   [[ $MOUNT_TYPE == "/dev/" ]] && LVM_SEP_BOOT=1 || LVM_SEP_BOOT=2
                fi                   
             fi
       done
       
    # Extra Step for VFAT UEFI Partition. This cannot be in an LVM container.
    if [[ $SYSTEM == "UEFI" ]]; then
       _filesystem="vfat"
       _mount_opts_run=1
       wait
       dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_SelUefiTitle" --menu "$_SelUefiBody" 0 0 4 ${PARTITIONS} 2>${ANSWER} || config_base_menu  
       PARTITION=$(cat ${ANSWER})
       UEFI_PART=$"/dev/"${PARTITION}
       
       # If it is already a fat/vfat partition...
       if [[ $(fsck -N /dev/$PARTITION | grep fat) ]]; then
          dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_FormUefiTitle" --yesno "$_FormUefiBody $PARTITION $_FormUefiBody2" 0 0 && mkfs.vfat -F32 $"/dev/"${PARTITION} >/dev/null 2>/tmp/.errlog
       else 
          mkfs.vfat -F32 $"/dev/"${PARTITION} >/dev/null 2>/tmp/.errlog
       fi
       check_for_error
       
       # Inform users of the mountpoint options and consequences
       if [[ "${_multiple_system}" == "1" ]]; then
			UEFI_MOUNT="/boot/efi"
       else
			dialog --default-item 2 --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_MntUefiTitle" --menu "$_MntUefiBody"  0 0 2 \
			   "1" $"/boot" \
			   "2" $"/boot/efi" 2>${ANSWER}
			   
			   case $(cat ${ANSWER}) in
				"1") UEFI_MOUNT="/boot"
					 ;;
				"2") UEFI_MOUNT="/boot/efi"
					 ;;
				  *) config_base_menu
					 ;;
			   esac
       fi
       
       mkdir -p ${MOUNTPOINT}${UEFI_MOUNT} 2>/tmp/.errlog
       # UEFI
        # Get mounting options for appropriate filesystems
        [[ "${_mount_opts_run}" == "1" ]] && mount_opts
        # Use special mounting options if selected, else standard mount
        if [[ $(cat ${MOUNT_OPTS}) != "" ]]; then
            mount -o $(cat ${MOUNT_OPTS}) $"/dev/"${PARTITION} ${MOUNTPOINT}${UEFI_MOUNT} 2>>/tmp/.errlog
        else
            mount $"/dev/"${PARTITION} ${MOUNTPOINT}${UEFI_MOUNT} 2>>/tmp/.errlog
        fi
       # mount $"/dev/"${PARTITION} ${MOUNTPOINT}${UEFI_MOUNT} 2>>/tmp/.errlog
       check_for_error
       confirm_mount ${MOUNTPOINT}${UEFI_MOUNT}     
       
    fi
}
