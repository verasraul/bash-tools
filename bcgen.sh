#!/bin/bash

for i in $(cat bcgen.txt | awk '{print $1}' ); do {
conf_fqdn=$i
conf_ip=$(host $i | awk '{print $4}')
echo "object Host \"$conf_fqdn\" {
  import \"broadcast-device\"
  name = \"$conf_fqdn\"
  address = \"$conf_ip\"

  vars.owner = \"Broadcast\"
  vars.facility = \"OMA2\"
  vars.device_type = \"IPMV\"
}
">> ~/workspace/test/broadcast/devices/$i.conf
} ; done
