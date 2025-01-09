#Cronjob delete old backup files
sudo crontab -e

#Add this line to crontab
0 1 * * * /mnt/s1/shellscripts/cleanup_old_backup.sh

