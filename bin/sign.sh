#!/bin/sh
SIGN_DIR=/var/spool/sign
CERT_DIR=/opt/smtp-signer/certs

SENDMAIL="/usr/sbin/sendmail -G -i"
OPENSSL="/usr/bin/openssl"

E_TEMPFAIL=75
E_UNAVAILABLE=69

trap "rm -f in.$$ arg.$$ body.$$ header1.$$ header.$$ signed.$$" 0 1 2 3 15

cd ${SIGN_DIR} || {
  printf "${SIGN_DIR} does not exist"
  exit ${E_TEMPFAIL}
}

echo "$*" >arg.$$
cat >in.$$
sed '/^$/q' <in.$$ >header1.$$
sed '$d' <header1.$$ >header.$$
CONTENT_TYPE=`sed -n '/Content-Type:/p' <header1.$$` 
if [ -z "${CONTENT_TYPE}" ]; then
  CONTENT_TYPE="Content-Type: text/plain"
fi
printf "${CONTENT_TYPE}\n" >body.$$
CONTENT_TRANSFER_ENCODING=`sed -n '/Content-Transfer-Encoding:/p' <header1.$$` 
if [ ! -z "${CONTENT_TRANSFER_ENCODING}" ]; then
  printf "${CONTENT_TRANSFER_ENCODING}\n" >>body.$$
fi
printf "\n" >>body.$$
sed '1,/^$/ d' <in.$$ >>body.$$
# CERT_FILE="${CERT_DIR}/dadler1@gwdg.de.pem"
CERT_FILE="${CERT_DIR}/$2_all.pem"
if [ -f "${CERT_FILE}" ]; then
  ${OPENSSL} smime -sign -signer "${CERT_FILE}" -passin pass:siehabenpost -in body.$$ -out signed.$$ 
  cat header.$$ signed.$$ # | ${SENDMAIL} "$@" 
else
  cat <<EOF # | ${SENDMAIL} -f postmaster -- $2
To: $2
Subject: failed to sign

Failed to sign.
EOF
fi
exit $?

