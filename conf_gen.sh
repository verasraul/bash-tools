#!/bin/bash

for i in $(cat host.txt | awk '{print $1}' ); do {
conf_fqdn=$i
conf_ip=$(host $i | awk '{print $4}')
echo "object Host \"$conf_fqdn\" {
  import \"plugin-template\"
  name = \"$conf_fqdn\"
  address = \"$conf_ip\"

  vars.owner = \"owner\"
  vars.facility = \"DC\"
  vars.device_type = \"TYPE\"
}
">> ./$i.conf
} ; done
