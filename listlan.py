# List devices on the local wireless lan with their hostnames 
# and ip addresses
import socket
import logging

VERBOSE = 0

logging.getLogger("scapy.runtime").setLevel(logging.ERROR)
from scapy.all import ARP, Ether, srp

#logging.basicConfig(filename='logs/lslan.log', level=logging.INFO)

def get_hostname(ip):
    try:
        hostname = socket.gethostbyaddr(ip)[0]
        hostname = hostname.replace(".attlocal.net","")
    except socket.herror:
        print(f'Could not find hostname for {ip}')
        hostname = "none"
    return hostname

# Target IP range
# print("Setting up IP range...")
ip_range = "192.168.1.1/24"

# Create ARP packet
#logging.info("Creating ARP packet...")
arp = ARP(pdst=ip_range)

#logging.info("setting up ether...")
  
ether = Ether(dst="ff:ff:ff:ff:ff:ff")
packet = ether/arp


#logging.info("Checking available ip addresses...")
# Send packet and get response
result = srp(packet, timeout=10, verbose=0)[0]

# Print device details
# print("IP                              MAC")
# print("----------------------------------------------")

# available fields
# received.psrc => ip address
# received.hwsrc => mac address
for sent, received in result:
   print(get_hostname(received.psrc) + "(" +  received.psrc + ") \n")

