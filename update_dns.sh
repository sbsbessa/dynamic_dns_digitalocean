#!/bin/sh

id=$(echo ${3} | awk '{ print $1 }')


CURRENT_IP=$(dig @resolver1.opendns.com A myip.opendns.com +short -4)
echo "Current IP: ${CURRENT_IP}"

echo curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer ${id}" "https://api.digitalocean.com/v2/domains/${2}/records/${3}"
DOMAIN_DATA=$(curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer ${1}" "https://api.digitalocean.com/v2/domains/${2}/records/${id}")


REGISTERED_IP=$( echo ${DOMAIN_DATA} | jq -r '.domain_record.data')
echo "Registered IP: ${REGISTERED_IP}"

# check if IP Address has changed
if [ "$CURRENT_IP" != "$REGISTERED_IP" ]
then
  echo "IP has changed"
  for id in $(echo ${3} | sed 's/ /\n/g')
    do
      UPDATE_RESULT=$(curl -X PUT -H "Content-Type: application/json" -H "Authorization: Bearer $1" -d "{\"data\":\"${CURRENT_IP}\"}" "https://api.digitalocean.com/v2/domains/$2/records/$id")
    done
  echo "DNS updated to $CURRENT_IP"
else
  echo "IP did not change"
fi

