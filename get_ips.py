import socket
try:
    hostname = socket.gethostname()
    ip_list = socket.gethostbyname_ex(hostname)[2]
    print(f"Hostname: {hostname}")
    print("IP Addresses:")
    for ip in ip_list:
        print(f"  {ip}")
except Exception as e:
    print(f"Error: {e}")
