#!/bin/bash

for i in $(cat inv.ini | awk '{print $1}' ); do {
conf_fqdn=$i
conf_ip=$(dig +short $i)

echo "object Host \"$conf_fqdn\" {
  import \"hadoop\"
  name = \"$conf_fqdn\"
  address = \"$conf_ip\"
  vars.vendor = \"DELL\"
  vars.monitoring_team = \"ContractorOps\"
  vars.owner = \"BDI\"
  vars.facility = \"las\"
  vars.platform = \"baremetal\"
}
object Endpoint \"$conf_fqdn\" {
  log_duration = 0
}
object Zone \"$conf_fqdn\" {
  endpoints = [ \"$conf_fqdn\" ]
  parent = \"las\"
}
"> $i.conf
} ; done
