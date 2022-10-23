#!/bin/bash
#
######################################################################
##                                                                  ##
##                    GEP Functions                                 ##
##                                                                  ##
######################################################################  

install_gengen()
{
    _gengen_menu=""
    if [[ $_gengen_once == "0" ]]; then
        _gengen_once=1
        clear
        info_search_pkg
        _list_general_pkg=$(check_s_lst_pkg "${_general_pkg[*]}")
        wait
        _gengen_menu=""
        for i in ${_list_general_pkg[*]}; do
            _gengen_menu="${_gengen_menu} ${i} - on"
        done
        wait
        clear
    fi
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_menu_gengen" --checklist "$_ch_mn_bd" 0 0 16 ${_gengen_menu} 2>${ANSWER}
    _ch_gengen=$(cat ${ANSWER})
    clear
    [[ ${_ch_gengen[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_ch_gengen[*]} 2>/tmp/.errlog
    arch_chroot "systemctl enable acpid avahi-daemon cronie org.cups.cupsd.service systemd-timesyncd.service" 2>/tmp/.errlog
    check_for_error
    wait
}

install_archivers()
{
    if [[ $_archivers_once == "0" ]]; then
        _archivers_once=1
        clear
        info_search_pkg
        _list_archivers_pkg=$(check_s_lst_pkg "${_archivers_pkg[*]}")
        wait
        _clist_archivers_pkg=$(check_q_lst_pkg "${_list_archivers_pkg[*]}")
        wait
        for i in ${_clist_archivers_pkg[*]}; do
            archivers_menu="${archivers_menu} ${i} - on"
        done
        wait
        clear
    fi
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_menu_archivers" --checklist "$_ch_mn_bd" 0 0 16 ${archivers_menu} 2>${ANSWER}
    _ch_archivers=$(cat ${ANSWER})
    clear
    [[ ${_ch_archivers[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_ch_archivers[*]} 2>/tmp/.errlog
}

install_ttftheme()
{
    if [[ $_ttf_once == "0" ]]; then
        _ttf_once=1
        clear
        info_search_pkg
        _list_ttf_theme_pkg=$(check_s_lst_pkg "${_ttf_theme_pkg[*]}")
        wait
        _clist_ttf_theme_pkg=$(check_q_lst_pkg "${_list_ttf_theme_pkg[*]}")
        wait
        for i in ${_clist_ttf_theme_pkg[*]}; do
            _ttf_menu="${_ttf_menu} ${i} - on"
        done
        wait
        clear
    fi
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_menu_ttf_theme" --checklist "$_ch_mn_bd" 0 0 16 ${_ttf_menu} 2>${ANSWER}
    _ch_ttf=$(cat ${ANSWER})
    clear
    [[ ${_ch_ttf[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_ch_ttf[*]} 2>/tmp/.errlog
    check_for_error
    wait
    icontheme_configuration
    wait
    # fonts_configuration
    # wait
}

install_standartpkg()
{
    if [[ $_stpkg_once == "0" ]]; then
        _stpkg_once=1
        clear
        info_search_pkg
        _list_gr_editor=$(check_s_lst_pkg "${_gr_editor[*]}")
        wait
        [[ ${_list_gr_editor[*]} != "" ]] && _tr_gr_editor=$(search_translit_pkg "${_gr_editor[*]}" "$_user_local")
        wait
        [[ ${_tr_gr_editor[*]} != "" ]] && _list_gr_editor="${_list_gr_editor} ${_tr_gr_editor[*]}"
        _list_office=$(check_s_lst_pkg "${_office}")
        wait
        [[ ${_list_office[*]} != "" ]] && _tr_office=$(search_translit_pkg "${_office}" "$_user_local")
        wait
        [[ ${_tr_office[*]} != "" ]] && _list_office="${_list_office} ${_tr_office[*]}"
        _list_minimal_pkg=$(check_s_lst_pkg "${_minimal_pkg[*]}")
        wait
        [[ ${_list_gr_editor[*]} != "" ]] && _list_minimal_pkg="${_list_minimal_pkg} ${_list_gr_editor[*]}"
        [[ ${_list_office[*]} != "" ]] && _list_minimal_pkg="${_list_minimal_pkg} ${_list_office[*]}"
        wait
        _clist_minimal_pkg=$(check_q_lst_pkg "${_list_minimal_pkg[*]}")
        wait
        for i in ${_clist_minimal_pkg[*]}; do
            _standart_pkg_menu="${_standart_pkg_menu} ${i} - on"
        done
        _standart_pkg_menu="${_standart_pkg_menu} ${_gr_editor[*]} - on"
        wait
        clear
    fi
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_menu_add_pkg" --checklist "$_ch_mn_bd" 0 0 16 ${_standart_pkg_menu} 2>${ANSWER}
    _ch_standart_pkg=$(cat ${ANSWER})
    clear
    [[ ${_ch_standart_pkg[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_ch_standart_pkg[*]} 2>/tmp/.errlog
}
