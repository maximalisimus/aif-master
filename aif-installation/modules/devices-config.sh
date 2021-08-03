######################################################################
##                                                                  ##
##                     Devices config                               ##
##                                                                  ##
######################################################################

# User installer to device config parameters

select_mountpoint()
{
    devices_list=$(lsblk -l | sed '/SWAP/d' | grep -Ei "$1" | awk 'BEGIN{OFS=" "} {print $1,$4}')
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_sh_dev_title" --menu "$_sh_dev_body" 0 0 4 ${devices_list} 2>${ANSWER}
    DEVICES=$(cat ${ANSWER})
}
showmemory()
{
    if [[ $_once_shwram == "0" ]]; then
        rm -rf ${_mem_file}
        _freefile=( $(free -h) )
        IFS=$' '
        show_memory
        _once_shwram=1
    fi
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_free_info" --textbox ${_mem_file} 15 100
    clear
}
function reserved_block()
{
    _block_count=$(tune2fs -l $1 | grep -Ei "^(Block count:)" | sed 's/Block count://' | tr -d ' ')
    _reserved_block_count=$(tune2fs -l $1 | grep -Ei "^(Reserved block count:)" | sed 's/Reserved block count://' | tr -d ' ')
    bc=${_block_count[*]}
    unset _block_count
    rbc=${_reserved_block_count[*]}
    unset _reserved_block_count
    _reserv_procent=$(awk 'BEGIN{print ('"$rbc"'*100/'"$bc"')}' | sed 's/\./,/')
    unset bc
    unset rbc
    # round
    _rnd_reserv_procent=$(printf "%.0f" $_reserv_procent)
    unset _reserv_procent
    echo "${_rnd_reserv_procent[*]}"
}
show_block_info()
{
    deviceslist=$(lsblk -l | sed '/SWAP/d' | grep -Ei "${MOUNTPOINT}" | awk '{print $1}')
    echo "" > ${_rsrvd_file}
    for i in ${deviceslist[*]}; do
        devicessize=$(lsblk -l | sed '/SWAP/d' | grep -Ei "$i" | awk '{print $4}')
        _reserved_size=$(reserved_block "/dev/$i")
        echo -e -n "\n$_rsvd_nfo1 $i $_rsvd_nfo2 ${devicessize[*]} \n" >> ${_rsrvd_file}
        echo -e -n "$_rsvd_nfo3 $_reserved_size\n" >> ${_rsrvd_file}
    done
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_reserved_info_title" --textbox ${_rsrvd_file} 0 0
    clear
}
input_reserved_percentage()
{
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_input_reserved_title" --inputbox "$_input_reserved_body" 0 0 "" 2>${ANSWER}
    _isreserved=$(cat ${ANSWER})
}
fine_rsrvd_menu()
{
    rm -rf ${_rsrvd_file}
    rm -rf ${_mem_file}
    rm -rf ${_tmp_fstab}
    unset IFS
    unset freefile
}
rsrvd_menu()
{
    tmpfs_menu()
    {
        clear
        dialog --defaultno --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_rsrvd_menu3" --yesno "$_yesno_tmpfs_body" 0 0
        if [[ $? -eq 0 ]]; then
            dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_info_tmpfs_title" --msgbox "$_info_tmpfs_body" 0 0
            showmemory
            dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_input_size_tmpfs_title" --inputbox "$_input_size_tmpfs_body" 0 0 "" 2>${ANSWER}
            _size_tmpfs=$(cat ${ANSWER})
            sudo sed -i '/tmpfs/d' ${MOUNTPOINT}/etc/fstab 2>/tmp/.errlog
            echo "tmpfs   /tmp         tmpfs   nodev,nosuid,size=${_size_tmpfs[*]}          0  0" >> ${MOUNTPOINT}/etc/fstab 2>/tmp/.errlog
        fi
        clear
    }
    tmp_fstab_view()
    {
        cat /etc/fstab | grep -i "tmpfs" > ${_tmp_fstab}
        dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_rsrvd_menu3" --textbox ${_tmp_fstab} 0 0
    }
    tune2fs_menu()
    {
        clear
        select_mountpoint "${MOUNTPOINT}"
        input_reserved_percentage
        if [[ ${_isreserved[*]} -le 10 ]]; then
            if [[ ${_isreserved[*]} -ge 1 ]]; then
                sudo tune2fs -m ${_isreserved[*]} /dev/$DEVICES 2>/tmp/.errlog
                clear
            else echo "Error size paramter at 1 to 10" > /tmp/.errlog
            fi
        else echo "Error size paramter at 1 to 10" > /tmp/.errlog
        fi
    }
    if [[ $SUB_MENU != "rsrvd_menu" ]]; then
       SUB_MENU="rsrvd_menu"
       HIGHLIGHT_SUB=1
    else
       if [[ $HIGHLIGHT_SUB != 5 ]]; then
          HIGHLIGHT_SUB=$(( HIGHLIGHT_SUB + 1 ))
       fi
    fi
    dialog --default-item ${HIGHLIGHT_SUB} --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_rsrvd_menu_title" --menu "$_rsrvd_menu_body" 0 0 5 \
    "1" "$_rsrvd_menu1" \
    "2" "$_rsrvd_menu2" \
    "3" "$_rsrvd_menu3" \
    "4" "$_rsrvd_menu4" \
    "5" "$_Back" 2>${ANSWER} # $_Back
    
    HIGHLIGHT_SUB=$(cat ${ANSWER})
    case $(cat ${ANSWER}) in
    "1") show_block_info
         ;;
    "2") tune2fs_menu
         ;;     
    "3") tmp_fstab_view
        ;;
    "4") tmpfs_menu
        ;;
      *) # Back to NAME Menu
        fine_rsrvd_menu
        main_menu_online
         ;;
    esac
    check_for_error
    rsrvd_menu
}
