#!/bin/bash

# backup.sh

# Automates directory backups with timestamps.
# Author: Tseggai Kidane
# Description: To automate directory backups and store them in
#              a specified backup location with a timestamp.

# Check if at least two arguments are passed (source and destination)
if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <source_directory> <destination_directory>"
  exit 1
fi

# Get the source and destination directories
SOURCE_DIR="$1"
DEST_DIR="$2"

# Check if the source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
  echo "Error: Source directory '$SOURCE_DIR' does not exist!"
  exit 2
fi

# Create the destination directory if it does not exist
if [ ! -d "$DEST_DIR" ]; then
  echo "Destination directory does not exist. Creating it..."
  mkdir -p "$DEST_DIR"
fi

# Get the current date and time for the backup filename
DATE=$(date +"%Y%m%d%H%M%S")

# Define the backup filename
BACKUP_FILENAME="backup_$DATE.tar.gz"

# Create the backup using tar
echo "Backing up '$SOURCE_DIR' to '$DEST_DIR/$BACKUP_FILENAME'..."
tar -czf "$DEST_DIR/$BACKUP_FILENAME" -C "$SOURCE_DIR" .

# Check if the backup was successful
if [ $? -eq 0 ]; then
  echo "Backup completed successfully: $DEST_DIR/$BACKUP_FILENAME"
else
  echo "Error: Backup failed!"
  exit 3
fi

