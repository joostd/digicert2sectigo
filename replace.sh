#!/bin/bash

set -e

order=$1
email=$2

# retrieve CSR of (to be) revoked certificate
[ -f $order.csr ] || curl -sH @digicert-headers https://www.digicert.com/services/v2/order/certificate/$order | jq -r .certificate.csr > $order.csr
#openssl req -in $order.csr -noout -subject

SANS=$(openssl req -noout -text -in $order.csr -reqopt no_aux,no_header,no_issuer,no_pubkey,no_serial,no_sigdump,no_signame,no_subject,no_validity,no_version | grep DNS | sed 's/DNS://g;s/ //g')

# prepare request for Sectigo API
[ -f enroll-$order.json ] || jq -n --rawfile csr $order.csr --arg sans $SANS --arg email "$email" --arg comment "replacement for digicert order $order" -f enroll-template.jq > enroll-$order.json 
#jq . enroll-$order.json

# re-enrol certificate order with Sectigo
[ -f order-$order.json ] || curl -sH @sectigo-headers https://cert-manager.com/api/ssl/v1/enroll -X POST -d @enroll-$order.json > order-$order.json
jq . order-$order.json

sleep 5; # wait for processing
# collect certificate
[ -f cert-$order.pem ] || jq -r .sslId order-$order.json | xargs -IN curl -sH @sectigo-headers https://cert-manager.com/api/ssl/v1/collect/N/pemco > cert-$order.pem
