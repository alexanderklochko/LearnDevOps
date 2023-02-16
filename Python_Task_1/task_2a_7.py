"""
Process the MAC-address mac to the binary string in the form:
101010101010101010111011101110111100110011001100
"""

mac = "AAAA:BBBB:CCCC"
mac = '{:b}'.format((int(mac.replace(":", ""), base=16)))

if __name__ == "__main__":
    print(mac)
