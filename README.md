Quick and dirty bulk replacement of Digicert server certificates 
(https://knowledge.digicert.com/alerts/DigiCert-ICA-Replacement)

_NOTE: this code doesn't seem to handle SANs well, check for updates soon_

Requires:

- a list of Digicert order numbers with requester email address
- a key for the Digicert API (https://www.digicert.com/secure/automation/api-keys/)
- a key for the Sectigo API (from your SCM instance)
- jq  (https://stedolan.github.io/jq/)

See API docs:

- [Digicert Order  Info API](https://dev.digicert.com/services-api/orders/order-info/)
- [Sectigo Certificate Manager REST API](https://support.sectigo.com/Com_KnowledgeProductPage?c=Sectigo_Certificate_Manager_SCM)

Check cert id and term used in jq template with:

    curl -s https://cert-manager.com/api/ssl/v1/types -H @sectigo-headers | jq

Replace the Dicicert certifiate with order# 12345

    ./replace.sh 12345 jdoe@example.net
