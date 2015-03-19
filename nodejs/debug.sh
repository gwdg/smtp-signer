#!/bin/sh
. ../etc/smtp-signer.conf
sudo -u ${USERNAME} node-supervisor app.coffee

