"""
Make a copy of the task script 6.2.
Add verification of the entered IP address. An address is considered correct if it:
• consists of 4 numbers separated by a dot,
• each number between 0 and 255.
If the address is set incorrectly, display the message: "Invalid IP address"
"""

ip = input("Input IP in x.x.x.x format: ")
ip_list = ip.split('.')


def validate_ip():
    """
    Check input correct IP address
    :return: True if IP address is correct or False and print warning,
    if inputted IP isn't correct
    """
    if len(ip_list) != 4:
        print("This IP is not correct!")
        return False
    for x in ip_list:
        if not x.isdigit():
            print("This IP is not correct!")
            return False
        i = int(x)
        if i < 0 or i > 255:
            print("This IP is not correct!")
            return False
    return True


def indentify_ip():
    """
    Output type of the IP address
    if the validate_ip function return 'True'
    this function execute the code
    :return: one of fourth IP address type or message: 'unused'
    """
    if validate_ip():
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


if __name__ == "__main__":
    indentify_ip()
