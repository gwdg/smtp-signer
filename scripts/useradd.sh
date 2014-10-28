#!/bin/sh
USERNAME=$1
PASSWORD=$2
useradd -c "SMTP-Signer User" -d /var/empty -G usign -p `encrypt "${PASSWORD}"` -s /sbin/nologin -r 10001..11000 "${USERNAME}"


