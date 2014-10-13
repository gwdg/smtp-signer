# SMTP Signer Service

## Installation

Edit /etc/postfix/master.cf

  smtp      inet  n       -       -       -       -       smtpd
    -o content_filter=sign:dummy
  sign      unix  -       n       n       -       10      pipe
    flags=Rq user=mail null_sender=
    argv=/opt/smtp-signer/bin/sign.pl -f ${sender} -- ${recipient}


