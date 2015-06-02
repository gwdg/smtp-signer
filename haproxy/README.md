
# Prequisites

- Virtual Box
- Vagrant
- OpenBSD 5.6 Vagrant Box (see ../packer)

# Getting Started

./boostrap.sh

# Monitor HA Proxy:

Open web browser on host at http://192.168.3.20:8080/haproxy?stats

# Test:

vagrant ssh signer1 
cd /tmp
sudo -u _signer /usr/local/src/smtp-signer/tests/gen-test-cert.sh foobar@example.com foobar
sudo -u _signer /usr/local/src/smtp-signer/bin/signer-cert-add foobar@example.com_key.pem foobar@example.com_cert.pem



