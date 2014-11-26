#!/bin/sh
# SMTP Signer - POSIX Shell Implementation (using sed)
#

PREFIX=`dirname $0`/..
. "${PREFIX}/etc/smtp-signer.conf"

E_TEMPFAIL=75
E_UNAVAILABLE=69

trap "rm -f in.$$ body.$$ header1.$$ header.$$ signed.$$" 0 1 2 3 15

cd ${SIGN_DIR} || {
  printf "${SIGN_DIR} does not exist"
  exit ${E_TEMPFAIL}
}

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
CERT_FILE="${CERT_DIR}/$2_all.pem"
if [ -f "${CERT_FILE}" ]; then
  # Sign mail and relay
  MSG="Signed mail from $2"
  ${OPENSSL} smime -sign -signer "${CERT_FILE}" -passin "pass:${PASSWORD}" -in body.$$ -out signed.$$
  cat header.$$ signed.$$ | ${SENDMAIL} "$@" 
else
  # Relay without signing
  MSG="Unsigned mail from $2"
  cat in.$$ | ${SENDMAIL} "$@"
fi
#else 
#  # send error message
#  cat <<EOF | ${SENDMAIL} -f postmaster -- $2
#To: $2
#Subject: failed to sign
#
#Failed to sign.
#EOF
#fi
STATUS=$?

if [ "${STATUS}" -eq 0 ]; then
  LOG_LEVEL="notice"
else
  LOG_LEVEL="err"
fi
logger -p "mail.${LOG_LEVEL}" -t "sign.sh" "${MSG}"

exit ${STATUS}

