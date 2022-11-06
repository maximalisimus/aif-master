######################################################################
##                                                                  ##
##                       Mount Options                              ##
##                                                                  ##
######################################################################

btrfs_mounted_options()
{
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_btrfsMntTitle" --clear --checklist "$_btrfsMntBody" 0 0 16 \
	"async" "$_mnt_async_bd" off \
	"sync" "$_mnt_sync_bd" off \
	"nodev" "$_mnt_nodev_bd" off \
	"nodiratime" "$_mnt_nodiratime_bd" off \
	"noexec" "$_mnt_noexec_bd" off \
	"noatime" "$_mnt_noatime_bd" off \
	"relatime" "$_mnt_relatime_bd" off \
	"norelatime" "$_mnt_norelatime_bd" off \
	"nosuid" "$_mnt_nosuid_bd" off \
	"ro" "$_mnt_ro_bd" off \
	"rw" "$_mnt_rw_bd" off \
	"autodefrag" "$_mnt_autodefrag_bd" off \
	"noautodefrag" "$_mnt_noautodefrag_bd" off \
	"discard" "$_mnt_discard_bd" off \
	"acl" "$_mnt_acl_bd" off \
	"noacl" "$_mnt_noacl_bd" off \
	"noatime" "$_mnt_noatime_bd" off \
	"nodatasum" "$_mnt_nodatasum_bd" off \
	"nospace_cache" "$_mnt_nospace_cache_bd" off \
	"recovery" "$_mnt_recovery_bd" off \
	"skip_balance" "$_mnt_skip_balance_bd" off \
	"space_cache" "$_mnt_space_cache_bd" off \
	"ssd" "$_mnt_ssd_bd" off \
	"ssd_spread" "$_mnt_ssd_spread" off \
	"compress=zlib" "$_mnt_compress_bd" off \
	"compress=lzo" "$_mnt_compress_bd" off \
	"compress=zstd" "$_mnt_compress_bd" off \
	"compress=no" "$_mnt_compress_bd no" off \
	"compress-force=zlib" "$_mnt_compress_force_bd" off \
	"compress-force=zstd" "$_mnt_compress_force_bd" off \
	"compress-force=lzo" "$_mnt_compress_force_bd" off 2>${BTRFS_OPTS}
	
	sed -i 's/ /,/g' ${BTRFS_OPTS}
	sed -i '$s/,$//' ${BTRFS_OPTS}
	
	if [[ $(cat ${BTRFS_OPTS}) != "" ]]; then
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title "$_btrfsMntTitle" --yesno "$_btrfsMntConfBody $(cat $BTRFS_OPTS)\n" 0 0
		[[ $? -eq 1 ]] && btrfs_mounted_options
	fi
}

ext2_mounted_options()
{
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $_filesystem " --checklist "$_Mnt_Body" 0 0 16 \
	"async" "$_mnt_async_bd" off \
	"sync" "$_mnt_sync_bd" off \
	"nodev" "$_mnt_nodev_bd" off \
	"nodiratime" "$_mnt_nodiratime_bd" off \
	"noexec" "$_mnt_noexec_bd" off \
	"noatime" "$_mnt_noatime_bd" off \
	"relatime" "$_mnt_relatime_bd" off \
	"norelatime" "$_mnt_norelatime_bd" off \
	"nosuid" "$_mnt_nosuid_bd" off \
	"ro" "$_mnt_ro_bd" off \
	"rw" "$_mnt_rw_bd" off \
	"acl" "$_mnt_acl_bd" off \
	"noacl" "$_mnt_noacl_bd" off \
	"errors=continue" "$_mnt_continue_bd" off \
	"errors=panic" "$_mnt_panic_bd" off \
	"usrquota" "$_mnt_usrquota_bd" off \
	"grpquota" "$_mnt_grpqutoa_bd" off \
	"user_xattr" "$_mnt_user_xattr_bd" off 2>${MOUNT_OPTS}
	
	# Now clean up the file
	sed -i 's/ /,/g' ${MOUNT_OPTS}
	sed -i '$s/,$//' ${MOUNT_OPTS}
	
	# If mount options selected, confirm choice 
	if [[ $(cat ${MOUNT_OPTS}) != "" ]]; then
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $_Mnt_Status_Title " --yesno "\n${_Mnt_Conf_Body}$(cat ${MOUNT_OPTS})\n" 10 75
		[[ $? -eq 1 ]] && ext2_mounted_options
	fi
}

ext3_mounted_options()
{
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $_filesystem " --checklist "$_Mnt_Body" 0 0 16 \
	"async" "$_mnt_async_bd" off \
	"sync" "$_mnt_sync_bd" off \
	"nodev" "$_mnt_nodev_bd" off \
	"nodiratime" "$_mnt_nodiratime_bd" off \
	"noexec" "$_mnt_noexec_bd" off \
	"noatime" "$_mnt_noatime_bd" off \
	"relatime" "$_mnt_relatime_bd" off \
	"norelatime" "$_mnt_norelatime_bd" off \
	"nosuid" "$_mnt_nosuid_bd" off \
	"ro" "$_mnt_ro_bd" off \
	"rw" "$_mnt_rw_bd" off \
	"acl" "$_mnt_acl_bd" off \
	"norecovery" "$_mnt_norecovery_bd" off \
	"data=journal" "$_mnt_journal_bd" off \
	"data=ordered" "$_mnt_ordered_bd" off \
	"data=writeback" "$_mnt_writeback_bd" off \
	"user_xattr" "$_mnt_user_xattr_bd" off 2>${MOUNT_OPTS}
	
	# Now clean up the file
	sed -i 's/ /,/g' ${MOUNT_OPTS}
	sed -i '$s/,$//' ${MOUNT_OPTS}
	
	# If mount options selected, confirm choice 
	if [[ $(cat ${MOUNT_OPTS}) != "" ]]; then
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $_Mnt_Status_Title " --yesno "\n${_Mnt_Conf_Body}$(cat ${MOUNT_OPTS})\n" 10 75
		[[ $? -eq 1 ]] && ext3_mounted_options
	fi
}

ext4_mounted_options()
{
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $_filesystem " --checklist "$_Mnt_Body" 0 0 16 \
	"async" "$_mnt_async_bd" off \
	"sync" "$_mnt_sync_bd" off \
	"nodev" "$_mnt_nodev_bd" off \
	"nodiratime" "$_mnt_nodiratime_bd" off \
	"noexec" "$_mnt_noexec_bd" off \
	"noatime" "$_mnt_noatime_bd" off \
	"relatime" "$_mnt_relatime_bd" off \
	"norelatime" "$_mnt_norelatime_bd" off \
	"nosuid" "$_mnt_nosuid_bd" off \
	"ro" "$_mnt_ro_bd" off \
	"rw" "$_mnt_rw_bd" off \
	"journal" "$_mnt_journal_bd" off \
	"data=journal" "$_mnt_journal_bd" off \
	"data=ordered" "$_mnt_ordered_bd" off \
	"data=writeback" "$_mnt_writeback_bd" off \
	"delalloc" "$_mnt_delalloc_bd" off \
	"nodelalloc" "$_mnt_nodelalloc_bd" off \
	"discard" "$_mnt_discard_bd" off \
	"noacl" "$_mnt_noacl_bd" off \
	"nobarrier" "$_mnt_nobarrier_bd" off \
	"usrquota" "$_mnt_usrquota_bd" off \
	"grpquota" "$_mnt_grpqutoa_bd" off 2>${MOUNT_OPTS}
	
	# Now clean up the file
	sed -i 's/ /,/g' ${MOUNT_OPTS}
	sed -i '$s/,$//' ${MOUNT_OPTS}
	
	# If mount options selected, confirm choice 
	if [[ $(cat ${MOUNT_OPTS}) != "" ]]; then
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $_Mnt_Status_Title " --yesno "\n${_Mnt_Conf_Body}$(cat ${MOUNT_OPTS})\n" 10 75
		[[ $? -eq 1 ]] && ext4_mounted_options
	fi
}

f2fs_mounted_options()
{
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $_filesystem " --checklist "$_Mnt_Body" 0 0 16 \
	"async" "$_mnt_async_bd" off \
	"sync" "$_mnt_sync_bd" off \
	"nodev" "$_mnt_nodev_bd" off \
	"nodiratime" "$_mnt_nodiratime_bd" off \
	"noexec" "$_mnt_noexec_bd" off \
	"noatime" "$_mnt_noatime_bd" off \
	"relatime" "$_mnt_relatime_bd" off \
	"norelatime" "$_mnt_norelatime_bd" off \
	"nosuid" "$_mnt_nosuid_bd" off \
	"ro" "$_mnt_ro_bd" off \
	"rw" "$_mnt_rw_bd" off \
	"data_flush" "$_mnt_data_flush_bd" off \
	"disable_roll_forward" "$_mnt_disable_roll_forward_bd" off \
	"disable_ext_identify" "$_mnt_disable_ext_identify_bd" off \
	"discard" "$_mnt_discard_bd" off \
	"fastboot" "$_mnt_fastboot_bd" off \
	"flush_merge" "$_mnt_flush_merge_bd" off \
	"inline_xattr" "$_mnt_inline_xattr_bd" off \
	"inline_data" "$_mnt_inline_data_bd" off \
	"inline_dentry" "$v" off \
	"no_heap" "$_mnt_no_heap_bd" off \
	"noacl" "$_mnt_noacl_bd" off \
	"nobarrier" "$_mnt_nobarrier_bd" off \
	"noextent_cache" "$_mnt_noextent_cache_bd" off \
	"noinline_data" "$_mnt_noinline_data_bd" off \
	"norecovery" "$_mnt_norecovery_bd" off 2>${MOUNT_OPTS}
	
	# Now clean up the file
	sed -i 's/ /,/g' ${MOUNT_OPTS}
	sed -i '$s/,$//' ${MOUNT_OPTS}
	
	# If mount options selected, confirm choice 
	if [[ $(cat ${MOUNT_OPTS}) != "" ]]; then
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $_Mnt_Status_Title " --yesno "\n${_Mnt_Conf_Body}$(cat ${MOUNT_OPTS})\n" 10 75
		[[ $? -eq 1 ]] && f2fs_mounted_options
	fi
}

jfs_mounted_options()
{
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $_filesystem " --checklist "$_Mnt_Body" 0 0 15 \
	"async" "$_mnt_async_bd" off \
	"sync" "$_mnt_sync_bd" off \
	"nodev" "$_mnt_nodev_bd" off \
	"nodiratime" "$_mnt_nodiratime_bd" off \
	"noexec" "$_mnt_noexec_bd" off \
	"noatime" "$_mnt_noatime_bd" off \
	"relatime" "$_mnt_relatime_bd" off \
	"norelatime" "$_mnt_norelatime_bd" off \
	"nosuid" "$_mnt_nosuid_bd" off \
	"ro" "$_mnt_ro_bd" off \
	"rw" "$_mnt_rw_bd" off \
	"discard" "$_mnt_discard_bd" off \
	"errors=continue" "$_mnt_continue_bd" off \
	"errors=panic" "$_mnt_panic_bd" off \
	"nointegrity" "$_mnt_nointegrity_bd" off 2>${MOUNT_OPTS}
	
	# Now clean up the file
	sed -i 's/ /,/g' ${MOUNT_OPTS}
	sed -i '$s/,$//' ${MOUNT_OPTS}
	
	# If mount options selected, confirm choice 
	if [[ $(cat ${MOUNT_OPTS}) != "" ]]; then
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $_Mnt_Status_Title " --yesno "\n${_Mnt_Conf_Body}$(cat ${MOUNT_OPTS})\n" 10 75
		[[ $? -eq 1 ]] && jfs_mounted_options
	fi
}

nilfs2_mounted_options()
{
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $_filesystem " --checklist "$_Mnt_Body" 0 0 16 \
	"async" "$_mnt_async_bd" off \
	"sync" "$_mnt_sync_bd" off \
	"nodev" "$_mnt_nodev_bd" off \
	"nodiratime" "$_mnt_nodiratime_bd" off \
	"noexec" "$_mnt_noexec_bd" off \
	"noatime" "$_mnt_noatime_bd" off \
	"relatime" "$_mnt_relatime_bd" off \
	"norelatime" "$_mnt_norelatime_bd" off \
	"nosuid" "$_mnt_nosuid_bd" off \
	"ro" "$_mnt_ro_bd" off \
	"rw" "$_mnt_rw_bd" off \
	"discard" "$_mnt_discard_bd" off \
	"nobarrier" "$_mnt_nobarrier_bd" off \
	"errors=continue" "$_mnt_continue_bd" off \
	"errors=panic" "$_mnt_panic_bd" off \
	"order=relaxed" "$_mnt_relaxed_bd" off \
	"order=strict" "$_mnt_strict_bd" off \
	"norecovery" "$_mnt_norecovery_bd" off 2>${MOUNT_OPTS}
	
	# Now clean up the file
	sed -i 's/ /,/g' ${MOUNT_OPTS}
	sed -i '$s/,$//' ${MOUNT_OPTS}
	
	# If mount options selected, confirm choice 
	if [[ $(cat ${MOUNT_OPTS}) != "" ]]; then
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $_Mnt_Status_Title " --yesno "\n${_Mnt_Conf_Body}$(cat ${MOUNT_OPTS})\n" 10 75
		[[ $? -eq 1 ]] && nilfs2_mounted_options
	fi
}

reiserfs_mounted_options()
{
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $_filesystem " --checklist "$_Mnt_Body" 0 0 5 \
	"async" "$_mnt_async_bd" off \
	"sync" "$_mnt_sync_bd" off \
	"nodev" "$_mnt_nodev_bd" off \
	"nodiratime" "$_mnt_nodiratime_bd" off \
	"noexec" "$_mnt_noexec_bd" off \
	"noatime" "$_mnt_noatime_bd" off \
	"relatime" "$_mnt_relatime_bd" off \
	"norelatime" "$_mnt_norelatime_bd" off \
	"nosuid" "$_mnt_nosuid_bd" off \
	"ro" "$_mnt_ro_bd" off \
	"rw" "$_mnt_rw_bd" off \
	"acl" "$_mnt_acl_bd" off \
	"nolog" "$_mnt_nolog_bd" off \
	"notail" "$_mnt_notail_bd" off \
	"replayonly" "$_mnt_replayonly_bd" off \
	"user_xattr" "$_mnt_user_xattr_bd" off 2>${MOUNT_OPTS}
	
	# Now clean up the file
	sed -i 's/ /,/g' ${MOUNT_OPTS}
	sed -i '$s/,$//' ${MOUNT_OPTS}
	
	# If mount options selected, confirm choice 
	if [[ $(cat ${MOUNT_OPTS}) != "" ]]; then
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $_Mnt_Status_Title " --yesno "\n${_Mnt_Conf_Body}$(cat ${MOUNT_OPTS})\n" 10 75
		[[ $? -eq 1 ]] && reiserfs_mounted_options
	fi
}

vfat_mounted_options()
{
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $_filesystem " --checklist "$_Mnt_Body" 0 0 7 \
	"async" "$_mnt_async_bd" off \
	"sync" "$_mnt_sync_bd" off \
	"nodev" "$_mnt_nodev_bd" off \
	"nodiratime" "$_mnt_nodiratime_bd" off \
	"noexec" "$_mnt_noexec_bd" off \
	"noatime" "$_mnt_noatime_bd" off \
	"relatime" "$_mnt_relatime_bd" off \
	"norelatime" "$_mnt_norelatime_bd" off \
	"nosuid" "$_mnt_nosuid_bd" off \
	"ro" "$_mnt_ro_bd" off \
	"rw" "$_mnt_rw_bd" off \
	"quiet" "$_mnt_quiet_bd" off \
	"discard" "$_mnt_discard_bd" off 2>${MOUNT_OPTS}
	
	# Now clean up the file
	sed -i 's/ /,/g' ${MOUNT_OPTS}
	sed -i '$s/,$//' ${MOUNT_OPTS}
	
	# If mount options selected, confirm choice 
	if [[ $(cat ${MOUNT_OPTS}) != "" ]]; then
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $_Mnt_Status_Title " --yesno "\n${_Mnt_Conf_Body}$(cat ${MOUNT_OPTS})\n" 10 75
		[[ $? -eq 1 ]] && vfat_mounted_options
	fi
}

xfs_mounted_options()
{
	dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $_filesystem " --checklist "$_Mnt_Body" 0 0 16 \
	"async" "$_mnt_async_bd" off \
	"sync" "$_mnt_sync_bd" off \
	"nodev" "$_mnt_nodev_bd" off \
	"nodiratime" "$_mnt_nodiratime_bd" off \
	"noexec" "$_mnt_noexec_bd" off \
	"noatime" "$_mnt_noatime_bd" off \
	"relatime" "$_mnt_relatime_bd" off \
	"norelatime" "$_mnt_norelatime_bd" off \
	"nosuid" "$_mnt_nosuid_bd" off \
	"ro" "$_mnt_ro_bd" off \
	"rw" "$_mnt_rw_bd" off \
	"discard" "$_mnt_discard_bd" off \
	"filestreams" "$_mnt_filestreams_bd" off \
	"ikeep" "$_mnt_ikeep_bd" off \
	"largeio" "$_mnt_largeio_bd" off \
	"noalign" "$_mnt_noalign_bd" off \
	"nobarrier" "$_mnt_nobarrier_bd" off \
	"norecovery" "$_mnt_norecovery_bd" off \
	"noquota" "$_mnt_noquota_bd" off \
	"wsync" "$_mnt_wsync_bd" off \
	"usrquota" "$_mnt_usrquota_bd" off \
	"grpquota" "$_mnt_grpqutoa_bd" off 2>${MOUNT_OPTS}
	
	# Now clean up the file
	sed -i 's/ /,/g' ${MOUNT_OPTS}
	sed -i '$s/,$//' ${MOUNT_OPTS}
	
	# If mount options selected, confirm choice 
	if [[ $(cat ${MOUNT_OPTS}) != "" ]]; then
		dialog --backtitle "$VERSION - $SYSTEM ($ARCHI)" --title " $_Mnt_Status_Title " --yesno "\n${_Mnt_Conf_Body}$(cat ${MOUNT_OPTS})\n" 10 75
		[[ $? -eq 1 ]] && xfs_mounted_options
	fi
}
