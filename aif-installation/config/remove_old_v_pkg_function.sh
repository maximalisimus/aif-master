#!/bin/bash
compare_versions()
{
   v1=$(echo "$1" | sed 's/[^0-9]//g')
   v2=$(echo "$2" | sed 's/[^0-9]//g')
   if [[ $v1 -gt $v2 ]]; then
        # if v1 > v2
        echo "1"
   elif [[ $v1 -lt $v2 ]]; then
        # if v1 < v2
        echo "2"
   else
        # if v1 = v2
        echo "0"
   fi
}
function find_old_version()
{
    local array
    old_v_n=$(find "$1" -maxdepth 1 -type f | rev | cut -d '/' -f1 | rev | grep -v "windowsfonts" | rev | cut -d '-' -f4-11 | rev | sort | uniq -d | awk '!/^$/{print $0}')
    array_v=""
    temp=""
    result=""
    count=0
    for i in ${old_v_n[*]}; do
        [ -f ./temp.txt ] && rm -rf ./temp.txt
        find "$1" -maxdepth 1 -type f | rev | cut -d '/' -f1 | rev | grep -v "windowsfonts" | grep "$i" | rev | cut -d '-' -f2-3 | rev | awk '!/^$/{print $0}' >> ./temp.txt
        wait
        while read line; do
            array_v+=($line)
        done < ./temp.txt
        wait
        if [[ $count -eq 0 ]]; then
            temp=$(compare_versions "${array_v[1]}" "${array_v[2]}")
            wait
            if [[ $temp == 1 ]]; then
                result="${array_v[2]}"
            else
                result="${array_v[1]}"
            fi
        else 
            temp=$(compare_versions "${array_v[0]}" "${array_v[1]}")
            wait
            if [[ $temp == 1 ]]; then
                result="${array_v[1]}"
            else
                result="${array_v[0]}"
            fi
        fi
        # array="${array[*]} $i-$result"
        wait
        array+=("$i-$result")
        let count+=1
        unset array_v
    done
    wait
    [ -f ./temp.txt ] && rm -rf ./temp.txt
    echo "${array[*]}"
}
find_and_remode()
{
    _folder="$1"
    find_folder=$(find "$_folder" -type d | sed 's/\/$//')
    touch "$filesdir"/remove_pkg.log
    for i in ${find_folder[*]}; do
        old_version=$(find_old_version "$i")
        wait
        for j in ${old_version[*]}; do
            rm_pkg=$(find "$i" -iname "$j*" | rev | cut -d '/' -f1 | rev)
            # find $i -iname "$j*" -exec rm -rf {} \;
            wait
            rm -rf "$i/${rm_pkg[*]}"
            echo "Remove packages: ${rm_pkg[*]}"
            echo "Remove packages: ${rm_pkg[*]}" >> "$filesdir"/remove_pkg.log
        done
        wait
    done
    wait
    if [[ $(cat "$filesdir/remove_pkg.log") != "" ]]; then
        echo ""
        echo "Log file on remove packages to: $filesdir/remove_pkg.log"
        sleep 5
    else
        rm -rf "$filesdir/remove_pkg.log"  
    fi    
    wait
   [[ ${_folder} ]] && unset _folder
   [[ ${find_folder} ]] && unset find_folder
   [[ ${old_version} ]] && unset old_version
   [[ ${rm_pkg} ]] && unset rm_pkg
}
