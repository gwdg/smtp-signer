#!/bin/sh

if [ $# -ne 1 ]; then
  cat <<EOF
SMTP-Signer convert tool for cert/key files

usage: $0 <mail-address>

Required input files: '<email-address>_cert.pem' and '<email-addres>_key-plain.pem'
EOF
fi

NAME=$1

IN_CERT=${NAME}_cert.pem
IN_KEY=${NAME}_key-plain.pem

if [ ! -f ${IN_CERT} ]; then
  printf "missing certificate file '${IN_CERT}'.\n"
  exit 1
fi

if [ ! -f ${IN_KEY} ]; then
  printf "missing key file '${IN_KEY}'.\n"
  exit 1
fi

OUT_P12=${NAME}.p12
OUT_KEY=${NAME}_key.pem
OUT_ALL=${NAME}_all.pem
PASSWORD=siehabenpost

openssl pkcs12 -export -inkey ${IN_KEY} -in ${IN_CERT} -out ${OUT_P12} -passout pass:${PASSWORD}
openssl pkcs12 -in ${OUT_P12} -passin pass:${PASSWORD} -passout pass:${PASSWORD} -nocerts -out ${OUT_KEY}
openssl pkcs12 -in ${OUT_P12} -passin pass:${PASSWORD} -passout pass:${PASSWORD}          -out ${OUT_ALL}

rm ${OUT_P12}
printf "Generated files: ${OUT_KEY} and ${OUT_ALL}.\n"

