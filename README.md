# dynamic_dns_digitalocean
A simple script in Bash to automatically update Digitalocean DNS records using digitalocean API with your dynamic IP address

**Usage:**
`update_dns.sh <API_KEY> <DOMAIN> <RECORD_ID>`

I'm currently using this on a cronjob to regularly check the dynamic IP for changes and update DNS records on DigitalOcean to maintain remote access to a server.
