#!/bin/bash

rsync -avz -e "ssh -i /home/dba_archive/.ssh/id_rsa" /data/s1/mysql/backup dba_archive@10.40.40.162:/mnt/s1/backup-from-149/
