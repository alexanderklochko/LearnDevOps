"""
Complete the script: If the address was entered incorrectly,
ask for entering the address again.
"""
import sys


def validate_ip(inputted_ip: list) -> bool:
    """
    Check if inputted string is a correct IP address
    :return: True if it is a correct IP address or None with warning message
    in otherwise
    """
    warning_message = "This IP is not correct!" \
                      "\nPlease, reentry the IP address correctly"
    if len(inputted_ip) != 4:
        sys.exit(warning_message)
    for x in inputted_ip:
        if not x.isdigit():
            sys.exit(warning_message)
        i = int(x)
        if i < 0 or i > 255:
            sys.exit(warning_message)
    else:
        return True


if __name__ == "__main__":
    inputted_string = "".join(sys.argv[1:]).split(".")

    if validate_ip(inputted_string) is True:
        if 1 <= int(inputted_string[0]) <= 223:
            print("unicast")
        elif 224 <= int(inputted_string[0]) <= 239:
            print("multicast")
        elif inputted_string == ["255", "255", "255", "255"]:
            print("local broadcast")
        elif inputted_string == ["0", "0", "0", "0"]:
            print("unassigned")
        else:
            print("unused")
