#!/bin/sh
PREFIX=`dirname $0`/..
. "${PREFIX}/etc/smtp-signer.conf"

# create sign script user

useradd -c "smtp-signer" -d "/var/empty" -r 600..999 -s /sbin/nologin ${USERNAME}

# create spool and cert directories

mkdir -p "${SIGN_DIR}" && chown -R ${USERNAME}:${USERNAME} "${SIGN_DIR}"
mkdir -p "${CERT_DIR}" && chown -R ${USERNAME}:${USERNAME} "${CERT_DIR}"

# setup base group for SMTP-Signer 'users' (authenticated via SASL and passwd)

# groupadd -g 10000 usign

# setup pf-smtp-clients.conf file

touch ${PREFIX}/etc/pf-smtp-clients.conf

