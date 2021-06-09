manager_pkg_start()
{
   _pm_n=$(find "$_pkg_manager_folder" -maxdepth 1 -type f -iname "${_pm_uniq[*]}*" | rev | cut -d '/' -f1 | cut -d '-' -f4-11 | rev)
   wait
   _pm_menu=""
   for i in ${_pm_n[*]}; do
       _pm_menu="${_pm_menu} $i - on"
   done
   [[ ${_pm_n} ]] && unset _pm_n
}
pkg_manager_install()
{
	if [[ $_pm_once == "0" ]]; then
		_pm_once=1
		info_search_pkg
		manager_pkg_start
		wait
	fi
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_menu_pkg_meneger" --checklist "$_pm_menu_body" 0 0 2 ${_pm_menu} 2>"${ANSWER}"
	_pm_check=$(cat "${ANSWER}")
	clear
	ustanovka_pocketov "$_pkg_manager_folder" "${_pm_check[*]}"
	wait
	[[ ${_pm_check} ]] && unset _pm_check
}
