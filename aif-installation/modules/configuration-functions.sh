#!/bin/bash
#
######################################################################
##                                                                  ##
##                 Configuration Functions                          ##
##                                                                  ##
######################################################################


# Adapted from AIS. Added option to allow users to edit the mirrorlist.
configure_mirrorlist() {

# Generate a mirrorlist based on the country chosen.    
mirror_by_country() {

 COUNTRY_LIST=""
 mirror_config    
 if [[ ${_archi[*]} == "x86_64" ]]; then
    countries_list=("AU_Australia AT_Austria BY_Belarus BE_Belgium BR_Brazil BG_Bulgaria CA_Canada CL_Chile CN_China CO_Colombia CZ_Czech_Republic DK_Denmark EE_Estonia FI_Finland FR_France DE_Germany GB_United_Kingdom GR_Greece HU_Hungary IN_India IE_Ireland IL_Israel IT_Italy JP_Japan KZ_Kazakhstan KR_Korea LV_Latvia LU_Luxembourg MK_Macedonia NL_Netherlands NC_New_Caledonia NZ_New_Zealand NO_Norway PL_Poland PT_Portugal RO_Romania RU_Russia RS_Serbia SG_Singapore SK_Slovakia ZA_South_Africa ES_Spain LK_Sri_Lanka SE_Sweden CH_Switzerland TW_Taiwan TR_Turkey UA_Ukraine US_United_States UZ_Uzbekistan VN_Vietnam")
    wait
    for i in ${countries_list}; do
        COUNTRY_LIST="${COUNTRY_LIST} ${i} -"
    done
    wait
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_MirrorCntryTitle" --menu "$_MirrorCntryBody" 0 0 16 ${COUNTRY_LIST} 2>${ANSWER} || prep_menu
    wait
    COUNTRY_CODE=$(cat ${ANSWER} | sed 's/_.*//')
    wait
    URL="https://archlinux.org/mirrorlist/?country=${COUNTRY_CODE}${_mirror_conf_str}"
 else
    countries_list=("BY_Belarus FR_France DE_Germany IN_India JP_Japan RU_Russia SG_Singapore CH_Switzerland US_United_States")
    wait
    for i in ${countries_list}; do
        COUNTRY_LIST="${COUNTRY_LIST} ${i} -"
    done
    wait
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_MirrorCntryTitle" --menu "$_MirrorCntryBody" 0 0 16 ${COUNTRY_LIST} 2>${ANSWER} || prep_menu
    wait
    COUNTRY_CODE=$(cat ${ANSWER} | sed 's/_.*//' | tr '[:upper:]' '[:lower:]')
    wait
    URL="https://archlinux32.org/mirrorlist/?country=${COUNTRY_CODE}${_mirror_conf_str}" 
 fi
 wait
 MIRROR_TEMP=$(mktemp --suffix=-mirrorlist)

 # Get latest mirror list and save to tmpfile
 dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_MirrorGenTitle" --infobox "$_MirrorGenBody" 0 0
  
 curl -so "${MIRROR_TEMP}" "${URL}" 2>/tmp/.errlog
 check_for_error
 sed -i 's/^#Server/Server/g' "${MIRROR_TEMP}"
 nano "${MIRROR_TEMP}"

 dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --yesno "$_MirrorGenQ" 0 0

 if [[ $? -eq 0 ]];then
    mv -f "/etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.orig"
    mv -f "${MIRROR_TEMP}" "/etc/pacman.d/mirrorlist"
    chmod +r "/etc/pacman.d/mirrorlist"
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --infobox "$_DoneMsg" 0 0
    sleep 2
 else
    prep_menu
 fi
}

dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_MirrorlistTitle" \
    --menu "$_MirrorlistBody" 0 0 5 \
    "1" "$_MirrorbyCountry" \
    "2" "$_MirrorEdit" \
    "3" "$_MirrorRank" \
    "4" "$_MirrorRestore" \
    "5" "$_Back" 2>${ANSWER}    

    case $(cat ${ANSWER}) in
        "1") mirror_by_country
             ;;
        "2") nano "/etc/pacman.d/mirrorlist"
             ;;
        "3") dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_MirrorRankTitle" --infobox "$_MirrorRankBody" 0 0
             if [[ $_mlpcrm == "0" ]]; then
                _mlpcrm=1
                clear
                info_search_pkg
                _list_rank_mirror=$(check_s_lst_pkg "${_rank_mirror[*]}")
                wait
                if [[ ${_list_rank_mirror[*]} != "" ]]; then
                    pacman -Qs "${_list_rank_mirror[*]}" 1>/dev/null 2>/dev/null
                    [[ $? != "0" ]] && sudo pacman -S "${_list_rank_mirror[*]}" --noconfirm
                fi
                wait
                clear
            fi  
             cp -f "/etc/pacman.d/mirrorlist" "/etc/pacman.d/mirrorlist.backup"
             rankmirrors -n 10 "/etc/pacman.d/mirrorlist.backup" > "/etc/pacman.d/mirrorlist" 2>/tmp/.errlog
             check_for_error
             dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --infobox "$_DoneMsg" 0 0
             sleep 2
             ;;
         "4") if [[ -e "/etc/pacman.d/mirrorlist.orig" ]]; then       
                 mv -f "/etc/pacman.d/mirrorlist.orig" "/etc/pacman.d/mirrorlist"
                 dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --msgbox "$_MirrorRestDone" 0 0
              else
                 dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_MirrorNoneTitle" --msgbox "$_MirrorNoneBody" 0 0
              fi
             ;;
          *) prep_menu
             ;;
    esac
    configure_mirrorlist
}

# virtual console keymap
set_keymap() { 
    
    KEYMAPS=""
    for i in $(ls -R /usr/share/kbd/keymaps | grep "map.gz" | sed 's/\.map.gz//g' | sort); do
        KEYMAPS="${KEYMAPS} ${i} -"
    done
    
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_KeymapTitle" \
    --menu "$_KeymapBody" 20 40 16 ${KEYMAPS} 2>${ANSWER} || prep_menu 
    KEYMAP=$(cat ${ANSWER})
    
    loadkeys $KEYMAP 2>/tmp/.errlog
    check_for_error

    echo -e "KEYMAP=${KEYMAP}\nFONT=${FONT}" > /tmp/vconsole.conf
  }

# Set keymap for X11
 set_xkbmap() {     
    if [[ $_is_xkb -eq 0 ]]; then
        # keymaps_xkb=("af_Afghani al_Albanian am_Armenian ara_Arabic at_German-Austria az_Azerbaijani ba_Bosnian bd_Bangla be_Belgian bg_Bulgarian br_Portuguese-Brazil bt_Dzongkha bw_Tswana by_Belarusian ca_French-Canada cd_French-DR-Congo ch_German-Switzerland cm_English-Cameroon cn_Chinese cz_Czech de_German dk_Danishee_Estonian epo_Esperanto es_Spanish et_Amharic fo_Faroese fi_Finnish fr_French gb_English-UK ge_Georgian gh_English-Ghana gn_French-Guinea gr_Greek hr_Croatian hu_Hungarian ie_Irish il_Hebrew iq_Iraqi ir_Persian is_Icelandic it_Italian jp_Japanese ke_Swahili-Kenya kg_Kyrgyz kh_Khmer-Cambodia kr_Korean kz_Kazakh la_Lao latam_Spanish-Lat-American lk_Sinhala-phonetic lt_Lithuanian lv_Latvian ma_Arabic-Morocco mao_Maori md_Moldavian me_Montenegrin mk_Macedonian ml_Bambara mm_Burmese mn_Mongolian mt_Maltese mv_Dhivehi ng_English-Nigeria nl_Dutch no_Norwegian np_Nepali ph_Filipino pk_Urdu-Pakistan pl_Polish pt_Portuguese ro_Romanian rs_Serbian ru_Russian se_Swedish si_Slovenian sk_Slovak sn_Wolof sy_Arabic-Syria th_Thai tj_Tajik tm_Turkmen tr_Turkish tw_Taiwanese tz_Swahili-Tanzania ua_Ukrainian us_English-US uz_Uzbek vn_Vietnamese za_English-S-Africa")
        
        _switch_xkb=("grp:toggle" "grp:ctrl_shift_toggle" "grp:alt_shift_toggle" "grp:ctrl_alt_toggle" "grp:lwin_toggle" "grp:rwin_toggle" "grp:lctrl_toggle" "grp:rctrl_toggle")
        
        _indicate_xkd=("grp_led:caps" "grp_led:num" "grp_led:scroll")
        
        for i in $(cat $filesdir/modules/xkb-models.conf); do
            _xkb_mdl="${_xkb_mdl} ${i} -"
        done
        
        KEYMAPS=""
        for i in $(ls -R /usr/share/kbd/keymaps | grep "map.gz" | sed 's/\.map.gz//g' | sort); do
            KEYMAPS="${KEYMAPS} ${i} -"
        done
        
        # for i in ${keymaps_xkb[*]}; do
        for i in ${KEYMAPS[*]}; do
            _xkb_list="${_xkb_list} ${i} -"
        done    
        
        
        for i in $(cat $filesdir/modules/xkb-variant.conf); do
            _xkb_var="${_xkb_var} ${i} -"
        done
        
        _is_xkb=1
    fi
    
    xkbmodel()
    {
        dialog --default-item 1 --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_xkb_mdl_title" --menu "$_xkb_mdl_body" 0 0 11 ${_xkb_mdl} 2>${ANSWER} || set_xkbmap
        xkb_model=$(cat ${ANSWER})
    }
   # xkblayout()
   # {
   #     _xkb_w=""
   #     _xkb_u=""
   #     #dialog --default-item 1 --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_xkb_list_title" --menu "$_xkb_list1_body" 0 0 11 ${_xkb_list} 2>${ANSWER} || set_xkbmap
   #     #_xkb_w=$(cat ${ANSWER} |sed 's/_.*//')
   #     _xkb_w="${KEYMAP[*]}"
   #     dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_yesno_user_layout_title" --yesno "$_yesno_user_layout_body" 0 0
   #     if [[ $? -eq 0 ]]; then
   #         dialog --default-item 1 --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_xkb_list_title" --menu "$_xkb_list2_body" 0 0 11 ${_xkb_list} 2>${ANSWER} || set_xkbmap
   #         _xkb_u=$(cat ${ANSWER} |sed 's/_.*//')
   #         [[ $_xkb_w == $_xkb_u ]] && xkb_layout="$_xkb_w" || xkb_layout="$_xkb_u, $_xkb_w"
   #     else
   #         xkb_layout="$_xkb_w"
   #     fi
   # }
    xkbvariant()
    {
        dialog --default-item 1 --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_xkb_var_title" --menu "$_xkb_var_body" 0 0 11 ${_xkb_var} 2>${ANSWER} || set_xkbmap
        xkb_variant=$(cat ${ANSWER})
    }
    xkboptions()
    {
        _sw=""
        _ind=""
        dialog --default-item 2 --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_xkb_switch_title" --menu "$_xkb_switch_body" 0 0 8 \
            "1" $"Right Alt" \
            "2" $"Control+Shift" \
            "3" $"Alt+Shift" \
            "4" $"Control+Alt" \
            "5" $"Left Win" \
            "6" $"Right Win" \
            "7" $"Left Control" \
            "8" $"Right Control" 2>${ANSWER}
        var=$(cat ${ANSWER})
        var=$(($var-1))
        _sw=${_switch_xkb[$var]}
        dialog --default-item 2 --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_xkb_indicate_title" --checklist "$_xkb_indicate_body" 0 0 3 \
            "1" "$_indicate_caps_lock" "off" \
            "2" "$_indicate_num_lock" "on" \
            "3" "$_indicate_scroll_lock" "off" 2>${ANSWER}
        if [[ $(cat ${ANSWER}) == "" ]]; then
            xkb_options="$_sw"
        else
            counter=0
            for i in $(cat ${ANSWER}); do
                if [[ $counter -eq 0 ]]; then
                    counter=1
                    _tmp=$(($i-1))
                    _ind=${_indicate_xkd[_tmp]}
                else
                    _tmp=$(($i-1))
                    _ind="${_ind},${_indicate_xkd[_tmp]}"
                fi
            done
            xkb_options="$_sw,$_ind"
        fi
    }
    fine_keyboard_conf()
    {
       # [[ $xkb_layout == "" ]] && _skip=1
        [[ $xkb_model == "" ]] && _skip=1
        [[ $xkb_variant == "" ]] && _skip=1
        [[ $xkb_layout == "" ]] && xkb_layout="${KEYMAP[*]}"
        [[ $xkb_model == "" ]] && xkb_model="pc105"
        [[ $xkb_variant == "" ]] && xkb_variant="qwerty"
        if [[ $_skip == "1" ]]; then
            _xkb_info_body="\n$_inf2\n\n$_inf_l $xkb_layout\n$_inf_m $xkb_model\n$_inf_v $xkb_variant\n$_inf_o $xkb_options\n\n\n"
            dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_xkb_info_title" --msgbox "$_xkb_info_body" 0 0
            _skip=0
        fi
        echo "# /etc/X11/xorg.conf.d/00-keyboard.conf " > /tmp/00-keyboard.conf
        echo "# Read and parsed by systemd-localed. It's probably wise not to edit this file" >> /tmp/00-keyboard.conf
        echo -e -n "# manually too freely.\n" >> /tmp/00-keyboard.conf
        echo -e -n "Section \"InputClass\"\n" >> /tmp/00-keyboard.conf
        echo -e -n "\tIdentifier \"system-keyboard\"\n" >> /tmp/00-keyboard.conf
        echo -e -n "\tMatchIsKeyboard \"on\"\n" >> /tmp/00-keyboard.conf
        echo -e -n "\tOption \"XkbLayout\" \"$xkb_layout\"\n" >> /tmp/00-keyboard.conf
        echo -e -n "\tOption \"XkbModel\" \"$xkb_model\"\n" >> /tmp/00-keyboard.conf
        echo -e -n "\tOption \"XkbVariant\" \"$xkb_variant\"\n" >> /tmp/00-keyboard.conf
        echo -e -n "\tOption \"XKbOptions\" \"$xkb_options\"\n" >> /tmp/00-keyboard.conf
        echo -e -n "EndSection\n" >> /tmp/00-keyboard.conf
    }
    
    if [[ $SUB_MENU != "set_xkbmap" ]]; then
       SUB_MENU="set_xkbmap"
       HIGHLIGHT_SUB=1
    else
       if [[ $HIGHLIGHT_SUB != 4 ]]; then
          HIGHLIGHT_SUB=$(( HIGHLIGHT_SUB + 1 ))
       fi
    fi
    
   # dialog --default-item ${HIGHLIGHT_SUB} --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_xkb_menu_title" --menu "$_xkb_menu_body" 0 0 5 \
   # "1" "* $_xkb_layout_menu" \
   # "2" "$_xkb_model_menu" \
   # "3" "$_xkb_variant_menu" \
   # "4" "$_xkb_options_menu" \
   # "5" "$_Back" 2>${ANSWER}
   dialog --default-item ${HIGHLIGHT_SUB} --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_xkb_menu_title" --menu "$_xkb_menu_body" 0 0 5 \
    "1" "$_xkb_model_menu" \
    "2" "$_xkb_variant_menu" \
    "3" "$_xkb_options_menu" \
    "4" "$_Back" 2>${ANSWER}
    
    HIGHLIGHT_SUB=$(cat ${ANSWER})
    case $(cat ${ANSWER}) in
   # "1") xkblayout
   #      ;;
    "1") dialog --defaultno --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_yesno_xkb_model_title" --yesno "$_yesno_xkb_model_body" 0 0
        if [[ $? -eq 0 ]]; then
            xkbmodel
        else
            xkb_model="pc105"
        fi
         ;;
    "2") dialog --defaultno --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_yesno_variant_title" --yesno "$_yesno_varinant_body" 0 0
        if [[ $? -eq 0 ]]; then
            xkbvariant
        else
            xkb_variant="qwerty"
        fi
        ;;
    "3") dialog --defaultno --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_yesno_options_title" --yesno "$_yesno_options_body" 0 0
        if [[ $? -eq 0 ]]; then
            xkboptions
        else
            xkb_options="grp:ctrl_shift_toggle,grp_led:num"
        fi
        ;;
      *) fine_keyboard_conf 
        config_base_menu
         ;;
    esac

    set_xkbmap
}

# locale array generation code adapted from the Manjaro 0.8 installer
set_locale() {
  
  sed -i '/^[a-z]/s/^/#/g' ${MOUNTPOINT}/etc/locale.gen
  
  LOCALES=""    
  for i in $(cat /etc/locale.gen | grep -v "#  " | sed 's/#//g' | sed 's/ UTF-8//g' | grep .UTF-8); do
      LOCALES="${LOCALES} ${i} -"
  done

  dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_LocateTitle" --menu "$_localeBody" 0 0 16 ${LOCALES} 2>${ANSWER} || config_base_menu 
  LOCALE=$(cat ${ANSWER})
    
  # _KEYMAP=$(echo "${LOCALE}" | sed 's/_.*//')
  _KEYMAP=""
   for i in $(ls -R /usr/share/kbd/keymaps | grep "map.gz" | sed 's/\.map.gz//g' | sort); do
    _KEYMAP="${_KEYMAP} ${i} -"
   done

   clear
   
   dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_LocaleConsoleTitle" \
  --menu "$_LocaleConsoleBody" 20 40 16 ${_KEYMAP} 2>${ANSWER} || prep_menu 
   _KEYMAP=$(cat ${ANSWER})
   
  _user_local=$(echo "${LOCALE}" | sed 's/_.*//')
  
  echo "LANG=\"${LOCALE}\"" > ${MOUNTPOINT}/etc/locale.conf
  echo "LC_MESSAGES=\"${LOCALE}\"" >> ${MOUNTPOINT}/etc/locale.conf
  sed -i "s/#${LOCALE}/${LOCALE}/" ${MOUNTPOINT}/etc/locale.gen 2>/tmp/.errlog
  arch_chroot "loadkeys ${_KEYMAP}" >/dev/null 2>>/tmp/.errlog
  echo "LOCALE=\"${LOCALE}\"" > ${MOUNTPOINT}/etc/vconsole.conf
  echo "KEYMAP=\"${_KEYMAP}\"" >> ${MOUNTPOINT}/etc/vconsole.conf
  [[ ${_KEYMAP} =~ ^(ru) ]] && FONT="cyr-sun16"
  if [[ $FONT != "" ]]; then
    echo "FONT=\"${FONT}\"" >> ${MOUNTPOINT}/etc/vconsole.conf
    echo "CONSOLEFONT=\"${FONT}\"" >> ${MOUNTPOINT}/etc/vconsole.conf
    arch_chroot "setfont ${FONT}" >/dev/null 2>>/tmp/.errlog
  else
    echo "FONT=\"cyr-sun16\"" >> ${MOUNTPOINT}/etc/vconsole.conf
    echo "CONSOLEFONT=\"cyr-sun16\"" >> ${MOUNTPOINT}/etc/vconsole.conf
    arch_chroot "setfont cyr-sun16" >/dev/null 2>>/tmp/.errlog
  fi
  echo "USECOLOR=\"yes\"" >> ${MOUNTPOINT}/etc/vconsole.conf
  arch_chroot "locale-gen" >/dev/null 2>>/tmp/.errlog
  arch_chroot "export Lang=\"${LOCALE}\"" >/dev/null 2>>/tmp/.errlog
  [[ ${ZONE[*]} != "" ]] && [[ ${SUBZONE[*]} != "" ]] && echo "TIMEZONE=\"${ZONE}/${SUBZONE}\"" >> ${MOUNTPOINT}/etc/vconsole.conf
  [[ ${_sethwclock[*]} != "" ]] && echo "HARDWARECLOCK=\"${_sethwclock}\"" >> ${MOUNTPOINT}/etc/vconsole.conf
  echo "CONSOLEMAP=\"\"" >> ${MOUNTPOINT}/etc/vconsole.conf
  check_for_error
}

# Set Zone and Sub-Zone
set_timezone() {

    ZONE=""
    for i in $(cat /usr/share/zoneinfo/zone.tab | awk '{print $3}' | grep "/" | sed "s/\/.*//g" | sort -ud); do
      ZONE="$ZONE ${i} -"
    done
    
     dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_TimeZTitle" --menu "$_TimeZBody" 0 0 10 ${ZONE} 2>${ANSWER} || config_base_menu
     ZONE=$(cat ${ANSWER}) 
    
     SUBZONE=""
     for i in $(cat /usr/share/zoneinfo/zone.tab | awk '{print $3}' | grep "${ZONE}/" | sed "s/${ZONE}\///g" | sort -ud); do
        SUBZONE="$SUBZONE ${i} -"
     done
         
     dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_TimeSubZTitle" --menu "$_TimeSubZBody" 0 0 11 ${SUBZONE} 2>${ANSWER} || config_base_menu
     SUBZONE=$(cat ${ANSWER}) 
    
     dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --yesno "$_TimeZQ ${ZONE}/${SUBZONE} ?" 0 0 
     
     if [[ $? -eq 0 ]]; then
        arch_chroot "ln -s /usr/share/zoneinfo/${ZONE}/${SUBZONE} /etc/localtime" 2>/tmp/.errlog
        check_for_error
     else
        config_base_menu
     fi
}

set_hw_clock() {
    
   dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_HwCTitle" \
    --menu "$_HwCBody" 0 0 2 \
    "1" "$_HwCUTC" \
    "2" "$_HwLocal" 2>${ANSWER} 

    case $(cat ${ANSWER}) in
        "1") arch_chroot "hwclock --systohc --utc"  2>/tmp/.errlog
            _sethwclock="UTC"
             ;;
        "2") arch_chroot "hwclock --systohc --localtime" 2>/tmp/.errlog
            _sethwclock="localtime"
             ;;
          *) config_base_menu
             ;;
     esac   
     
     check_for_error
}

# Adapted from AIS. As with some other functions, decided that keeping the numbering for options
# was worth repeating portions of code.
generate_fstab() {

    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_FstabTitle" \
    --menu "$_FstabBody" 0 0 3 \
    "1" "$_FstabDev" \
    "2" "$_FstabLabel" \
    "3" "$_FstabUUID" 2>${ANSWER}

    case $(cat ${ANSWER}) in
        "1") genfstab -p ${MOUNTPOINT} >> ${MOUNTPOINT}/etc/fstab 2>/tmp/.errlog
             ;;
        "2") genfstab -L -p ${MOUNTPOINT} >> ${MOUNTPOINT}/etc/fstab 2>/tmp/.errlog
             ;;
        "3") if [[ $SYSTEM == "UEFI" ]]; then
                genfstab -t PARTUUID -p ${MOUNTPOINT} >> ${MOUNTPOINT}/etc/fstab 2>/tmp/.errlog
             else 
                genfstab -U -p ${MOUNTPOINT} >> ${MOUNTPOINT}/etc/fstab 2>/tmp/.errlog
             fi
             ;;
          *) config_base_menu
             ;;
    esac

    check_for_error

    [[ -f ${MOUNTPOINT}/swapfile ]] && sed -i "s/\\${MOUNTPOINT}//" ${MOUNTPOINT}/etc/fstab

}

# Adapted from AIS.
set_hostname() {

   dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_HostNameTitle" --inputbox "$_HostNameBody" 0 0 "arch" 2>${ANSWER} || config_base_menu
   HOST_NAME=$(cat ${ANSWER})

   echo "$HOST_NAME" > ${MOUNTPOINT}/etc/hostname 2>/tmp/.errlog
   check_for_error
   echo -e "#<ip-address>\t<hostname.domain.org>\t<hostname>\n127.0.0.1\tlocalhost.localdomain\tlocalhost\t${HOST_NAME}\n::1\tlocalhost.localdomain\tlocalhost\t${HOST_NAME}" > ${MOUNTPOINT}/etc/hosts
}

# Adapted and simplified from the Manjaro 0.8 and Antergos 2.0 installers
set_root_password() {

    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_PassRtTitle" --clear --insecure --passwordbox "$_PassRtBody" 0 0 2> ${ANSWER} || config_user_menu
    PASSWD=$(cat ${ANSWER})
    
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_PassRtTitle" --clear --insecure --passwordbox "$_PassRtBody2" 0 0 2> ${ANSWER} || config_user_menu
    PASSWD2=$(cat ${ANSWER})
    
    if [[ $PASSWD == $PASSWD2 ]]; then 
       echo -e "${PASSWD}\n${PASSWD}" > /tmp/.passwd
       arch_chroot "passwd root" < /tmp/.passwd >/dev/null 2>/tmp/.errlog
       rm /tmp/.passwd
       check_for_error
    else
       dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_PassRtErrTitle" --msgbox "$_PassRtErrBody" 0 0
       set_root_password
    fi

}

# Users and groups
usgr_to_sel() {
    
   dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_ug_select_ttl" \
    --checklist "$ug_select_bd" 0 0 16 \
    "${_us_gr_users[0]}" "$_ugd_adm" "OFF" \
    "${_us_gr_users[1]}" "$_ugd_ftp" "ON" \
    "${_us_gr_users[2]}" "$_ugd_games" "OFF" \
    "${_us_gr_users[3]}" "$_ugd_http" "ON" \
    "${_us_gr_users[4]}" "$_ugd_log" "ON" \
    "${_us_gr_users[5]}" "$_ugd_rfkill" "ON" \
    "${_us_gr_users[6]}" "$_ugd_sys" "ON" \
    "${_us_gr_users[7]}" "$_ugd_systemd_journal" "OFF" \
    "${_us_gr_users[8]}" "$_ugd_users" "ON" \
    "${_us_gr_users[9]}" "$_ugd_uucp" "OFF" \
    "${_us_gr_users[10]}" "$_ugd_wheel" "ON" \
    "${_us_gr_system[0]}" "$_ugd_dbus" "OFF" \
    "${_us_gr_system[1]}" "$_ugd_kmem" "OFF" \
    "${_us_gr_system[2]}" "$_ugd_locate" "OFF" \
    "${_us_gr_system[3]}" "$_ugd_lp" "ON" \
    "${_us_gr_system[4]}" "$_ugd_mail" "OFF" \
    "${_us_gr_system[5]}" "$_ugd_nobody" "OFF" \
    "${_us_gr_system[6]}" "$_ugd_proc" "OFF" \
    "${_us_gr_system[7]}" "$_ugd_smmsp" "OFF" \
    "${_us_gr_system[8]}" "$_ugd_tty" "OFF" \
    "${_us_gr_system[9]}" "$_ugd_utmp" "OFF" \
    "${_us_gr_presystemd[0]}" "$_ugd_audio" "ON" \
    "${_us_gr_presystemd[1]}" "$_ugd_disk" "ON" \
    "${_us_gr_presystemd[2]}" "$_ugd_floppy" "ON" \
    "${_us_gr_presystemd[3]}" "$_ugd_input" "ON" \
    "${_us_gr_presystemd[4]}" "$_ugd_kvm" "OFF" \
    "${_us_gr_presystemd[5]}" "$_ugd_optical" "ON" \
    "${_us_gr_presystemd[6]}" "$_ugd_scanner" "ON" \
    "${_us_gr_presystemd[7]}" "$_ugd_storage" "ON" \
    "${_us_gr_presystemd[8]}" "$_ugd_video" "ON" 2>${ANSWER}
    _ugch=$(cat ${ANSWER})
}

# Originally adapted from the Antergos 2.0 installer
create_new_user() {

        dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_NUsrTitle" --inputbox "$_NUsrBody" 0 0 "" 2>${ANSWER} || config_user_menu
        USER=$(cat ${ANSWER})
        
        # Loop while user name is blank, has spaces, or has capital letters in it.
        while [[ ${#USER} -eq 0 ]] || [[ $USER =~ \ |\' ]] || [[ $USER =~ [^a-z0-9\ ] ]]; do
              dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_NUsrTitle" --inputbox "$_NUsrErrBody" 0 0 "" 2>${ANSWER} || config_user_menu
              USER=$(cat ${ANSWER})
        done
        _ugch=""
        usgr_to_sel
        # Enter password. This step will only be reached where the loop has been skipped or broken.
        dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_PassNUsrTitle" --clear --insecure --passwordbox "$_PassNUsrBody $USER\n\n" 0 0 2> ${ANSWER} || config_user_menu
        PASSWD=$(cat ${ANSWER}) 
    
        dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_PassNUsrTitle" --clear --insecure --passwordbox "$_PassNUsrBody2 $USER\n\n" 0 0 2> ${ANSWER} || config_user_menu
        PASSWD2=$(cat ${ANSWER}) 
    
        # loop while passwords entered do not match.
        while [[ $PASSWD != $PASSWD2 ]]; do
              dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_PassNUsrErrTitle" --msgbox "$_PassNUsrErrBody" 0 0
              
              dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_PassNUsrTitle" --clear --insecure --passwordbox "$_PassNUsrBody $USER\n\n" 0 0 2> ${ANSWER} || config_user_menu
              PASSWD=$(cat ${ANSWER}) 
    
              dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_PassNUsrTitle" --clear --insecure --passwordbox "$_PassNUsrBody2 $USER\n\n" 0 0 2> ${ANSWER} || config_user_menu
              PASSWD2=$(cat ${ANSWER}) 
        done      
    
        # create new user. This step will only be reached where the password loop has been skipped or broken.  
        dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_NUsrSetTitle" --infobox "$_NUsrSetBody" 0 0
        sleep 2
        # Create the user, set password, then remove temporary password file
        # arch_chroot "useradd ${USER} -m -g users -G disk,wheel,storage,power,network,video,audio,lp,games,optical,scanner,floppy,log,rfkill,ftp,http,sys,input -s /bin/bash" 2>/tmp/.errlog
        arch_chroot "useradd ${USER} -m -g users -G wheel,power,users -s /bin/bash" 2>>/tmp/.errlog
        wait
        if [[ ${_ugch[*]} != "" ]]; then
           for k in ${_ugch[*]}; do
              arch-chroot $MOUNTPOINT /bin/bash -c "gpasswd -a ${USER} $k" 2>>/tmp/.errlog
              wait
           done
        fi
        wait
        check_for_error
        unset _ugch
        echo -e "${PASSWD}\n${PASSWD}" > /tmp/.passwd
        arch_chroot "passwd ${USER}" < /tmp/.passwd >/dev/null 2>/tmp/.errlog
        rm /tmp/.passwd
        check_for_error
        # Set up basic configuration files and permissions for user
        arch_chroot "cp /etc/skel/.bashrc /home/${USER}"
        arch_chroot "chown -R ${USER}:users /home/${USER}"
        sed -i '/%wheel ALL=(ALL) ALL/s/^#//' ${MOUNTPOINT}/etc/sudoers
      
}

run_mkinitcpio() {
    
  clear
  
  # If $LVM is being used, add the lvm2 hook
  [[ $LVM -eq 1 ]] && sed -i 's/block filesystems/block lvm2 filesystems/g' ${MOUNTPOINT}/etc/mkinitcpio.conf
    
  # Amend command depending on whether LTS kernel was installed or not
  [[ $LTS -eq 1 ]] && arch_chroot "mkinitcpio -P" 2>/tmp/.errlog || arch_chroot "mkinitcpio -P" 2>/tmp/.errlog
  check_for_error
 
}
