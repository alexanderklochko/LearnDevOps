"""
The mac list contains MAC addresses in the format XXXX:XXXX:XXXX. However, in cisco equipment, MAC addresses
are used in the format XXXX.XXXX.XXXX.
Create a script that converts MAC addresses to cisco format and adds them to a new mac_cisco list
"""

mac = ['aabb:cc80:7000', 'aabb:dd80:7340', 'aabb:ee80:7000', 'aabb:ff80:7000']
mac_cisco = []
for item in mac:
    mac_cisco.append(item.replace(":", "."))


if __name__ == "__main__":
    print(mac_cisco)
