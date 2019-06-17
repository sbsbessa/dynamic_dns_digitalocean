#!/bin/bash

CURRENT_IP=$(dig @resolver1.opendns.com A myip.opendns.com +short -4)
echo "Current IP: ${CURRENT_IP}"

echo curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer ${1}" "https://api.digitalocean.com/v2/domains/${2}/records/${3}"
DOMAIN_DATA=$(curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer ${1}" "https://api.digitalocean.com/v2/domains/${2}/records/${3}")

REGISTERED_IP=$( jq -r '.domain_record.data' <<< "${DOMAIN_DATA}" )
echo "Registered IP: ${REGISTERED_IP}"

# check if IP Address has changed
if [ "$CURRENT_IP" != "$REGISTERED_IP" ]
then
  echo "IP has changed"
  UPDATE_RESULT=$(curl -X PUT -H "Content-Type: application/json" -H "Authorization: Bearer $1" -d "{\"data\":\"${CURRENT_IP}\"}" "https://api.digitalocean.com/v2/domains/$2/records/$3")
  echo "DNS updated to $CURRENT_IP"
else
  echo "IP did not change"
fi

