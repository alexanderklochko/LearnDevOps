"""
Convert IP address to binary format and output to standard output
columns for example output for the address 10.1.1.1:
10 1 1 1
00001010 00000001 00000001 00000001
"""
ip = '192.168.3.1'
ip_list = ip.split(".", )

if __name__ == "__main__":
    print(f"""
    {ip_list[0]} {ip_list[1]} {ip_list[2]} {ip_list[3]}
    {int(ip_list[0]):08b} {int(ip_list[1]):08b} {int(ip_list[2]):08b} {int(ip_list[3]):08b}""")
