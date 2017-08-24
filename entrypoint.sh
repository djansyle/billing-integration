#!/bin/sh

set -eo pipefail

if [ ! -f /.decrypted ]
then
    sourceDir="$SOURCE_DIR"

    if [ -z "$PASSWORD" ]
    then
        echo "Missing PASSWORD environment variable."
        exit 1
    fi

    password="$PASSWORD"
    if [ -z "$SOURCE_DIR" ]
    then
        sourceDir="/usr/src/app"
        echo "Setting to default secured dir to ${sourceDir}"
    fi

    openssl enc -d -aes-256-cbc -in /files.db -out /files.zip -k ${password}
    mkdir -p ${sourceDir}
    unzip /files.zip -d ${sourceDir}

    rm /files.db /files.zip

    touch /.decrypted
    cd ${sourceDir}
    npm install
fi
exec "$@"