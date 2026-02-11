
import socket
hostname = socket.gethostname()
ip_address = socket.gethostbyname(hostname)
with open("ip.txt", "w") as f:
    f.write(ip_address)
