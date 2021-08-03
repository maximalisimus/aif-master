#!/bin/bash
#
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

    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_PartToolTitle" \
    --menu "$_PartToolBody" 0 0 6 \
    "1" $"Auto Partition (BIOS & UEFI)" \
    "2" $"Parted (BIOS & UEFI)" \
    "3" $"CFDisk (BIOS/MBR)" \
    "4" $"CGDisk (UEFI/GPT)" \
    "5" $"FDisk  (BIOS & UEFI)" \
    "6" $"GDisk  (UEFI/GPT)" 2>${ANSWER}    

    case $(cat ${ANSWER}) in
        "1") auto_partition
             ;;
        "2") clear
             parted ${DEVICE}
             ;;
        "3") cfdisk ${DEVICE}
             ;;
        "4") cgdisk ${DEVICE}
             ;;       
        "5") clear
             fdisk ${DEVICE}
             ;;
        "6") clear
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
    "12" $"xfs" 2>${ANSWER} 

    case $(cat ${ANSWER}) in
        "1") FILESYSTEM="skip"
             ;;
        "2") FILESYSTEM="mkfs.btrfs -f"
             modprobe btrfs
             
             dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_btrfsSVTitle" --yesno "$_btrfsSVBody" 0 0
             if [[ $? -eq 0 ]];then
                BTRFS=2
             else
                BTRFS=1
             fi
             
             ;;
        "3") FILESYSTEM="mkfs.ext2 -F"
             ;;
        "4") FILESYSTEM="mkfs.ext3 -F"
             ;;            
        "5") FILESYSTEM="mkfs.ext4 -F"
             CHK_NUM=8
             fs_opts="data=journal data=writeback dealloc discard noacl noatime nobarrier nodelalloc"
             ;;
        "6") FILESYSTEM="mkfs.f2fs"
             modprobe f2fs
             fs_opts="data_flush disable_roll_forward disable_ext_identify discard fastboot flush_merge inline_xattr inline_data inline_dentry no_heap noacl nobarrier noextent_cache noinline_data norecovery"
             CHK_NUM=16
             ;;
        "7") FILESYSTEM="mkfs.jfs -q"
             CHK_NUM=4
             fs_opts="discard errors=continue errors=panic nointegrity"
             ;;
        "8") FILESYSTEM="mkfs.nilfs2 -f"
             CHK_NUM=7
             fs_opts="discard nobarrier errors=continue errors=panic order=relaxed order=strict norecovery"
             ;;  
        "9") FILESYSTEM="mkfs.ntfs -q"
             ;;  
        "10") FILESYSTEM="mkfs.reiserfs -f -f"
             CHK_NUM=5
             fs_opts="acl nolog notail replayonly user_xattr"
             ;;  
       "11") FILESYSTEM="mkfs.vfat -F32"
             ;;  
       "12") FILESYSTEM="mkfs.xfs -f"
             CHK_NUM=9
             fs_opts="discard filestreams ikeep largeio noalign nobarrier norecovery noquota wsync"
             ;;      
          *) prep_menu
             ;;
    esac

  }

# Seperate subfunction for neatness.
mount_opts() {

    FS_OPTS=""
    echo "" > ${MOUNT_OPTS}
    
    for i in ${fs_opts}; do
        FS_OPTS="${FS_OPTS} ${i} - off"
    done

    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $(echo $FILESYSTEM | sed "s/.*\.//g" | sed "s/-.*//g") " --checklist "$_Mnt_Body" 0 0 $CHK_NUM \
    $FS_OPTS 2>${MOUNT_OPTS}
    
    # Now clean up the file
    sed -i 's/ /,/g' ${MOUNT_OPTS}
    sed -i '$s/,$//' ${MOUNT_OPTS}   
    
    # If mount options selected, confirm choice 
    if [[ $(cat ${MOUNT_OPTS}) != "" ]]; then
        dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $_Mnt_Status_Title " --yesno "\n${_Mnt_Conf_Body}$(cat ${MOUNT_OPTS})\n" 10 75
        [[ $? -eq 1 ]] && mount_opts
    fi 
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

# This function allows for btrfs-specific mounting options to be applied. Written as a seperate function
# for neatness.
btrfs_mount_opts() {

    echo "" > ${BTRFS_OPTS}

    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_btrfsMntTitle" --checklist "$_btrfsMntBody" 0 0 16 \
    "1" "autodefrag" off \
    "2" "compress=zlib" off \
    "3" "compress=lzo" off \
    "4" "compress=no" off \
    "5" "compress-force=zlib" off \
    "6" "compress-force=lzo" off \
    "7" "discard" off \
    "8" "noacl" off \
    "9" "noatime" off \
   "10" "nodatasum" off \
   "11" "nospace_cache" off \
   "12" "recovery" off \
   "13" "skip_balance" off \
   "14" "space_cache" off  \
   "15" "ssd" off \
   "16" "ssd_spread" off 2>${BTRFS_OPTS}
 
   # Double-digits first       
   sed -i 's/10/nodatasum,/' ${BTRFS_OPTS}
   sed -i 's/11/nospace_cache,/' ${BTRFS_OPTS}
   sed -i 's/12/recovery,/' ${BTRFS_OPTS}
   sed -i 's/13/skip_balance,/' ${BTRFS_OPTS}
   sed -i 's/14/space_cache,/' ${BTRFS_OPTS}
   sed -i 's/15/ssd,/' ${BTRFS_OPTS}
   sed -i 's/16/ssd_spread,/' ${BTRFS_OPTS}
   # then single digits
   sed -i 's/1/autodefrag,/' ${BTRFS_OPTS}
   sed -i 's/2/compress=zlib,/' ${BTRFS_OPTS}
   sed -i 's/3/compress=lzo,/' ${BTRFS_OPTS}
   sed -i 's/4/compress=no,/' ${BTRFS_OPTS}
   sed -i 's/5/compress-force=zlib,/' ${BTRFS_OPTS}
   sed -i 's/6/compress-force=lzo,/' ${BTRFS_OPTS}
   sed -i 's/7/noatime,/' ${BTRFS_OPTS}
   sed -i 's/8/noacl,/' ${BTRFS_OPTS}
   sed -i 's/9/noatime,/' ${BTRFS_OPTS}
   # Now clean up the file
   sed -i 's/ //g' ${BTRFS_OPTS}
   sed -i '$s/,$//' ${BTRFS_OPTS}

   
   if [[ $(cat ${BTRFS_OPTS}) != "" ]]; then
      dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_btrfsMntTitle" --yesno "$_btrfsMntConfBody $(cat $BTRFS_OPTS)\n" 0 0 
      [[ $? -eq 1 ]] && btrfs_mount_opts
   fi  

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
    [[ $BTRFS -eq 1 ]] && btrfs_mount_opts
    
    # If btrfs has been selected without subvolumes - and at least one btrfs mount option selected - then
    # mount with options. Otherwise, basic mount.
    if [[ $BTRFS -eq 1 ]] && [[ $(cat ${BTRFS_OPTS}) != "" ]]; then
       mount -o $(cat ${BTRFS_OPTS}) ${MOUNT_TYPE}${PARTITION} ${MOUNTPOINT} 2>>/tmp/.errlog
    else
        # BIOS
       # Get mounting options for appropriate filesystems
       [[ $fs_opts != "" ]] && mount_opts
       # Use special mounting options if selected, else standard mount
       if [[ $(cat ${MOUNT_OPTS}) != "" ]]; then
           mount -o $(cat ${MOUNT_OPTS}) ${MOUNT_TYPE}${PARTITION} ${MOUNTPOINT} 2>>/tmp/.errlog
       else
           mount ${MOUNT_TYPE}${PARTITION} ${MOUNTPOINT} 2>>/tmp/.errlog
       fi  
       # mount ${MOUNT_TYPE}${PARTITION} ${MOUNTPOINT} 2>>/tmp/.errlog
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
    
    # Extra Step for VFAT UEFI Partition. This cannot be in an LVM container.
    if [[ $SYSTEM == "UEFI" ]]; then
    
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
       dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_MntUefiTitle" --menu "$_MntUefiBody"  0 0 2 \
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
       
       mkdir -p ${MOUNTPOINT}${UEFI_MOUNT} 2>/tmp/.errlog
       # UEFI
        # Get mounting options for appropriate filesystems
        [[ $fs_opts != "" ]] && mount_opts
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
                [[ $BTRFS -eq 1 ]] && btrfs_mount_opts
    
                # If btrfs has been selected without subvolumes - and at least one btrfs mount option selected - then
                # mount with options. Otherwise, basic mount.
                if [[ $BTRFS -eq 1 ]] && [[ $(cat ${BTRFS_OPTS}) != "" ]]; then
                    mount -o $(cat ${BTRFS_OPTS}) ${MOUNT_TYPE}${PARTITION} ${MOUNTPOINT}${MOUNT} 2>>/tmp/.errlog
                else
                    # BIOS
                    # Get mounting options for appropriate filesystems
                    [[ $fs_opts != "" ]] && mount_opts
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
}
