#!/bin/bash

DIR_BACKUP="/tmp/backups"

# Backup folder
if [ ! -d "${DIR_BACKUP}" ]; then
  mkdir "${DIR_BACKUP}"
fi

# Valid parameters

# More than 2 parameters
if [ $# -gt 2 ]; then
  echo -e "Incorrect number of backups" 1>&2 && exit 1;
fi

# Empty parameters
if [ -z $(echo '$1' | sed 's/^[ \t]*//') ] || [ -z $(echo $2 | sed 's/^[ \t]*//') ]; then
  echo -e "No input options" 1>&2 && exit 1;
fi

# Exist backup folder
if [ ! -d "$1" ]; then
  echo -e "Backup folder doesn't exist" 1>&2 && exit 1;
fi

# Second argument number
if (echo "$2" | grep -E -q "^?[a-z]+$"); then
   echo -e "Second argument is not a number" 1>&2 && exit 1;
fi

# Name backup
DIR="${1}"
BACKUP_DIR_NAME=$(echo "$DIR" | sed 's/\//-/g;s/^[-]//;s/[-]*$//')

# Creating backup file
i=1
while [ "$i" -le $2 ]; do
    FILE_NAME=${BACKUP_DIR_NAME}-$(date '+%Y-%m-%d-%H%M%S').tar.gz
    tar -cvzf "$DIR_BACKUP/$FILE_NAME" "$DIR" > /dev/null 2>&1
    i=$(( i + 1 ))
    sleep 1
done

# Checking backup number and delete old ones
find "$DIR_BACKUP" -name "${BACKUP_DIR_NAME}*" -type f | sort -n | head -n -"$2" | sed "s/.*/\"&\"/"| xargs rm -f

exit 0
