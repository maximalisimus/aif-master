######################################################################
##                                                                  ##
##             Encryption (dm_crypt) Functions                      ##
##                                                                  ##
######################################################################

# Had to write it in this way due to (bash?) bug(?), as if/then statements in a single
# "create LUKS" function for default and "advanced" modes were interpreted as commands,
# not mere string statements. Not happy with it, but it works...

# Save repetition of code.
luks_password(){

    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $_PrepLUKS " --clear --insecure --passwordbox "$_LuksPassBody" 0 0 2> ${ANSWER} || prep_menu
    PASSWD=$(cat ${ANSWER})
    
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $_PrepLUKS " --clear --insecure --passwordbox "$_PassReEntBody" 0 0 2> ${ANSWER} || prep_menu
    PASSWD2=$(cat ${ANSWER})
    
    if [[ $PASSWD != $PASSWD2 ]]; then 
       dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $_ErrTitle " --msgbox "$_PassErrBody" 0 0
       luks_password
    fi

}

luks_open(){

    LUKS_ROOT_NAME=""
    INCLUDE_PART='part\|crypt\|lvm'
    umount_partitions
    find_partitions
    
    # Select encrypted partition to open 
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $_LuksOpen " --menu "$_LuksMenuBody" 0 0 7 ${PARTITIONS} 2>${ANSWER} || luks_menu
    PARTITION=$(cat ${ANSWER})
    
    # Enter name of the Luks partition and get password to open it
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $_LuksOpen " --inputbox "$_LuksOpenBody" 10 50 "cryptroot" 2>${ANSWER} || luks_menu
    LUKS_ROOT_NAME=$(cat ${ANSWER})
    luks_password
    
    # Try to open the luks partition with the credentials given. If successful show this, otherwise
    # show the error
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $_LuksOpen " --infobox "$_PlsWaitBody" 0 0
    echo $PASSWD | cryptsetup open --type luks ${PARTITION} ${LUKS_ROOT_NAME} 2>/tmp/.errlog
    check_for_error

    lsblk -o NAME,TYPE,FSTYPE,SIZE,MOUNTPOINT ${PARTITION} | grep "crypt\|NAME\|MODEL\|TYPE\|FSTYPE\|SIZE" > /tmp/.devlist
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $_DevShowOpt " --textbox /tmp/.devlist 0 0
    
    luks_menu
}

luks_setup(){

    modprobe -a dm-mod dm_crypt
    INCLUDE_PART='part\|lvm'
    umount_partitions
    find_partitions
    
    # Select partition to encrypt 
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $_LuksEncrypt " --menu "$_LuksCreateBody" 0 0 7 ${PARTITIONS} 2>${ANSWER} || luks_menu
    PARTITION=$(cat ${ANSWER})

    # Enter name of the Luks partition and get password to create it
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $_LuksEncrypt " --inputbox "$_LuksOpenBody" 10 50 "cryptroot" 2>${ANSWER} || luks_menu
    LUKS_ROOT_NAME=$(cat ${ANSWER})
    luks_password
}

luks_default() {
    
    # Encrypt selected partition or LV with credentials given
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $_LuksEncrypt " --infobox "$_PlsWaitBody" 0 0
    sleep 2
    echo $PASSWD | cryptsetup -q luksFormat ${PARTITION} 2>/tmp/.errlog
    
    # Now open the encrypted partition or LV
    echo $PASSWD | cryptsetup open ${PARTITION} ${LUKS_ROOT_NAME} 2>/tmp/.errlog
    check_for_error
    
}

luks_key_define() {
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $_PrepLUKS " --inputbox "$_LuksCipherKey" 0 0 "-s 512 -c aes-xts-plain64" 2>${ANSWER} || luks_menu

    # Encrypt selected partition or LV with credentials given
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $_LuksEncryptAdv " --infobox "$_PlsWaitBody" 0 0
    sleep 2

    echo $PASSWD | cryptsetup -q $(cat ${ANSWER}) luksFormat ${PARTITION} 2>/tmp/.errlog
    check_for_error

    # Now open the encrypted partition or LV
    echo $PASSWD | cryptsetup open ${PARTITION} ${LUKS_ROOT_NAME} 2>/tmp/.errlog
    check_for_error

}

luks_show(){
    
    echo -e ${_LuksEncruptSucc} > /tmp/.devlist
    lsblk -o NAME,TYPE,FSTYPE,SIZE ${PARTITION} | grep "part\|crypt\|NAME\|TYPE\|FSTYPE\|SIZE" >> /tmp/.devlist
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $_LuksEncrypt " --textbox /tmp/.devlist 0 0

    luks_menu
}

luks_menu() {

    LUKS_OPT=""

    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $_PrepLUKS " --menu "$_LuksMenuBody$_LuksMenuBody2$_LuksMenuBody3" 0 0 4 \
    "$_LuksOpen" "cryptsetup open --type luks" \
    "$_LuksEncrypt" "cryptsetup -q luksFormat" \
    "$_LuksEncryptAdv" "cryptsetup -q -s -c luksFormat" \
    "$_Back" "-" 2>${ANSWER}

    case $(cat ${ANSWER}) in
        "$_LuksOpen")       luks_open ;;
        "$_LuksEncrypt")    luks_setup
                            luks_default
                            luks_show ;;
        "$_LuksEncryptAdv") luks_setup
                            luks_key_define
                            luks_show ;;
        *)                  prep_menu ;;
    esac

    luks_menu   

}
