# SMTP Signer Service

## Overview

Suggested system:

* Firewall pf (for setting client access to SMTP) (e.g. included in OpenBSD)
* Mailsystem postfix which supports pipe processing via shell scripts

## Current implementations

Two independent implementations are available:

* Posix Shell implementation `bin/sign.sh` which uses (printf,sed and openssl).
* Perl implementtion `bin/sign.pl`

## Installation

* Edit /etc/postfix/master.cf, add `-o content_filter=sign:dummy`.

```
smtp      inet  n       -       -       -       -       smtpd
  -o content_filter=sign:dummy
```

* Decide script implementation.

 * POSIX shell script:

```
sign      unix  -       n       n       -       10      pipe
  flags=Rq user=mail null_sender=
  argv=/usr/smtp-signer/bin/sign.sh -f ${sender} -- ${recipient}
```
   
  * Edit 'etc/smtp-signer.conf', specify PASSWORD (and do not change later!).'

 * Perl:

```
sign      unix  -       n       n       -       10      pipe
  flags=Rq user=mail null_sender=
  argv=/opt/smtp-signer/bin/perl.sh -f ${sender} -- ${recipient}
```

  * Edit 'sign.pl' configuration variables.

## Administration

A couple of administration tasks are abstracted via thin shell command-line tool wrappers using the prefix `signer-<SUBJECT>-<ACTION>`
(e.g. `user`, `cert` and `client` as subjects, and `add`, `del` as action.)

### Prequisite

Add `bin/` to `$PATH` e.g. run `. ./setenv`.
Run tools as root e.g. via `sudo signer-...`.


### Add user

`signer-user-add <user> <password>`

### Add client

`signer-client-add <ip>`

The current implementation adds a new entry in a text file for pf and reloads the firewall.

### Add cert

`signer-cert-add <keyfile> <certfile>`

This will convert and add certificates where the key is encrypted by a common password.

### Delete user

`signer-user-del <user>`

This will delete user; the current implementation will remove the user from the system database (e.g. `passwd`).

### Delete client

`signer-client-del <ip>`

This will delete the ip from a pf-table text-file and update the firewall.

### Delete cert

`signer-cert-del <email>`

This will delete the key/cert files from `certs/` for a particular email address.

## Manual Installation of certificates and keys. (legacy script)

* Copy key (without password) as `<email>_key-plain.pem`.
* Copy cert as `<email>_cert.pem`
* Run `scripts/convert.sh <email>'
* Copy `<email>_all.pem`, `<email>_key.pem` and `<email>_cert.pem` files to `certs` folder.

## Tests

The tests folder contains 'send mail' test scripts in various languages/SMTP APIs.

* `cd tests`
* `cp test.rc.sample test.rc`
* Edit test.rc
* Run tests
 * Perl: `./mail.pl`
 * Python: `./mail.py`
 * NodeJS
  * `cd nodejs/nodemailer`
  * `npm update` (once)
  * `node ./mail.js`

Further testing tools:

* Test tool for a self-signed X.509 email certificate 
  `tests/gen-test-cert.sh <email>`

