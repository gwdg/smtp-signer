#!/bin/sh
# generate a self-signed certificate for testing purposes

if [ $# -ne 2 ]; then
  cat <<EOF
usage: $0 <email> <password>

EOF
  exit 1
fi

EMAIL=$1
PASSWORD=$2

openssl genrsa -out ${EMAIL}_key.pem -passout "pass:${PASSWORD}" 2048
openssl req    -new -key ${EMAIL}_key.pem -out ${EMAIL}_csr.pem -subj /emailAddress=${EMAIL}
openssl x509   -req -days 365 -in ${EMAIL}_csr.pem -signkey ${EMAIL}_key.pem -out ${EMAIL}_cert.pem

