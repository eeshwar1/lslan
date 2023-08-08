#!/usr/bin/env bash

# <xbar.title>lslan</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.author>Venky Venkatakrishnan</xbar.author>
# <xbar.author.github>eeshwar1</xbar.author.github>
# <xbar.desc>Shows devices on the lan</xbar.desc>
# <xbar.image></xbar.image>
# <xbar.dependencies>bash</xbar.dependencies>
# <xbar.abouturl>https://github.com/eeshwar1/lslan</xbar.abouturl>


echo "lslan"
echo "My IP: $(ifconfig | grep broadcast | awk '{print $2}')"

echo "---"

pyscript="

# List devices on the local wireless lan with their hostnames 
# and ip addresses
import socket
import logging

logging.getLogger(\"scapy.runtime\").setLevel(logging.ERROR)
from scapy.all import ARP, Ether, srp


def get_hostname(ip):
    try:
        hostname = socket.gethostbyaddr(ip)[0]
        hostname = hostname.replace(\".attlocal.net\",\"\")
    except socket.herror:
        print(f'Could not find hostname for {ip}')
        hostname = \"none\"
    return hostname

# Target IP range
ip_range = \"192.168.1.1/24\"

# Create ARP packet
arp = ARP(pdst=ip_range)

ether = Ether(dst=\"ff:ff:ff:ff:ff:ff\")
packet = ether/arp


# Send packet and get response
result = srp(packet, timeout=10, verbose=0)[0]

# available fields
# received.psrc => ip address
# received.hwsrc => mac address
for sent, received in result:
   print(get_hostname(received.psrc) + \" (\" +  received.psrc + \") \n\")

"

python -c "$pyscript" | while IFS= read -r i; do echo "$i"; done