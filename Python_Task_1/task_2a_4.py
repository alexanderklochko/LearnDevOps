"""
The VLANs list contains VLANs collected from all network devices, so the list contains
duplicate VLAN numbers.
From the list you need to get a unique list of VLANs, sorted in ascending order rooms.
"""
vlan_list = [10, 20, 30, 1, 2, 100, 10, 30, 3, 4, 10]
uniq_vlan = sorted(set(vlan_list))

if __name__ == "__main__":
    print(uniq_vlan)
