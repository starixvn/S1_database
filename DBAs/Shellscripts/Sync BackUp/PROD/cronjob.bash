#Cronjob for Sync Backup
sudo crontab -e

#Add this line to crontab
30 * * * * /data/s1/shellscripts/sync_backup.sh
