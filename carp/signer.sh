# -- carp

echo "inet 192.168.2.20 255.255.255.0 192.168.2.0 vhid 1 pass foobar carpdev em1" >> /etc/hostname.carp0
echo "pass on em1 proto carp keep state" >>/etc/pf.conf
pfctl -f /etc/pf.conf

# -- postfix

pkg_add postfix-2.12.20140109

cat <<EOF >>/etc/rc.conf.local
sendmail_flags=NO
syslogd_flags="-a /var/spool/postfix/dev/log -h"
pkg_scripts="postfix"
EOF

cp /vagrant/signer/postfix/main.cf /etc/postfix

# -- smtp-signer

pkg_add git

mkdir -p /usr/local/src
cd /usr/local/src
git clone https://github.com/gwdg/smtp-signer.git

cd smtp-signer
cp /vagrant/signer/smtp-signer/smtp-signer.conf etc/
./scripts/install.sh

# -- cert-store

pkg_add sshfs-fuse

