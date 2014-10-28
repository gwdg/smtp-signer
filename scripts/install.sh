#!/bin/sh


USERNAME=_signer
ROOT=/usr/local/src/smtp-signer

useradd -c "smtp-signer" -d "/var/empty" -r 600..999 -s /sbin/nologin ${SIGNER}
chown -R ${USERNAME}:${USERNAME} /var/spool/sign/.
chown -R ${USERNAME}:${USERNAME} ${ROOT}/certs/.

# setup base group for SMTP-Signer 'users' (authenticated via SASL and passwd)

groupadd -g 10000 usign
