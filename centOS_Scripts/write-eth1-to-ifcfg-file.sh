# Use this script file to create the eth1 device in the ifcfg file for the minimal
# Centos OS distribution.
 
echo "Creating ifcfg-eth1 file..."
touch /etc/sysconfig/network-scripts/ifcfg-eth1
echo "File created!"
echo "Editing file; configuring settings for eth1 device"
cat >> /etc/sysconfig/network-scripts/ifcfg-eth1 << EOL

DEVICE=eth1
BOOTPRO=static
IPADDR=192.168.56.101
NETMASK=255.255.255.0
ONBOOT=yes
EOL

echo "Editing complete!"
ifup ifcfg-eth1
echo "You're now able to too ssh into your vm using the ssh username@ip.add.re.ss format"
echo "PROCESS COMPLETE!"


