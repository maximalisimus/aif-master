######################################################################
##                                                                  ##
##             Logical Volume Management Functions                  ##
##                                                                  ##
######################################################################


# LVM Detection.
detect_lvm() {

  LVM_PV=$(pvs -o pv_name --noheading 2>/dev/null)
  LVM_VG=$(vgs -o vg_name --noheading 2>/dev/null)
  LVM_LV=$(lvs -o vg_name,lv_name --noheading --separator - 2>/dev/null)
  
  if [[ $LVM_LV = "" ]] && [[ $LVM_VG = "" ]] && [[ $LVM_PV = "" ]]; then
     LVM=0
  else
     LVM=1
  fi
 
}

# Where existing LVM is found, offer to deactivate it. Code adapted from the Manjaro installer.
# NEED TO ADD COMMAND TO REMOVE LVM2 FSTYPE.
deactivate_lvm() {

 LVM_DISABLE=0

    if [[ $LVM -eq 1 ]]; then
       dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_LvmDetTitle" --yesno "$_LvmDetBody1" 0 0 \
       && LVM_DISABLE=1 || LVM_DISABLE=0
    fi
    
    if [[ $LVM_DISABLE -eq 1 ]]; then
       dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_LvmRmTitle" --infobox "$_LvmRmBody" 0 0
       sleep 2
       
        for i in ${LVM_LV}; do
            lvremove -f /dev/mapper/${i} >/dev/null 2>&1
        done

        for i in ${LVM_VG}; do
            vgremove -f ${i} >/dev/null 2>&1
        done

        for i in ${LV_PV}; do
            pvremove -f ${i} >/dev/null 2>&1
        done
        
        # This step will remove old lvm metadata on partitions where identified.
        LVM_PT=$(lvmdiskscan | grep 'LVM physical volume' | grep 'sd[a-z]' | sed 's/\/dev\///' | awk '{print $1}')
        for i in ${LVM_PT}; do
            dd if=/dev/zero bs=512 count=512 of=/dev/${i} >/dev/null 2>&1
        done
    fi

}

# Find and create a list of partitions that can be used for LVM. Partitions already used are excluded.
find_lvm_partitions() {

    LVM_PARTITIONS=""
    NUMBER_LVM_PARTITIONS=0
    lvm_partition_list=$(lvmdiskscan | grep -v 'LVM physical volume' | grep 'sd[a-z][1-99]' | sed 's/\/dev\///' | awk '{print $1}')
    
    for i in ${lvm_partition_list[@]}; do
        LVM_PARTITIONS="${LVM_PARTITIONS} ${i} -"
        NUMBER_LVM_PARTITIONS=$(( NUMBER_LVM_PARTITIONS + 1 ))
    done
    
}

# This simplifies the creation of the PV and VG into a single step.
create_lvm() {

# subroutine to save a lot of repetition.
check_lv_size() {

  LV_SIZE_INVALID=0
  LV_SIZE_TYPE=$(echo ${LVM_LV_SIZE:$(( ${#LVM_LV_SIZE} - 1 )):1})
  chars=0
  
  # Check to see if anything was actually entered
  [[ ${#LVM_LV_SIZE} -eq 0 ]] && LV_SIZE_INVALID=1

  # Check if there are any non-numeric characters prior to the last one
  while [[ $chars -lt $(( ${#LVM_LV_SIZE} - 1 )) ]]; do
        if [[ ${LVM_LV_SIZE:chars:1} != [0-9] ]]; then
           LV_SIZE_INVALID=1
           break;
        fi
        chars=$(( chars + 1 ))
  done

  # Check to see if first character is '0'
  [[ ${LVM_LV_SIZE:0:1} -eq "0" ]] && LV_SIZE_INVALID=1

  # Check to see if last character is "G" or "M", and if so, whether the value is greater than
  # or equal to the LV remaining Size. If not, convert into MB for VG space remaining.      
  if [[ ${LV_SIZE_INVALID} -eq 0 ]]; then
      case ${LV_SIZE_TYPE} in
         "G") if [[ $(( $(echo ${LVM_LV_SIZE:0:$(( ${#LVM_LV_SIZE} - 1 ))}) * 1000 )) -ge ${LVM_VG_MB} ]]; then
                 LV_SIZE_INVALID=1
              else
                 LVM_VG_MB=$(( LVM_VG_MB - $(( $(echo ${LVM_LV_SIZE:0:$(( ${#LVM_LV_SIZE} - 1 ))}) * 1000 )) ))
              fi
              ;;
         "M") if [[ $(echo ${LVM_LV_SIZE:0:$(( ${#LVM_LV_SIZE} - 1 ))}) -ge ${LVM_VG_MB} ]]; then
                 LV_SIZE_INVALID=1
              else
                 LVM_VG_MB=$(( LVM_VG_MB - $(echo ${LVM_LV_SIZE:0:$(( ${#LVM_LV_SIZE} - 1 ))}) ))
              fi
              ;;
           *) LV_SIZE_INVALID=1
              ;;
      esac
  fi
      
}

    # Check that there is at least one partition available for LVM
    if [[ $NUMBER_LVM_PARTITIONS -lt 1 ]]; then
        dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_LvmPartErrTitle" --msgbox "$_LvmPartErrBody" 0 0
        prep_menu
    fi
    
    # Create a temporary file to store the partition(s) selected. This is later used for the vgcreate command. 'x' is used as a marker.
    echo "x" > /tmp/.vgcreate
    
    # Name the Volume Group
    LVM_VG=""
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_LvmNameVgTitle" --inputbox "$_LvmNameVgBody" 0 0 "" 2>${ANSWER} || prep_menu
    LVM_VG=$(cat ${ANSWER})

    # Loop while the Volume Group name starts with a "/", is blank, has spaces, or is already being used
    while [[ ${LVM_VG:0:1} == "/" ]] || [[ ${#LVM_VG} -eq 0 ]] || [[ $LVM_VG =~ \ |\' ]] || [[ $(lsblk | grep ${LVM_VG}) != "" ]]; do
        dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_LvmNameVgErrTitle" --msgbox "$_LvmNameVgErr" 0 0
              
        dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_LvmNameVgTitle" --inputbox "$_LvmNameVgBody" 0 0 "" 2>${ANSWER} || prep_menu
        LVM_VG=$(cat ${ANSWER})
    done
    
    # Select the first or only partition for the Volume Group
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_LvmPvSelTitle" --menu "$_LvmPvSelBody" 0 0 4 ${LVM_PARTITIONS} 2>${ANSWER} || prep_menu 
    LVM_PARTITION=$(cat ${ANSWER})
    
    # add the partition to the temporary file for the vgcreate command
    # Remove selected partition from the list and deduct number of LVM viable partitions remaining
    sed -i "s/x/\/dev\/${LVM_PARTITION} x/" /tmp/.vgcreate
    LVM_PARTITIONS="$(echo $LVM_PARTITIONS | sed s/${LVM_PARTITION}$' -'//)"
    NUMBER_LVM_PARTITIONS=$(( NUMBER_LVM_PARTITIONS - 1 ))
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_LvmPvCreateTitle" --infobox "\n$_Done\n\n" 0 0
    sleep 1

    # Where there are viable partitions still remaining, run loop
    while [[ $NUMBER_LVM_PARTITIONS -gt 0 ]]; do

           dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_LvmPvSelTitle" --menu "$_LvmPvSelBody" 0 0 4 $"Done" $"-" ${LVM_PARTITIONS} 2>${ANSWER} || prep_menu 
           LVM_PARTITION=$(cat ${ANSWER})

           if [[ $LVM_PARTITION == "Done" ]]; then
              break;
           else
              sed -i "s/x/\/dev\/${LVM_PARTITION} x/" /tmp/.vgcreate
              LVM_PARTITIONS="$(echo $LVM_PARTITIONS | sed s/${LVM_PARTITION}$' -'//)"
              NUMBER_LVM_PARTITIONS=$(( NUMBER_LVM_PARTITIONS - 1 ))
              dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_LvmPvCreateTitle" --infobox "\n$_Done\n\n" 0 0
              sleep 1
           fi

    done

    # Once all the partitions have been selected, remove 'x' from the .vgcreate file, then use it in 'vgcreate' command.
    # Also determine the size of the VG, to use for creating LVs for it.
    VG_PARTS=$(cat /tmp/.vgcreate | sed 's/x//')
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_LvmPvConfTitle" --yesno "$_LvmPvConfBody1${LVM_VG} $_LvmPvConfBody2${VG_PARTS}" 0 0
    
    if [[ $? -eq 0 ]]; then
       dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_LvmPvActTitle" --infobox "$_LvmPvActBody1${LVM_VG}.$_LvmPvActBody2" 0 0
       sleep 2
       vgcreate -f ${LVM_VG} ${VG_PARTS} >/dev/null 2>/tmp/.errlog
       check_for_error
       VG_SIZE=$(vgdisplay | grep 'VG Size' | awk '{print $3}' | sed 's/\..*//')
       VG_SIZE_TYPE=$(vgdisplay | grep 'VG Size' | awk '{print $4}' | sed 's/\..*//')
       dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_LvmPvDoneTitle" --msgbox "$_LvmPvDoneBody1 '${LVM_VG}' $_LvmPvDoneBody2 (${VG_SIZE} ${VG_SIZE_TYPE}).\n\n" 0 0
       sleep 2
    else
       prep_menu
    fi

    # Convert the VG size into GB and MB. These variables are used to keep tabs on space available and remaining
    [[ ${VG_SIZE_TYPE:0:1} == "G" ]] && LVM_VG_MB=$(( VG_SIZE * 1000 )) || LVM_VG_MB=$VG_SIZE
    
    # Specify number of Logical volumes to create.
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_LvmLvNumTitle" --inputbox "$_LvmLvNumBody1 ${LVM_VG}.$_LvmLvNumBody2" 0 0 "" 2>${ANSWER} || prep_menu
    NUMBER_LOGICAL_VOLUMES=$(cat ${ANSWER})
    
    # Loop if the number of LVs is no 1-9 (including non-valid characters)
    while [[ $NUMBER_LOGICAL_VOLUMES != [1-9] ]]; do
          dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_LvmLvNumErrTitle" --msgbox "$_LvmLvNumErrBody" 0 0
 
          dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_LvmLvNumTitle" --inputbox "$_LvmLvNumBody1 ${LVM_VG}.$_LvmLvNumBody2" 0 0 "" 2>${ANSWER} || prep_menu
          NUMBER_LOGICAL_VOLUMES=$(cat ${ANSWER})
    done

    # Loop while the number of LVs is greater than 1. This is because the size of the last LV is automatic.
    while [[ $NUMBER_LOGICAL_VOLUMES -gt 1 ]]; do
          dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_LvmLvNameTitle" --inputbox "$_LvmLvNameBody1" 0 0 "lvol" 2>${ANSWER} || prep_menu
          LVM_LV_NAME=$(cat ${ANSWER})

          # Loop if preceeded with a "/", if nothing is entered, if there is a space, or if that name already exists.
          while [[ ${LVM_LV_NAME:0:1} == "/" ]] || [[ ${#LVM_LV_NAME} -eq 0 ]] || [[ ${LVM_LV_NAME} =~ \ |\' ]] || [[ $(lsblk | grep ${LVM_LV_NAME}) != "" ]]; do
              dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_LvmLvNameErrTitle" --msgbox "$_LvmLvNameErrBody" 0 0

              dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_LvmLvNameTitle" --inputbox "$_LvmLvNameBody1" 0 0 "lvol" 2>${ANSWER} || prep_menu
              LVM_LV_NAME=$(cat ${ANSWER})
          done

          dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_LvmLvSizeTitle" --inputbox "\n${LVM_VG}: ${VG_SIZE}${VG_SIZE_TYPE} (${LVM_VG_MB}MB $_LvmLvSizeBody1).$_LvmLvSizeBody2" 0 0 "" 2>${ANSWER} || prep_menu
          LVM_LV_SIZE=$(cat ${ANSWER})          
          check_lv_size 
          
          # Loop while an invalid value is entered.
          while [[ $LV_SIZE_INVALID -eq 1 ]]; do
                dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_LvmLvSizeErrTitle" --msgbox "$_LvmLvSizeErrBody" 0 0
          
                dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_LvmLvSizeTitle" --inputbox "\n${LVM_VG}: ${VG_SIZE}${VG_SIZE_TYPE} (${LVM_VG_MB}MB $_LvmLvSizeBody1).$_LvmLvSizeBody2" 0 0 "" 2>${ANSWER} || prep_menu
                LVM_LV_SIZE=$(cat ${ANSWER})          
                check_lv_size
          done
          
          # Create the LV
          lvcreate -L ${LVM_LV_SIZE} ${LVM_VG} -n ${LVM_LV_NAME} 2>/tmp/.errlog
          check_for_error
          dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_LvmLvDoneTitle" --msgbox "\n$_Done\n\nLV ${LVM_LV_NAME} (${LVM_LV_SIZE}) $_LvmPvDoneBody2.\n\n" 0 0
          NUMBER_LOGICAL_VOLUMES=$(( NUMBER_LOGICAL_VOLUMES - 1 ))
    done
    
    # Now the final LV. Size is automatic.      
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_LvmLvNameTitle" --inputbox "$_LvmLvNameBody1 $_LvmLvNameBody2 (${LVM_VG_MB}MB)." 0 0 "lvol" 2>${ANSWER} || prep_menu
    LVM_LV_NAME=$(cat ${ANSWER})

          # Loop if preceeded with a "/", if nothing is entered, if there is a space, or if that name already exists.
          while [[ ${LVM_LV_NAME:0:1} == "/" ]] || [[ ${#LVM_LV_NAME} -eq 0 ]] || [[ ${LVM_LV_NAME} =~ \ |\' ]] || [[ $(lsblk | grep ${LVM_LV_NAME}) != "" ]]; do
              dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_LvmLvNameErrTitle" --msgbox "$_LvmLvNameErrBody" 0 0

              dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_LvmLvNameTitle" --inputbox "$_LvmLvNameBody1 $_LvmLvNameBody2 (${LVM_VG_MB}MB)." 0 0 "lvol" 2>${ANSWER} || prep_menu
              LVM_LV_NAME=$(cat ${ANSWER})
          done

    # Create the final LV
    lvcreate -l +100%FREE ${LVM_VG} -n ${LVM_LV_NAME} 2>/tmp/.errlog
    check_for_error
    NUMBER_LVM_PARTITIONS=$(( NUMBER_LVM_PARTITIONS - 1 ))
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_LvmCompTitle" --yesno "$_LvmCompBody" 0 0 \
    && show_devices || prep_menu
}
