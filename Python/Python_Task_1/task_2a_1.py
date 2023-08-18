"""
Process the nat string in such a way that instead of FastEthernet in the interface name there is
gigabit ethernet.
"""
nat = "ip nat inside source list ACL interface FastEthernet0/1 overload"


if __name__ == "__main__":
    print(nat.replace('Fast', 'Gigabit'))

