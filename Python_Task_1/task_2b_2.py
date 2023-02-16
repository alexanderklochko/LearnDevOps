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

ip_addr = list(map(int, input(
    "Enter the IP address in 10.0.1.1 form: ").split(".")))

if ip_addr[0] in range(1, 224):
    print("unicast")
elif ip_addr[0] in range(224, 241):
    print("multicast")
elif ip_addr == [255, 255, 255, 255]:
    print("local broadcast")
elif ip_addr == [0, 0, 0, 0]:
    print("unassigned")
else:
    print("unused")


