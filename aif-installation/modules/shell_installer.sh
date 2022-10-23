######################################################################
##                                                                  ##
##                       SHELL SETUP                                ##
##                                                                  ##
######################################################################

# SHELL user installer

screenfetch_dialog()
{
    # Dialog yesno to screenfetch setup
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_yesno_scrfetch_ttl" --yesno "$_yesno_scrfetch_bd" 0 0
    if [[ $? -eq 0 ]]; then
       clear
        info_search_pkg
        _list_scr_strtp=$(check_s_lst_pkg "${_screen_startup[*]}")
        wait
        _scrnf_once=1
        clear
        [[ ${_list_scr_strtp[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_list_scr_strtp[*]} 2>/tmp/.errlog
        clear
    fi
}
select_install_shell()
{
	if [[ $_once_slin_shll == "0" ]]; then
		_once_slin_shll=1
		clear
		info_search_pkg
		_list_shells_sh=$(check_s_lst_pkg "${_shells_sh[*]}")
		wait
		_list_bash_sh=$(check_s_lst_pkg "${_bash_sh[*]}")
		wait
		_list_zsh_sh=$(check_s_lst_pkg "${_zsh_sh[*]}")
		wait
		clear
		_mn_shll_sh=""
		for k in ${_list_shells_sh[*]}; do
			_mn_shll_sh="${_mn_shll_sh} $k -"
		done
	fi
    # Select dialog shell
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_select_shell_menu_ttl" --menu "$_select_shell_menu_bd $1\n" 0 0 7 ${_mn_shll_sh} 2>${ANSWER}
    variable=$(cat ${ANSWER})
    clear
    pacstrap ${MOUNTPOINT} ${variable[*]} 2>/tmp/.errlog
    wait
    check_for_error
    if [[ ${variable[*]} == "bash" ]]; then
		[[ ${_list_bash_sh[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_list_bash_sh[*]} 2>/tmp/.errlog
		wait
		check_for_error
		arch-chroot $MOUNTPOINT /bin/bash -c "chsh -s /bin/bash $1" 2>/tmp/.errlog
    elif [[ ${variable[*]} == "zsh" ]]; then
		[[ ${_list_zsh_sh[*]} != "" ]] && pacstrap ${MOUNTPOINT} ${_list_zsh_sh[*]} 2>/tmp/.errlog
		wait
		check_for_error
		arch-chroot $MOUNTPOINT /bin/bash -c "chsh -s /usr/bin/zsh $1" 2>/tmp/.errlog
    else
		arch-chroot $MOUNTPOINT /bin/bash -c "chsh -s /usr/bin/${variable[*]} $1" 2>/tmp/.errlog
    fi
    wait
    check_for_error
}
gpg_conf(){
	mkdir -p ${MOUNTPOINT}/home/${1}/.gnupg/
	touch ${MOUNTPOINT}/home/${1}/.gnupg/gpg.conf
	echo "keyid-format 0xshort" > ${MOUNTPOINT}/home/${1}/.gnupg/gpg.conf
	echo "throw-keyids" >> ${MOUNTPOINT}/home/${1}/.gnupg/gpg.conf
	echo "no-emit-version" >> ${MOUNTPOINT}/home/${1}/.gnupg/gpg.conf
	echo "no-comments" >> ${MOUNTPOINT}/home/${1}/.gnupg/gpg.conf
	
}

shell_friendly_setup()
{
    if [[ $_once_conf_fscr == "0" ]]; then
        _once_conf_fscr=1
        echo "alias ls='ls --color=auto'" >> ${MOUNTPOINT}/etc/bash.bashrc
        _usr_list=$(ls ${MOUNTPOINT}/home/ | sed "s/lost+found//")
        _usr_lst_menu=""
        for i in ${_usr_list[*]}; do
            _usr_lst_menu="${_usr_lst_menu} $i - on"
            echo "alias ls='ls --color=auto'" >> ${MOUNTPOINT}/home/$i/.bashrc
        done
        screenfetch_dialog
    fi
    # Checklist dialog user
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_menu_ch_usr_ttl" --checklist "$_menu_ch_usr_bd" 0 0 16 ${_usr_lst_menu} 2>${ANSWER}
    _ch_usr=$(cat ${ANSWER})
    if [[ ${_ch_usr[*]} != "" ]]; then
        for i in ${_ch_usr[*]}; do
            select_install_shell "$i"
            gpg_conf "${i}"
        done
	fi
}
