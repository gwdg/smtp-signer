echo "export PS1='\h$ '" >>/root/.profile
echo "inet 192.168.2.20 255.255.255.0 192.168.2.0 vhid 1 pass foobar carpdev em1" >> /etc/hostname.carp0
echo "pass on em1 proto carp keep state" >>/etc/pf.conf
pfctl -f /etc/pf.conf

