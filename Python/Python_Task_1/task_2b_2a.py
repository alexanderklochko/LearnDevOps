"""
Make a copy of the task script 6.2.
Add verification of the entered IP address. An address is considered correct if it:
• consists of 4 numbers separated by a dot,
• each number between 0 and 255
If the address is set incorrectly, display the message: "Invalid IP address"
"""
ip = input("Input IP in the form x.x.x.x: ")
octets = ip.split(".")
valid_ip = len(octets) == 4

for i in octets:
    valid_ip = i.isdigit() and 0 <= int(i) <= 255 and valid_ip

if valid_ip:
    if 1 <= int(octets[0]) <= 223:
        print("unicast")
    elif 224 <= int(octets[0]) <= 239:
        print("multicast")
    elif ip == "255.255.255.255":
        print("local broadcast")
    elif ip == "0.0.0.0":
        print("unassigned")
    else:
        print("unused")
else:
    print("IP address is not correct")

