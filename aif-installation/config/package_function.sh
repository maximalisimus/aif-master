#!/bin/bash
pkg_aur_start()
{
     check_dbl_list=$(find "$_aur_pkg_folder" -maxdepth 1 -type f | grep -v "windowsfonts" | rev | cut -d '/' -f1 | rev | cut -d '-' -f1 | sort | uniq -d | wc -l)
     wait
     if [[ ${check_dbl_list[*]} != "0" ]]; then
        dbl_name=$(find "$_aur_pkg_folder" -maxdepth 1 -type f | grep -v "windowsfonts" | rev | cut -d '/' -f1 | rev | cut -d '-' -f1 | sort | uniq -d)
        wait
        dbl_list=$(find "$_aur_pkg_folder" -maxdepth 1 -type f | grep -v "windowsfonts" | rev | cut -d '/' -f1 | rev | grep -v "windowsfonts" | cut -d '-' -f1 | sort | uniq -d | sed 's/$/\*/' | xargs | sed 's/ /|/g')
        wait
        all_name=$(find "$_aur_pkg_folder" -maxdepth 1 -type f | grep -v "windowsfonts" | rev | cut -d '/' -f1 | cut -d '-' -f4-11 | rev | grep -Ev "${dbl_list[*]}")
        wait
        for i in ${all_name[*]}; do
            full_name="${full_name} $i"
        done
        wait
        for i in ${dbl_name[*]}; do
            full_name="${full_name} $i"
        done
        wait
     else
        all_name=$(find "$_aur_pkg_folder" -maxdepth 1 -type f | grep -v "windowsfonts" | rev | cut -d '/' -f1 | cut -d '-' -f4-11 | rev)
        wait
        for i in ${all_name[*]}; do
            full_name="${full_name} $i"
        done
        wait
     fi
    full_menu=""
    for i in ${full_name[*]}; do
        full_menu="${full_menu} $i - off"
    done
}
aur_pkginstall()
{
    dubleaursetup()
    {
        dbl_select=$(find "$_aur_pkg_folder" -maxdepth 1 -type f -iname "$1*" | rev | cut -d '/' -f1 | cut -d '-' -f2-11 | rev |  cut -d '.' -f1-2)
        wait
        dbl_menu=""
        for j in ${dbl_select[*]}; do
            dbl_menu="${dbl_menu} $j -"
        done
        dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_aur_dbl_pkg_ttl" --menu "$_aur_dbl_pkg_bd" 0 0 16 ${dbl_menu} 2>"${ANSWER}"
        clear
        check_dbl=$(cat "${ANSWER}")
        ustanovka_pocketov "$_aur_pkg_folder" "${check_dbl[*]}"
        wait
        ### UNSET ###
        [[ ${dbl_select} ]] && unset dbl_select
        [[ ${dbl_menu} ]] && unset dbl_menu
        [[ ${check_dbl} ]] && unset check_dbl
        ### UNSET ###
    }
    simpleaursetup()
    {
        for i in ${check_name[*]}; do
            dbl_check=$(echo "$i" | grep -E "${dbl_list[*]}" | wc -l)
            wait
            if [[ ${dbl_check[*]} != "0" ]]; then
                dubleaursetup "$i"
            else
              ustanovka_pocketov "$_aur_pkg_folder" "$i"
              wait
              ### UNSET ###
              [[ ${dbl_check} ]] && unset dbl_check
              ### UNSET ###
              wait
            fi
        done
    }
    hardaursetup()
    {
        for i in ${check_name[*]}; do
            ustanovka_pocketov "$_aur_pkg_folder" "$i"
            wait
        done
    }
    if [[ $aur_pkg_once == "0" ]]; then
      aur_pkg_once=1
      info_search_pkg
      pkg_aur_start
      wait
    fi
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_aur_pkg_ttl" --checklist "$_aur_pkg_bd" 0 0 16 ${full_menu} 2>"${ANSWER}"
    clear
    check_name=$(cat "${ANSWER}")
     if [[ ${check_dbl_list[*]} != "0" ]]; then
        if [[ ${check_name[*]} != "" ]]; then
            simpleaursetup
        fi
        wait
        [[ ${dbl_check} ]] && unset dbl_check
        [[ ${check_name} ]] && unset check_name
        wait
    else
        if [[ ${check_name[*]} != "" ]]; then
            hardaursetup
        fi
        wait
        [[ ${check_name} ]] && unset check_name
     fi
}
aur_pkg_finish()
{
    ### UNSET ###
    [[ ${dbl_name} ]] && unset dbl_name
    [[ ${dbl_list} ]] && unset dbl_list
    [[ ${all_name} ]] && unset all_name
    [[ ${full_menu} ]] && unset full_menu
    [[ ${check_dbl_list} ]] && unset check_dbl_list
    ### UNSET ###
}
