######################################################################
##                                                                  ##
##                        Core Functions                            ##
##                                                                  ##
######################################################################

# Add locale on-the-fly and sets source translation file for installer
select_language() {
    
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " Select Language " --menu "\nLanguage / sprache / taal / språk / lingua / idioma / nyelv / língua" 0 0 11 \
    "1" $"English       (en)" \
    "2" $"Italian       (it)" \
    "3" $"Russian       (ru)" \
    "4" $"Turkish       (tr)" \
    "5" $"Dutch         (nl)" \
    "6" $"Greek         (el)" \
    "7" $"Danish        (da)" \
    "8" $"Hungarian     (hu)" \
    "9" $"Portuguese    (pt)" \
   "10" $"German        (de)" \
   "11" $"French        (fr)" 2>${ANSWER}

    case $(cat "${ANSWER}") in
        "1") source "$filesdir"/lang/english.trans
             CURR_LOCALE="en_US.UTF-8"
             _lng="en"
             ;;
        "2") source "$filesdir"/lang/italian.trans
             CURR_LOCALE="it_IT.UTF-8"
             _lng="it"
             ;; 
        "3") source "$filesdir"/lang/russian.trans
             CURR_LOCALE="ru_RU.UTF-8"
             FONT="LatKaCyrHeb-14.psfu"
             _lng="ru"
             ;;
        "4") source "$filesdir"/lang/turkish.trans
             CURR_LOCALE="tr_TR.UTF-8"
             FONT="LatKaCyrHeb-14.psfu"
             _lng="tr"
             ;;
        "5") source "$filesdir"/lang/dutch.trans
             CURR_LOCALE="nl_NL.UTF-8"
             _lng="nl"
             ;;             
        "6") source "$filesdir"/lang/greek.trans
             CURR_LOCALE="el_GR.UTF-8"
             FONT="iso07u-16.psfu"   
             _lng="el"    
             ;;
        "7") source "$filesdir"/lang/danish.trans
             CURR_LOCALE="da_DK.UTF-8"
             ;;   
        "8") source "$filesdir"/lang/hungarian.trans
             CURR_LOCALE="hu_HU.UTF-8"
             FONT="lat2-16.psfu"
             _lng="hu"
             ;;
        "9") source "$filesdir"/lang/portuguese.trans
             CURR_LOCALE="pt_BR.UTF-8"  
             _lng="pt"  
             ;;      
       "10") source "$filesdir"/lang/german.trans
             CURR_LOCALE="de_DE.UTF-8"
             _lng="de"
             ;;
       "11") source "$filesdir"/lang/french.trans
             CURR_LOCALE="fr_FR.UTF-8"
             _lng="fr"
             ;;
          *) exit 0
             ;;
    esac
        
    # Generate the chosen locale and set the language
    sed -i "s/#${CURR_LOCALE}/${CURR_LOCALE}/" /etc/locale.gen
    locale-gen >/dev/null 2>&1
    export LANG=${CURR_LOCALE}
    [[ $FONT != "" ]] && setfont $FONT
}



# Check user is root, and that there is an active internet connection
# Seperated the checks into seperate "if" statements for readability.
check_requirements() {
    
  dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_ChkTitle" --infobox "$_ChkBody" 0 0
  sleep 2
  
  if [[ `whoami` != "root" ]]; then
     dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_RtFailTitle" --infobox "$_RtFailBody" 0 0
     sleep 2
     exit 1
  fi
  
  if [[ ! $(ping -c 1 google.com) ]]; then
     dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_ConFailTitle" --infobox "$_ConFailBody" 0 0
     sleep 2
     exit 1
  fi
  
  # This will only be executed where neither of the above checks are true.
  # The error log is also cleared, just in case something is there from a previous use of the installer.
  dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_ReqMetTitle" --infobox "$_ReqMetBody" 0 0
  sleep 2   
  clear
  echo "" > /tmp/.errlog
  pacman -Syy

}

# Adapted from AIS. Checks if system is made by Apple, whether the system is BIOS or UEFI,
# and for LVM and/or LUKS.
id_system() {
    
    # Apple System Detection
    if [[ "$(cat /sys/class/dmi/id/sys_vendor)" == 'Apple Inc.' ]] || [[ "$(cat /sys/class/dmi/id/sys_vendor)" == 'Apple Computer, Inc.' ]]; then
      modprobe -r -q efivars || true  # if MAC
    else
      modprobe -q efivarfs            # all others
    fi
    
    # BIOS or UEFI Detection
    if [[ -d "/sys/firmware/efi/" ]]; then
      # Mount efivarfs if it is not already mounted
      if [[ -z $(mount | grep /sys/firmware/efi/efivars) ]]; then
        mount -t efivarfs efivarfs /sys/firmware/efi/efivars
      fi
      SYSTEM="UEFI"
    else
      SYSTEM="BIOS"
    fi
         
    # Encryption (LUKS) Detection
    [[ $(lsblk -o TYPE | grep "crypt") == "" ]] && LUKS=0 || LUKS=1

}   
 

# Adapted from AIS. An excellent bit of code!
arch_chroot() {
    arch-chroot $MOUNTPOINT /bin/bash -c "${1}"
}  

# If there is an error, display it, clear the log and then go back to the main menu (no point in continuing).
check_for_error() {

 if [[ $? -eq 1 ]] && [[ $(cat /tmp/.errlog | grep -i "error") != "" ]]; then
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_ErrTitle" --msgbox "$(cat /tmp/.errlog)" 0 0
    echo "" > /tmp/.errlog
    main_menu_online
 fi
   
}

# Ensure that a partition is mounted
check_mount() {

    if [[ $(lsblk -o MOUNTPOINT | grep ${MOUNTPOINT}) == "" ]]; then
       dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_ErrTitle" --msgbox "$_ErrNoMount" 0 0
       main_menu_online
    fi

}

# Ensure that Arch has been installed
check_base() {

    if [[ ! -e ${MOUNTPOINT}/etc ]]; then
        dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_ErrTitle" --msgbox "$_ErrNoBase" 0 0
        main_menu_online
    fi
    
}

# Simple code to show devices / partitions.
show_devices() {
     lsblk -o NAME,MODEL,TYPE,FSTYPE,SIZE,MOUNTPOINT | grep -v "loop" | grep -v "rom" | grep -v "arch_airootfs" > /tmp/.devlist
     dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_DevShowTitle" --textbox /tmp/.devlist 0 0
}

skip_orderers_resume()
{
    if [[ $_orders == "0" ]]; then
	    _orders=1
        dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_yesno_order_ttl" --yesno "$_yesno_order_bd" 0 0
        if [[ $? -eq 0 ]]; then
            LTS=1
        fi
    fi
}

test() {
    
    ping -c 3 google.com > /tmp/.outfile &
    dialog --title "checking" --no-kill --tailboxbg /tmp/.outfile 20 60 

}
