# -- cli

echo "export PS1='\h$ '" >>/root/.profile

# -- localtime

rm /etc/localtime
ln -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime

# -- ntpd

# pkg_add ntpd
# mv /etc/ntpd.conf /etc/ntpd.conf.old
cat <<EOF >/etc/ntpd.conf
server ntps1.gwdg.de
server ntps2.gwdg.de
server ntps3.gwdg.de
server ntps4.gwdg.de
EOF

cat <<EOF >>/etc/rc.conf.local
ntpd_flags=""
EOF

# -- hosts

cat /vagrant/common/hosts >>/etc/hosts

# -- 

export PKG_PATH=http://ftp.openbsd.org/pub/OpenBSD/5.6/packages/amd64/
pkg_add vim-7.4.135p2-no_x11
