#!/bin/bash
#
######################################################################
##                                                                  ##
##                    Installation Functions                        ##
##                                                                  ##
######################################################################  

install_base() {
    ipv6_disable()
    {
        dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_yesno_ipv6_title" --yesno "$_yesno_ipv6_body" 0 0
         if [[ $? -eq 0 ]]; then
            [ -e ${MOUNTPOINT}/etc/sysctl.d/ ] || mkdir ${MOUNTPOINT}/etc/sysctl.d/
            echo "# if problem to download packets then create file:" > ${MOUNTPOINT}/etc/sysctl.d/40-ipv6.conf
            echo "# /etc/sysctl.d/40-ipv6.conf" >> ${MOUNTPOINT}/etc/sysctl.d/40-ipv6.conf
            echo "" >> ${MOUNTPOINT}/etc/sysctl.d/40-ipv6.conf
            echo "net.ipv6.conf.all.disable_ipv6=1" >> ${MOUNTPOINT}/etc/sysctl.d/40-ipv6.conf
        fi  
    }

    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_InstBseTitle" \
    --menu "$_InstBseBody" 0 0 4 \
    "1" "$_InstBaseLK" \
    "2" "$_InstBaseLKBD" \
    "3" "$_InstBaseLTS" \
    "4" "$_InstBaseLTSBD" \
    "5" "$_Back" 2>${ANSWER}   

    case $(cat ${ANSWER}) in
        "1") # Latest Kernel
             clear
            info_search_pkg
            _list_base_pkg=$(check_s_lst_pkg "${_base_pkg[*]}")
            wait
            _list_krnl_pkg=$(check_s_lst_pkg "${_krnl_pkg[*]}")
            wait
            clear
            [[ ${_list_base_pkg[*]} != "" ]] && ps_in_pkg "base" "${_list_base_pkg[*]}" \
            || pacstrap ${MOUNTPOINT} base 2>/tmp/.errlog
            wait
            [[ ${_list_krnl_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_list_krnl_pkg[*]} 2>/tmp/.errlog
            wait
             ipv6_disable
            _orders=1
             ;;
        "2") # Latest Kernel and base-devel
             clear
             info_search_pkg
            _list_base_devel=$(check_s_lst_pkg "${_base_devel_pkg[*]}")
            wait
            _list_krnl_pkg=$(check_s_lst_pkg "${_krnl_pkg[*]}")
            wait
            clear
            [[ ${_list_base_devel[*]} != "" ]] && ps_in_pkg "base" "base-devel" "${_list_base_devel[*]}" \
            || pacstrap ${MOUNTPOINT} base base-devel 2>/tmp/.errlog
            wait
            [[ ${_list_krnl_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_list_krnl_pkg[*]} 2>/tmp/.errlog
            wait
            ipv6_disable
            _orders=1
             ;;
        "3") # LTS Kernel
             clear
             info_search_pkg
             _list_lts_pkg=$(check_s_lst_pkg "${_lts_pkg[*]}")
             wait
             _list_base_pkg=$(check_s_lst_pkg "${_base_pkg[*]}")
             wait
             clear
             [[ ${_list_lts_pkg[*]} != "" ]] && LTS=1
             [[ ${_list_lts_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} base ${_list_lts_pkg[*]} 2>/tmp/.errlog \
             || pacstrap ${MOUNTPOINT} base 2>/tmp/.errlog
             [[ ${_list_base_pkg[*]} != "" ]] && ps_in_pkg "${_list_base_pkg[*]}"
             ipv6_disable
            _orders=1
             ;;
        "4") # LTS Kernel and base-devel
             clear
             info_search_pkg
             _list_lts_pkg=$(check_s_lst_pkg "${_lts_pkg[*]}")
             wait
              _list_base_devel=$(check_s_lst_pkg "${_base_devel_pkg[*]}")
             wait
             clear
             [[ ${_list_lts_pkg[*]} != "" ]] && LTS=1
              [[ ${_list_lts_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} base base-devel ${_list_lts_pkg[*]} 2>/tmp/.errlog \
              || pacstrap ${MOUNTPOINT} base base-devel 2>/tmp/.errlog
              [[ ${_list_base_devel[*]} != "" ]] && ps_in_pkg "${_list_base_devel[*]}"
             ipv6_disable
            _orders=1
             ;;
          *) install_base_menu
             ;;
    esac    
    
    if [[ ${_archi[*]} == "x86_64" ]]; then
        if [[ $_multilib == "1" ]]; then
            pc_conf_prcss "${MOUNTPOINT}/etc/pacman.conf" "$_pcm_tempf"
        fi
    fi
    mirrorlist_question 
    
    outline_dhcpcd
    
    sed -i 's/\# include \"\/usr\/share\/nano\/\*.nanorc\"/include \"\/usr\/share\/nano\/\*.nanorc\"/' ${MOUNTPOINT}/etc/nanorc 2>>/tmp/.errlog
    
    check_for_error

  #check for a wireless device
  if [[ $(lspci | grep -i "Network Controller") != "" ]]; then
     dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_InstWirTitle" --infobox "$_InstWirBody" 0 0 
     sleep 2
     clear
     install_wireless_programm
     clear
     check_for_error
  fi

}

install_de_wm() {

   # Only show this information box once
   if [[ $SHOW_ONCE -eq 0 ]]; then
      dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_DEInfoTitle" --msgbox "$_DEInfoBody" 0 0
      SHOW_ONCE=1
   fi
   
   if [[ $_d_menu_once == "0" ]]; then
        _d_menu_once=1
        clear
        _list_dm_menu=""
        for i in ${_desktop_menu[*]}; do
            _list_dm_menu="${_list_dm_menu} $i -"
        done
    fi
   
   dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_InstDETitle" --menu "$_InstDEBody" 0 0 16 ${_list_dm_menu} 2>${ANSWER}
   
   case $(cat ${ANSWER}) in
        "${_desktop_menu[0]}") # Deepin
             clear
             info_search_pkg
            _list_deepin_pkg=$(check_dm_lst_pkg "${_deepin_pkg[*]}")
            wait
            clear
            [[ ${_list_deepin_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_list_deepin_pkg[*]} 2>/tmp/.errlog
            LIGHTDM_INSTALLED=1
            DEEPIN_INSTALLED=1
            arch_chroot "systemctl enable lightdm.service" >/dev/null 2>>/tmp/.errlog
            DM="LightDM"
            sed -i '/^\[Seat:\*\]/a \greeter-session=lightdm-deepin-greeter' "${MOUNTPOINT}/etc/lightdm/lightdm.conf"
            if [[ $NM_INSTALLED -eq 0 ]]; then          
                arch_chroot "systemctl enable NetworkManager.service && systemctl enable NetworkManager-dispatcher.service" 2>>/tmp/.errlog
                NM_INSTALLED=1
                NM_COMPONENT_INSTALLED=0
            fi
            wait
            greeter_configuration
            wait
             ;;
        "${_desktop_menu[1]}") # Deepin+Deepin-Extra
             clear
             info_search_pkg
            _list_deepine_pkg=$(check_dm_lst_pkg "${_deepin_extra_pkg[*]}")
            wait
            clear
            [[ ${_list_deepine_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_list_deepine_pkg[*]} 2>/tmp/.errlog
            LIGHTDM_INSTALLED=1
            DEEPIN_INSTALLED=1
            arch_chroot "systemctl enable lightdm.service" >/dev/null 2>>/tmp/.errlog
            DM="LightDM"
            sed -i '/^\[Seat:\*\]/a \greeter-session=lightdm-deepin-greeter' "${MOUNTPOINT}/etc/lightdm/lightdm.conf"
            if [[ $NM_INSTALLED -eq 0 ]]; then          
                arch_chroot "systemctl enable NetworkManager.service && systemctl enable NetworkManager-dispatcher.service" 2>>/tmp/.errlog
                NM_INSTALLED=1
                NM_COMPONENT_INSTALLED=0
            fi
            wait
            greeter_configuration
            wait
             ;;
        "${_desktop_menu[2]}") # Cinnamon
             clear
             info_search_pkg
            _list_cinnamon_pkg=$(check_dm_lst_pkg "${_cinnamon_pkg[*]}")
            wait
            clear
            [[ ${_list_cinnamon_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_list_cinnamon_pkg[*]} 2>/tmp/.errlog
             ;;
        "${_desktop_menu[3]}") # Enlightement
             clear
             info_search_pkg
            _list_enlightenment_pkg=$(check_dm_lst_pkg "${_enlightenment_pkg[*]}")
            wait
            clear
            [[ ${_list_enlightenment_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_list_enlightenment_pkg[*]} 2>/tmp/.errlog
             ;;
        "${_desktop_menu[4]}") # Gnome-Shell
             clear
             info_search_pkg
             _list_gnome_shell_pkg=$(check_dm_lst_pkg "${_gnome_shell_pkg[*]}")
             wait
             clear
             [[ ${_list_gnome_shell_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_list_gnome_shell_pkg[*]} 2>/tmp/.errlog
             GNOME_INSTALLED=1
             ;;
        "${_desktop_menu[5]}") # Gnome
             clear
             info_search_pkg
            _list_gnome_pkg=$(check_dm_lst_pkg "${_gnome_pkg[*]}")
            wait
            clear
            [[ ${_list_gnome_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_list_gnome_pkg[*]} 2>/tmp/.errlog
           
             GNOME_INSTALLED=1
             ;;            
        "${_desktop_menu[6]}") # Gnome + Extras
             clear
             info_search_pkg
            _list_gnome_extras_pkg=$(check_dm_lst_pkg "${_gnome_extras_pkg[*]}")
            wait
            clear
            [[ ${_list_gnome_extras_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_list_gnome_extras_pkg[*]} 2>/tmp/.errlog
           
             GNOME_INSTALLED=1
             ;;
        "${_desktop_menu[7]}") # KDE5 BASE
             clear
            info_search_pkg
            _list_kde5base_pkg=$(check_dm_lst_pkg "${_kde5base_pkg[*]}")
            wait
            clear
            [[ ${_list_kde5base_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_list_kde5base_pkg[*]} 2>/tmp/.errlog
             ;;
        "${_desktop_menu[8]}") # KDE5 
             clear
             info_search_pkg
            _list_kde_pkg=$(check_dm_lst_pkg "${_kde_pkg[*]}")
            wait
            clear
            [[ ${_list_kde_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_list_kde_pkg[*]} 2>/tmp/.errlog

             if [[ $NM_INSTALLED -eq 0 ]]; then          
                arch_chroot "systemctl enable NetworkManager.service && systemctl enable NetworkManager-dispatcher.service" 2>>/tmp/.errlog
                NM_INSTALLED=1
                NM_COMPONENT_INSTALLED=0
             fi
               
             KDE_INSTALLED=1
             ;;
         "${_desktop_menu[9]}") # LXDE
              clear
              info_search_pkg
              _list_lxde_pkg=$(check_dm_lst_pkg "${_lxde_pkg[*]}")
              wait
              clear
              [[ ${_list_lxde_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_list_lxde_pkg[*]} 2>/tmp/.errlog
              LXDE_INSTALLED=1
             ;;
         "${_desktop_menu[10]}") # LXQT
              clear
              info_search_pkg
            _list_lxqt_pkg=$(check_dm_lst_pkg "${_lxqt_pkg[*]}")
            wait
            clear
            [[ ${_list_lxqt_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_list_lxqt_pkg[*]} 2>/tmp/.errlog
              LXQT_INSTALLED=1
              ;;
         "${_desktop_menu[11]}") # MATE
              clear
              info_search_pkg
            _list_mate_pkg=$(check_dm_lst_pkg "${_mate_pkg[*]}")
            wait
            clear
            [[ ${_list_mate_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_list_mate_pkg[*]} 2>/tmp/.errlog
             ;;
        "${_desktop_menu[12]}") # MATE + Extras
               clear
              info_search_pkg
            _list_mateextra_pkg=$(check_dm_lst_pkg "${_mateextra_pkg[*]}")
            wait
            [[ ${_list_mateextra_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_list_mateextra_pkg[*]} 2>/tmp/.errlog
             ;;                 
        "${_desktop_menu[13]}") # Xfce
              clear
              info_search_pkg
            _list_xfce4_pkg=$(check_dm_lst_pkg "${_xfce4_pkg[*]}")
            wait
            clear
            [[ ${_list_xfce4_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_list_xfce4_pkg[*]} 2>/tmp/.errlog
             ;;            
        "${_desktop_menu[14]}") # Xfce + Extras
              clear
              info_search_pkg
            _list_xfce4_extra_pkg=$(check_dm_lst_pkg "${_xfce4_extra_pkg[*]}")
            wait
            clear
            [[ ${_list_xfce4_extra_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_list_xfce4_extra_pkg[*]} 2>/tmp/.errlog
             ;;
        "${_desktop_menu[15]}") # Awesome
              clear
              info_search_pkg
            _list_awesome_pkg=$(check_dm_lst_pkg "${_awesome_pkg[*]}")
            wait
            clear
            [[ ${_list_awesome_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_list_awesome_pkg[*]} 2>/tmp/.errlog
             ;;
        "${_desktop_menu[16]}") #Fluxbox
              clear
              info_search_pkg
            _list_fluxbox_pkg=$(check_dm_lst_pkg "${_fluxbox_pkg[*]}")
            wait
            clear
            [[ ${_list_fluxbox_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_list_fluxbox_pkg[*]} 2>/tmp/.errlog
             ;; 
        "${_desktop_menu[17]}") #i3
              clear
              info_search_pkg
            _list_i3wm_pkg=$(check_dm_lst_pkg "${_i3wm_pkg[*]}")
            wait
            clear
            [[ ${_list_i3wm_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_list_i3wm_pkg[*]} 2>/tmp/.errlog
             ;; 
        "${_desktop_menu[18]}") #IceWM
              clear
              info_search_pkg
            _list_icewm_pkg=$(check_dm_lst_pkg "${_icewm_pkg[*]}")
            wait
            clear
            [[ ${_list_icewm_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_list_icewm_pkg[*]} 2>/tmp/.errlog
             ;; 
        "${_desktop_menu[19]}") #Openbox
              clear
              info_search_pkg
            _list_openbox_pkg=$(check_dm_lst_pkg "${_openbox_pkg[*]}")
            wait
            clear
            [[ ${_list_openbox_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_list_openbox_pkg[*]} 2>/tmp/.errlog
             ;; 
        "${_desktop_menu[20]}") #PekWM
              clear
              info_search_pkg
            _list_pekwm_pkg=$(check_dm_lst_pkg "${_pekwm_pkg[*]}")
            wait
            clear
            [[ ${_list_pekwm_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_list_pekwm_pkg[*]} 2>/tmp/.errlog
             ;;
        "${_desktop_menu[21]}") #WindowMaker
             clear
             info_search_pkg
            _list_windowmaker_pkg=$(check_dm_lst_pkg "${_windowmaker_pkg[*]}")
            wait
            clear
            [[ ${_list_windowmaker_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_list_windowmaker_pkg[*]} 2>/tmp/.errlog
             ;;        
          *) install_desktop_menu
             ;;
    esac  
    
    check_for_error
}

# Determine if LXDE, LXQT, Gnome, and/or KDE has been installed, and act accordingly.
install_dm() {

# Function to save repetition
dm_menu(){

  dialog --default-item 3 --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_DmChTitle" \
               --menu "$_DmChBody" 0 0 4 \
               "1" $"LXDM" \
               "2" $"LightDM" \
               "3" $"SDDM" \
               "4" $"SLiM" \
               "5" "$_Back" 2>${ANSWER}  
    
              case $(cat ${ANSWER}) in
              "1") # LXDM
                   clear
                   info_search_pkg
                    _list_lxdm_pkg=$(check_s_lst_pkg "${_lxdm_pkg[*]}")
                    wait
                    clear
                   pacstrap ${MOUNTPOINT} ${_list_lxdm_pkg[*]} 2>/tmp/.errlog
                   arch_chroot "systemctl enable lxdm.service" >/dev/null 2>>/tmp/.errlog
                   DM="LXDM"
                   ;;
              "2") # LIGHTDM
                   clear
                   info_search_pkg
                    _list_lightdm_pkg=$(check_s_lst_pkg "${_lightdm_pkg[*]}")
                    wait
                    clear
                   pacstrap ${MOUNTPOINT} ${_list_lightdm_pkg[*]} 2>/tmp/.errlog
                   arch_chroot "systemctl enable lightdm.service" >/dev/null 2>>/tmp/.errlog
                   DM="LightDM"
                   ;;
              "3") # SDDM
                   clear
                   info_search_pkg
                    _list_sddm_pkg=$(check_s_lst_pkg "${_sddm_pkg[*]}")
                    wait
                    clear
                   pacstrap ${MOUNTPOINT} ${_list_sddm_pkg[*]} 2>/tmp/.errlog
                   arch_chroot "sddm --example-config > /etc/sddm.conf"
                   arch_chroot "systemctl enable sddm.service" >/dev/null 2>>/tmp/.errlog
                   DM="SDDM"
                   ;;
              "4") # SLiM
                   clear
                   info_search_pkg
                    _list_slim_pkg=$(check_s_lst_pkg "${_slim_pkg[*]}")
                    wait
                    clear
                   pacstrap ${MOUNTPOINT} ${_list_slim_pkg[*]} 2>/tmp/.errlog
                   arch_chroot "systemctl enable slim.service" >/dev/null 2>>/tmp/.errlog
                   DM="SLiM"

                   # Amend the xinitrc file accordingly for all user accounts
                   user_list=$(ls "${MOUNTPOINT}/home/" | sed "s/lost+found//")
                   for i in ${user_list[@]}; do
                       if [[ -n "${MOUNTPOINT}/home/$i/.xinitrc" ]]; then
                          cp -f "${MOUNTPOINT}/etc/X11/xinit/xinitrc" "${MOUNTPOINT}/home/$i/.xinitrc"
                          arch_chroot "chown -R ${i}:users /home/${i}"
                       fi
                       echo 'exec $1' >> "${MOUNTPOINT}/home/$i/.xinitrc"
                   done    
                   ;;                
                *) install_desktop_menu
                   ;;
            esac
}

 if [[ $DM_INSTALLED -eq 0 ]]; then
         # Gnome without KDE
         if [[ $GNOME_INSTALLED -eq 1 ]] && [[ $KDE_INSTALLED -eq 0 ]]; then
            arch_chroot "systemctl enable gdm.service" >/dev/null 2>/tmp/.errlog
            DM="GDM"

         # Gnome with KDE
         elif [[ $GNOME_INSTALLED -eq 1 ]] && [[ $KDE_INSTALLED -eq 1 ]]; then   
             dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_DmChTitle" \
               --menu "$_DmChBody" 12 45 2 \
               "1" $"GDM  (Gnome)" \
               "2" $"SDDM (KDE)" 2>${ANSWER}    
    
              case $(cat ${ANSWER}) in
              "1") arch_chroot "systemctl enable gdm.service" >/dev/null 2>/tmp/.errlog
                   DM="GDM"
                   ;;
              "2") arch_chroot "sddm --example-config > /etc/sddm.conf"
                   arch_chroot "systemctl enable sddm.service" >/dev/null 2>>/tmp/.errlog
                   DM="SDDM"
                   ;;
                *) install_desktop_menu
                ;;
              esac    
              
         # KDE without Gnome      
        elif [[ $KDE_INSTALLED -eq 1 ]] && [[ $GNOME_INSTALLED -eq 0 ]]; then
            arch_chroot "sddm --example-config > /etc/sddm.conf"
            arch_chroot "systemctl enable sddm.service" >/dev/null 2>>/tmp/.errlog
            DM="SDDM"
            
         # LXDM, without KDE or Gnome 
         elif [[ $LXDE_INSTALLED -eq 1 ]] && [[ $KDE_INSTALLED -eq 0 ]] && [[ $GNOME_INSTALLED -eq 0 ]]; then
            arch_chroot "systemctl enable lxdm.service" >/dev/null 2>/tmp/.errlog
            DM="LXDM"

        # LightDM + Deepin
        elif [[ $LIGHTDM_INSTALLED -eq 1 ]]; then
            arch_chroot "systemctl enable lightdm.service" >/dev/null 2>>/tmp/.errlog
            DM="LightDM"
            sed -i '/^\[Seat:\*\]/a \greeter-session=lightdm-deepin-greeter' "${MOUNTPOINT}/etc/lightdm/lightdm.conf"
         # Otherwise, select a DM      
         else 
           dm_menu      
         fi
        
        # Check installation success, inform user, and flag DM_INSTALLED so it cannot be run again
        check_for_error
        dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $DM $_DmDoneTitle" --msgbox "\n$DM $_DMDoneBody" 0 0
        DM_INSTALLED=1
         
	# if A display manager has already been installed and enabled (DM_INSTALLED=1), show a message instead.
	else  
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_DmInstTitle" --msgbox "$_DmInstBody" 0 0
	fi       

	# DM="LightDM"
	if [[ $DM == "LightDM" ]]; then
		greeter_configuration
	fi
}

install_nm() {
   # Check to see if a NM has already been installed and enabled
   if [[ $NM_INSTALLED -eq 0 ]]; then
        if [[ $_nm_once == 0 ]]; then
            _nm_once=1
            clear
            info_search_pkg
            _list_network_menu=$(check_s_lst_pkg "${_network_menu[*]}")
            wait
            clear
            _ln_menu=""
            for i in ${_list_network_menu[*]}; do
                _ln_menu="${_ln_menu} $i -"
            done
            _ln_menu="${_ln_menu} dhcpcd -"
        fi
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_InstNMTitle" --menu "$_InstNMBody" 0 0 4 ${_ln_menu} 2>${ANSWER}
          
      case $(cat ${ANSWER}) in
      "${_network_menu[0]}") # netctl
			netctl_instalation
            ;;
      "${_network_menu[1]}") # connman
           pacstrap ${MOUNTPOINT} ${_network_menu[1]} 2>/tmp/.errlog
           install_shara_components
           arch_chroot "systemctl enable connman.service" 2>>/tmp/.errlog
           ;;
      "dhcpcd") # dhcpcd
           clear
           install_shara_components
           arch_chroot "systemctl enable dhcpcd.service" 2>/tmp/.errlog
           ;;
      "${_network_menu[2]}") # Network Manager
           clear
           info_search_pkg
           _list_net=$(check_s_lst_pkg "${_networkmanager_pkg[*]}")
           wait
           _clist_list_net=$(check_q_lst_pkg "${_list_net[*]}")
           wait
           _list_net_connect=$(check_s_lst_pkg "${_net_connect_var[*]}")
           wait
           _clist_list_net_conn=$(check_q_lst_pkg "${_list_net_connect[*]}")
           wait
           clear
           [[ ${_clist_list_net[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_clist_list_net[*]} 2>/tmp/.errlog
           dialog --defaultno --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_yn_s_tnc_ttl" --yesno "$_yesno_tnc_body" 0 0
           if [[ $? -eq 0 ]]; then
               dialog --defaultno --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_yn_s_tnc_ttl" --yesno "$_yn_s_tnc_bd" 0 0
               if [[ $? -eq 0 ]]; then
                    _nm_tc_menu=""
                    for k in ${_clist_list_net_conn[*]}; do
                        _nm_tc_menu="${_nm_tc_menu} $k - on"
                    done
                    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_yesno_shara_title" --checklist "$_chl_xpkg_bd" 0 0 16 ${_nm_tc_menu} 2>${ANSWER}
                    _check_nm_tc=$(cat ${ANSWER})
                    [[ ${_check_nm_tc[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_check_nm_tc[*]} 2>/tmp/.errlog
                    wait
               else
                    pacstrap ${MOUNTPOINT} ${_clist_list_net_conn[*]} 2>/tmp/.errlog
                    wait
               fi
           fi
           wait
           install_shara_components
           arch_chroot "systemctl enable NetworkManager.service && systemctl enable NetworkManager-dispatcher.service" 2>>/tmp/.errlog
           ;;
      "${_network_menu[3]}") # WICD
           clear
           info_search_pkg
           _list_wicd_pkg=$(check_s_lst_pkg "${_wicd_pkg[*]}")
           wait
           clear
           pacstrap ${MOUNTPOINT} ${_list_wicd_pkg[*]} 2>/tmp/.errlog
           install_shara_components
           arch_chroot "systemctl enable wicd.service" 2>>/tmp/.errlog
           ;;
        *) install_desktop_menu
           ;;
      esac
      
      check_for_error
      dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_InstNMDoneTitle" --msgbox "$_InstNMDoneBody" 0 0
      NM_INSTALLED=1
      NM_COMPONENT_INSTALLED=1
   else
      if [[ $NM_COMPONENT_INSTALLED -eq 0 ]]; then
           NM_COMPONENT_INSTALLED=1
           dialog --defaultno --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_yn_s_tnc_ttl" --yesno "$_yesno_tnc_body" 0 0
           if [[ $? -eq 0 ]]; then
               clear
               info_search_pkg
               _list_net_connect=$(check_s_lst_pkg "${_net_connect_var[*]}")
               wait
               _clist_list_net_conn=$(check_q_lst_pkg "${_list_net_connect[*]}")
               wait
               clear
               dialog --defaultno --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_yn_s_tnc_ttl" --yesno "$_yn_s_tnc_bd" 0 0
               if [[ $? -eq 0 ]]; then
                    _nm_tc_menu=""
                    for k in ${_clist_list_net_conn[*]}; do
                        _nm_tc_menu="${_nm_tc_menu} $k - on"
                    done
                    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_yesno_shara_title" --checklist "$_chl_xpkg_bd" 0 0 16 ${_nm_tc_menu} 2>${ANSWER}
                    _check_nm_tc=$(cat ${ANSWER})
                    [[ ${_check_nm_tc[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_check_nm_tc[*]} 2>/tmp/.errlog
                    wait
               else
                    pacstrap ${MOUNTPOINT} ${_clist_list_net_conn[*]} 2>/tmp/.errlog
                    wait
               fi
               check_for_error
           fi
           install_shara_components
      fi
      dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_InstNMDoneTitle" --msgbox "$_InstNMErrBody" 0 0
   fi
}
