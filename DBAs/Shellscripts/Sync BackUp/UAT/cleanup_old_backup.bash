#!/bin/bash

find /mnt/s1/backup-from-149/ -mindepth 1 -type d -daystart -mtime +4 -exec rm -rf {} \;
