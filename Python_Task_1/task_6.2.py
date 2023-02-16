"""
1. Prompt the user to enter an IP address in the format 10.0.1.1
2. Determine the type of IP address.
3. Depending on the address type, output to standard output:
• "unicast" - if the first byte is in the range 1-223
• "multicast" - if the first byte is in the range 224-239
• "local broadcast" - if the IP address is 255.255.255.255
• "unassigned" - if the IP address is 0.0.0.0
• "unused" - in all other cases
"""

ip = input("Input IP in x.x.x.x format: ")
ip_list = ip.split(".")
if 1 <= int(ip_list[0]) <= 223:
    print("unicast")
elif 224 <= int(ip_list[0]) <= 239:
    print("multicast")
elif ip == "255.255.255.255":
    print("local broadcast")
elif ip == "0.0.0.0":
    print("unassigned")
else:
    print("unused")