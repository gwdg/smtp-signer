export PKG_PATH=http://ftp.openbsd.org/pub/OpenBSD/5.6/packages/amd64/
# -- postfix
# pkg_add postfix-2.12.20140109
pkg_add postfix-2.12.20140701

/usr/local/sbin/postfix-enable

cat <<EOF >>/etc/rc.conf.local
sendmail_flags=NO
smtpd_flags=NO
syslogd_flags="-a /var/spool/postfix/dev/log -h"
pkg_scripts="postfix"
EOF

cp /vagrant/signer/postfix/* /etc/postfix/

# -- smtp-signer

pkg_add git

mkdir -p /usr/local/src
cd /usr/local/src
git clone https://github.com/gwdg/smtp-signer.git

cd smtp-signer
./bootstrap.sh
cp /vagrant/signer/smtp-signer.conf etc/
./scripts/install.sh

