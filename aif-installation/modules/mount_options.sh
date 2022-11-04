######################################################################
##                                                                  ##
##                       Mount Options                              ##
##                                                                  ##
######################################################################

btrfs_mounted_options(){
	dialog --backtitle "VERSION - SYSTEM (ARCHI)" --title "_btrfsMntTitle" --clear --checklist "_btrfsMntBody" 0 0 16 \
	"autodefrag" "$_mnt_autodefrag_bd" off \
	"discard" "$_mnt_discard_bd" off \
	"nodev" "$_mnt_nodev_bd" off \
	"nosuid" "$_mnt_nosuid_bd" off \
	"noexec" "$_mnt_noexec_bd" off \
	"noacl" "$_mnt_noacl_bd" off \
	"ro" "$_mnt_ro_bd" off \
	"sync" "$_mnt_sync_bd" off \
	"usrquota" "$_mnt_usrquota_bd" off \
	"grpqutoa" "$_mnt_grpqutoa_bd" off \
	"noatime" "$_mnt_noatime_bd" off \
	"nodiratime" "$_mnt_nodiratime_bd" off \
	"relatime" "$_mnt_relatime_bd" off \
	"nodatasum" "$_mnt_nodatasum_bd" off \
	"nospace_cache" "$_mnt_nospace_cache_bd" off \
	"recovery" "$_mnt_recovery_bd" off \
	"skip_balance" "$_mnt_skip_balance_bd" off \
	"space_cache" "$_mnt_space_cache_bd" off \
	"ssd" "$_mnt_ssd_bd" off \
	"ssd_spread" "$_mnt_ssd_spread" off \
	"compress=zlib" "$_mnt_compress_bd" off \
	"compress=lzo" "$_mnt_compress_bd" off \
	"compress=no" "$_mnt_compress_bd no" off \
	"compress-force=zlib" "$_mnt_compress_force_bd" off \
	"compress-force=lzo" "$_mnt_compress_force_bd" off 2>${BTRFS_OPTS}
	
	sed -i 's/ /,/g' ${BTRFS_OPTS}
	sed -i '$s/,$//' ${BTRFS_OPTS}
}
