"""
Gen VLANs list from the config string.
"""
config = "switch-port trunk allowed vlan 1,3,10,20,30,100"

if __name__ == "__main__":
    print(config.split()[-1].split(","), )
