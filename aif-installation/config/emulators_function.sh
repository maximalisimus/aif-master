#!/bin/bash
pkgemlstart()
{
   clear
   info_search_pkg
   _list_emulator_packages=$(check_s_lst_pkg "${emulator_packages[*]}")
   wait
   else_eml_package_list=$(echo "${_list_emulator_packages[*]}" | xargs | sed 's/ /|/g')
   wait
   #unset else_eml_package_lst
   eml_check_dbl_list=$(find "$_eml_folder" -maxdepth 1 -type f | grep -v "windowsfonts" | rev | cut -d '/' -f1 | rev | cut -d '-' -f1 | sort | uniq -d | wc -l)
   wait
    if [[ ${eml_check_dbl_list[*]} != "0" ]]; then
        eml_dbl_name=$(find "$_eml_folder" -maxdepth 1 -type f | grep -v "windowsfonts" | rev | cut -d '/' -f1 | rev | cut -d '-' -f1 | sort | uniq -d)
        wait
        eml_dbl_list=$(find "$_eml_folder" -maxdepth 1 -type f | grep -v "windowsfonts" | rev | cut -d '/' -f1 | rev | grep -v "windowsfonts" | cut -d '-' -f1 | sort | uniq -d | sed 's/$/\*/' | xargs | sed 's/ /|/g')
        wait
        eml_all_name=$(find "$_eml_folder" -maxdepth 1 -type f | grep -v "windowsfonts" | rev | cut -d '/' -f1 | cut -d '-' -f4-11 | rev | grep -Ev "${eml_dbl_list[*]}" | grep -Ev "${else_eml_package_list[*]}")
        wait
        for i in ${eml_all_name[*]}; do
            eml_full_name="${eml_full_name} $i"
        done
        wait
        for i in ${eml_dbl_name[*]}; do
            eml_full_name="${eml_full_name} $i"
        done
        wait
      for i in ${_list_emulator_packages[*]}; do
            eml_full_name="${eml_full_name} $i"
        done
        wait
     else
        eml_all_name=$(find "$_eml_folder" -maxdepth 1 -type f | grep -v "windowsfonts" | rev | cut -d '/' -f1 | cut -d '-' -f4-11 | rev | grep -Ev "${else_eml_package_list[*]}")
        wait
        for i in ${eml_all_name[*]}; do
            eml_full_name="${eml_full_name} $i"
        done
        wait
        for i in ${_list_emulator_packages[*]}; do
            eml_full_name="${eml_full_name} $i"
        done
        wait
     fi
    for i in ${eml_full_name[*]}; do
        full_eml_menu="${full_eml_menu} $i - off"
    done
}
eml_ustanovka()
{
    emlpkg_setup()
    {
        ch_eml_package=$(echo "$1" | grep -E "${else_eml_package_list[*]}" | wc -l)
        wait
        if [[ ${ch_eml_package[*]} != "0" ]]; then
            pacstrap ${MOUNTPOINT} $1 2>/tmp/.errlog
            check_for_error
        else
            ustanovka_pocketov "$_eml_folder" "$1"
        fi
        wait
        [[ ${ch_eml_package[*]} ]] && unset ch_eml_package
    }
    dubleeml_setup()
    {
        eml_dbl_select=$(find "$_eml_folder" -maxdepth 1 -type f -iname "$1*" | rev | cut -d '/' -f1 | cut -d '-' -f2-11 | rev |  cut -d '.' -f1-2)
        wait
        eml_dbl_menu=""
        for j in ${eml_dbl_select[*]}; do
            eml_dbl_menu="${eml_dbl_menu} $j -"
        done
        dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_aur_dbl_pkg_ttl" --menu "$_aur_dbl_pkg_bd" 0 0 16 ${eml_dbl_menu} 2>"${ANSWER}"
        clear
        check_eml_dbl=$(cat "${ANSWER}")
        ustanovka_pocketov "$_eml_folder" "${check_eml_dbl[*]}"
        wait
        ### UNSET ###
        [[ ${eml_dbl_select} ]] && unset eml_dbl_select
        [[ ${eml_dbl_menu} ]] && unset eml_dbl_menu
        [[ ${check_eml_dbl} ]] && unset check_eml_dbl
    }
    hardeml_setup()
    {
        for j in ${check_eml_name[*]}; do
            emlpkg_setup "$j"
        done
    }
    simpleeml_setup()
    {
        for i in ${check_eml_name[*]}; do
            ch_emldbl=$(echo "$i" | grep -E "${eml_dbl_list[*]}" | wc -l)
            if [[ ${ch_emldbl[*]} != "0" ]]; then
                dubleeml_setup "$i"
            else
                emlpkg_setup "$i"
            fi
            [[ ${ch_emldbl[*]} ]] && unset ch_emldbl
        done
    }
   clear
   if [[ $_eml_pkg_once == "0" ]]; then
     _eml_pkg_once=1
     info_search_pkg
     pkgemlstart
   fi
   dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_eml_pkg_ttl" --checklist "$_eml_pkg_bd" 0 0 16 ${full_eml_menu} 2>"${ANSWER}"
   clear
   check_eml_name=$(cat "${ANSWER}")
    if [[ ${eml_check_dbl_list[*]} != "0" ]]; then
        if [[ ${check_eml_name[*]} != "" ]]; then
            simpleeml_setup
        fi
    else
        if [[ ${check_eml_name[*]} != "" ]]; then
            hardeml_setup
        fi
    fi
    wait
    [[ ${check_eml_name[*]} ]] && unset check_eml_name
}
eml_zavershenie()
{
    ### UNSET ###
    [[ ${else_eml_package_list[*]} ]] && unset else_eml_package_list
    [[ ${eml_check_dbl_list[*]} ]] && unset eml_check_dbl_list
    [[ ${eml_dbl_name[*]} ]] && eml_dbl_name
    [[ ${eml_dbl_list[*]} ]] && unset eml_dbl_list
    [[ ${eml_all_name[*]} ]] && unset eml_all_name
    [[ ${eml_full_name[*]} ]] && unset eml_full_name
    [[ ${full_eml_menu[*]} ]] && unset full_eml_menu
    [[ ${_list_emulator_packages[*]} ]] && unset _list_emulator_packages
    ### UNSET ###
}

