# SMTP Signer Service

## Installation

Edit /etc/postfix/master.cf, add `-o content_filter=sign:dummy`.

```
smtp      inet  n       -       -       -       -       smtpd
  -o content_filter=sign:dummy
sign      unix  -       n       n       -       10      pipe
  flags=Rq user=mail null_sender=
  argv=/opt/smtp-signer/bin/sign.pl -f ${sender} -- ${recipient}
```

Edit '$PREFIX/etc/smtp-signer.conf', specify PASSWORD (and do not change later!).'

Edit 'sign.pl' configuration variables.

## Installation of certificates and keys.

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

