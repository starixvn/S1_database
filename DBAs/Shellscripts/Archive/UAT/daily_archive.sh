#!/bin/bash

CONTAINER_NAME="s1_uat_db1"
SOURCE_DB="TSDB"
SOURCE_FOLDER="/mnt/s1/mysql/db1/vol_data/TSDB"
ARCHIVE_DB="TSDB_ARCHIVE"
ARCHIVE_FOLDER="/mnt/s1/mysql/archive/data"

TABLES_FILE="/mnt/s1/mysql/archive/scripts/daily_archive_list.txt"
LOG_FILE="/mnt/s1/mysql/archive/log/archive_run.log"
CONF_FILE="/mnt/s1/mysql/archive/scripts/.archive.cnf"

# Get config value
if [[ -f "$CONF_FILE" ]]; then
    export $(grep -v '^#' "$CONF_FILE" | xargs)
else
    echo ".cnf file not found!" >> "$LOG_FILE"
    exit 1
fi

# Function run MySQL queries inside the Docker container
run_mysql_query() {
  docker exec $CONTAINER_NAME mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -h$MYSQL_HOST -P$MYSQL_PORT -e "$1"
}

# Function get date offset in YYYYMMDD format
get_past_date() {
  local days_ago=$(($1 + 1))
  local past_date=$(date -d "$days_ago days ago" +%Y%m%d)
  echo "$past_date"
}

# Function check if a table exists in a database
table_exists() {
  local table=$1
  local db=$2
  local result=$(run_mysql_query "SHOW TABLES FROM $db LIKE '$table';")
  if [[ "$result" == *"$table"* ]]; then
    return 0  # Table exists
  else
    return 1  # Table does not exist
  fi
}

# Capture running logs
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Start daily archiving process..." >> "$LOG_FILE"

# Read each line from the daily tables file and process
while IFS=, read -r base_name days_ago; do
  # Skip empty lines or comments
  [[ -z "$base_name" || "$base_name" =~ ^# ]] && continue

  # Trim leading/trailing spaces
  base_name=$(echo "$base_name" | xargs)
  days_ago=$(echo "$days_ago" | xargs)

  # Get target date
  target_date=$(get_past_date "$days_ago")
  echo "Working with table $base_name, target date: $target_date" >> "$LOG_FILE"

  # Full table name with the calculated date suffix
  table_name="${base_name}_${target_date}"

  # 1. Create the table in ARCHIVE_DB by copying structure from SOURCE_DB
  echo "  --Step 01: Creating structure for table $table_name in $ARCHIVE_DB--" >> "$LOG_FILE"

  # Create the table in ARCHIVE_DB by copying structure from SOURCE_DB
  run_mysql_query "CREATE TABLE $ARCHIVE_DB.$table_name LIKE $SOURCE_DB.$table_name; ALTER TABLE $ARCHIVE_DB.$table_name DISCARD TABLESPACE;" \
  && echo "    Done: Created table $table_name in $ARCHIVE_DB" >> "$LOG_FILE" \
  || {
     echo "    Error: Failed to create table $table_name in $ARCHIVE_DB" >> "$LOG_FILE"
     continue
     }


  # 2. Copy .ibd files to archive folder
  echo "  --Step 02: Copying .ibd files for table $table_name--" >> "$LOG_FILE"
  source_ibd_file="$SOURCE_FOLDER/$table_name.ibd"
  if [[ -f "$source_ibd_file" ]]; then
    cp "$source_ibd_file" "$ARCHIVE_FOLDER" \
    && echo "    Done: Copied $table_name.ibd to $ARCHIVE_FOLDER" >> "$LOG_FILE" \
    || {
         echo "    Error: Failed to copy $table_name.ibd to $ARCHIVE_FOLDER" >> "$LOG_FILE"
         continue
       }
  else
    echo "    Warning: $table_name.ibd not found, skipping copy." >> "$LOG_FILE"
    continue
  fi

  # 3. Drop the specified table from SOURCE_DB
  echo "  --Step 03: Dropping table $table_name from $SOURCE_DB--" >> "$LOG_FILE"
  archive_ibd_file="$ARCHIVE_FOLDER/$table_name.ibd"
  if table_exists "$table_name" "$ARCHIVE_DB" && [[ -f "$archive_ibd_file" ]]; then
    run_mysql_query "DROP TABLE $SOURCE_DB.$table_name;" \
    && echo "    Done: Dropped table $table_name from $SOURCE_DB" >> "$LOG_FILE" \
    || {
         echo "    Error: Failed to dropped table $table_name from $SOURCE_DB" >> "$LOG_FILE"
         continue
       }
  else
    echo "    Warning: Processing for table $table_name failed on create structure or move ibd file step, skipping drop." \
         >> "$LOG_FILE"
    continue
  fi

done < "$TABLES_FILE"

echo "Script completed successfully!"
