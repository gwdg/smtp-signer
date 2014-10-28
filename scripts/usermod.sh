#!/bin/sh
USERNAME=$1
PASSWORD=$2
usermod -p `encrypt "${PASSWORD}"` "${USERNAME}"

