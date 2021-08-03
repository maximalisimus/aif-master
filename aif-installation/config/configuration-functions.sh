######################################################################
##                                                                  ##
##                   Configuration functions                        ##
##                                                                  ##
######################################################################

pc_conf_prcss()
{
    echo "#" > "$2"
    while read line; do
        if [[ $line == "#[multilib]" ]]; then
            _next=1
            echo "[multilib]" >> "$2"
            echo "Include = /etc/pacman.d/mirrorlist" >> "$2"
        else
            if [[ $_next == "1" ]]; then
                _next=0
                continue
            else
                echo "$line" >> "$2"
            fi
        fi
    done < "$1"
    cp -f "$2" "$1"
}

multilib_question()
{
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_yesno_multilib_title" --yesno "$_yesno_multilib_body" 0 0

    if [[ $? -eq 0 ]]; then
       pc_conf_prcss "$_pcm_conff" "$_pcm_tempf"
       _multilib=1
    else
        _multilib=0
    fi
}

mirrorlist_question()
{
    dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_MirrorlistTitle" --yesno "$_yesno_mirrorlist_body" 0 0

    if [[ $? -eq 0 ]]; then
        sudo cp -f /etc/pacman.d/mirrorlist ${MOUNTPOINT}/etc/pacman.d/mirrorlist
    fi
}
