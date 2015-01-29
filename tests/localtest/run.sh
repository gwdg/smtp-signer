. ./smtp-signer.conf
. ./common
cat sample-mail.txt | SMTP_SIGNER_CONFIG="${PWD}/smtp-signer.conf" ../../bin/sign.pl -f "${TEST_FROM}" -- "${TEST_TO}"

