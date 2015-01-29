#!/bin/sh

. ./common

PASSWORD="nohopewithoutdope"
cat <<EOF >smtp-signer.conf
SIGN_DIR=/var/spool/sign
CERT_DIR="${PWD}/certs"
SENDMAIL="${PWD}/fakesendmail.sh" 
OPENSSL=`which openssl`
PASSWORD="${PASSWORD}"
LOG_CONFIG="${PWD}/log4perl.conf"
EOF


mkdir -p ${PWD}/certs
( cd certs && ../../gen-test-cert.sh "${TEST_FROM}" "${PASSWORD}" )

# @@@TODO:  mkdir -p /tmp/log4perl

