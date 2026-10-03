#!/usr/bin/env python3
import argparse, socket

def genHostObj(fqdn, ipv4, dc, owner, template, parent):
    hostTemp = '''object Host "{hostname}" {{
  name = "{hostname}"
  import "{template}"
  address = "{address}"
  vars.vendor = "Supermicro"
  vars.hostgroup = "MD-LIVE"
  vars.owner = "{owner}"
  vars.facility = "{facility}"
  vars.platform = "baremetal"
}}
object Endpoint "{hostname}" {{
  log_duration = 0
}}
object Zone "{hostname}" {{
  endpoints = [ "{hostname}" ]
  parent = "{parent}"
}}'''.format(hostname=fqdn, address=ipv4, facility=dc, owner=owner, template=template, parent=parent)
    return hostTemp

def mapMidtier(dc):
  zone = None
  zones = {
    'adm2-dmz': [ 'atl1', 'dfw1', 'ewr1', 'jfk3', 'lax1', 'ord1', 'sea1' ],
    'adm3-dmz': [ 'ams1', 'arn1', 'fra1', 'lhr1', 'mad1' ],
    'adm4-dmz': 'mrs1',
    'adm6-dmz': [ 'sin1', 'syd1'],
    'adm7-dmz': [ 'bog1', 'eze1', 'gru1', 'mia1', 'scl1' ],
  }
  for key in zones.keys():
    for value in zones[key]:
      if dc == value: zone = key
  return(zone)

def main():
  parser = argparse.ArgumentParser(description='For generating Icinga2 hostobject configs.')
  parser.add_argument('fqdns', metavar='F', type=str, nargs='+',
                      help='one or more fully-qualified domain names')
  parser.add_argument("-d", "--datacenter", type=str, required=False,
                      help="manually specifiy host datacenter facility")
  parser.add_argument("-e", "--environment", type=str, required=False,
                      help="manually specifiy environment (prod or nonprod)")
  parser.add_argument("-m","--midtier", default=False, action='store_true',
                      help="define config as a midtier host")
  parser.add_argument("-o", "--owner", type=str, required=True,
                      help="define department that owns host")
  parser.add_argument("-t", "--template", type=str, required=True,
                      help="import Icinga check template to host configuration file.")
  parser.add_argument("-p","--place", default=False, action='store_true',
                      help="place config into appropriate Icinga2 directory")

  argList = parser.parse_args()

  for i in range(len(argList.fqdns)):
    fqdn = argList.fqdns[i]
    fSplit = fqdn.split('.')
    owner = argList.owner
    template = argList.template if argList.template else "generic-host"
    if len(fSplit) == 8:
      dc = fSplit[4]
      env = fSplit[5]
    elif argList.datacenter is not None and argList.environment is not None:
      dc = argList.datacenter
      env = argList.environment
    else:
      print("FQDN(s) is/are in a non-standard hostname format, or you are not using BOTH '-d' && '-e'.")
      print("See '--help' for manually declaring datacenter && environmental variables via arguments.")
      exit()
    ipv4 = socket.gethostbyname(fqdn)
    if argList.midtier is True:
      dc = mapMidtier(dc)
      parent, zone = dc, dc
      dc = dc[:4]
      hostObject = genHostObj(fqdn, ipv4, dc, owner, template, parent)
    else:
      parent, zone = dc, dc
      hostObject = genHostObj(fqdn, ipv4, dc, owner, template, parent)
    if argList.place == True:
      if env == "dev" or env == "lab" or env == "nonprod" or env == "qa":
          path = "../etc/qa/master01.adm1/icinga2/zones.d/satellite/"
      elif env == "prod" or env == "stor" or env == "util":
          path = "../etc/prod/master01.adm1/icinga2/zones.d/" + zone + "/" + owner + "/"
    else:
      path = "./"
    with open(path + fqdn + '.conf', 'w') as output:
      output.write(hostObject)

main()
