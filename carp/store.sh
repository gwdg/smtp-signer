cat <<EOF >>/etc/rc.conf.local
portmap_flags=""
mountd_flags=""
nfsd_flags="-tun 4"
EOF

cat <<EOF >>/etc/exports
/var/lib/smtp-signer/certs -alldirs -ro -network=10.0.0 -mask=255.255.255.0
EOF
useradd -m admin
pkg_add openvpn

