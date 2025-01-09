This process used for incrementally sync backup files from 
10.40.40.149(PROD) to 10.40.40.162(UAT)
using passwordless ssh account (dba_archive)

PROD has script to sync backup file to UAT /data/s1/shellscripts/sync_backup.sh
UAT has script to delete old backup files /mnt/s1/shellscripts/cleanup_old_backup.sh
Both env has cronjob for those scripts respectively
