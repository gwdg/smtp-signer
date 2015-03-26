# -- postfix

pkg_add postfix-2.12.20140109

cat <<EOF >>/etc/rc.conf.local
sendmail_flags=NO
syslogd_flags="-a /var/spool/postfix/dev/log -h"
pkg_scripts="postfix"
EOF

cp /vagrant/mailer/postfix/* /etc/postfix



