#!/bin/bash

new_certificates=configuration/certificates.toml
touch $new_certificates

echo "[tls]" >> $new_certificates

readarray -t certificates_lines < traefik_rules/rules.toml

for line in "${certificates_lines[@]}"
do
   :
   if [ "$line" == '[[tls]]' ]; then
       echo "  [[tls.certificates]]" >> $new_certificates
       continue
   elif [ "$line" == *"entryPoints = [\"https\"]"* ] || [ "$line" == *"[tls.certificate]"* ] || [[ $line == *"entryPoints"* ]]; then
       continue
   elif [ "$line" == *"[tls.certificate]"* ]; then
       continue
   else
       echo "$line" >> $new_certificates
   fi
done