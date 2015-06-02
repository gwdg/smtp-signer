export PKG_PATH=http://ftp.openbsd.org/pub/OpenBSD/5.6/packages/amd64/
# -- postfix

# pkg_add postfix-2.12.20140109
pkg_add postfix-2.12.20140701

/usr/local/sbin/postfix-enable

cat <<EOF >>/etc/rc.conf.local
sendmail_flags=NO
syslogd_flags="-a /var/spool/postfix/dev/log -h"
pkg_scripts="postfix"
EOF

cp /vagrant/mailer/etc/postfix/* /etc/postfix/



