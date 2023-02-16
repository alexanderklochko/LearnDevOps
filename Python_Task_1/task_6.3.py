"""
Make a configuration generator for trunk ports. There is a list corresponding to each port
and the first (zero) element of the list indicates how accept VLAN numbers that go further:
• add - VLANs will need to be added (command switchport trunk allowed vlan add 10,20)
• del - VLANs must be removed from the allowed list (switch-port trunk allowed vlan remove 17 command)
• only - only the specified VLANs must remain allowed on the interface (switch-port trunk
allowed vlan 11.30)
Task for ports 0/1, 0/2, 0/4:
• generate a configuration based on the template trunk_template
• taking into account keywords add, del, only
The code should not be tied to specific port numbers. That is, if there are other numbers in the trunk dictionary
interfaces, the code should work.
"""
access_template = [
    'switch-port mode access', 'switch-port access vlan',
    'spanning-tree port fast', 'spanning-tree bpduguard enable'
]
trunk_template = [
    'switch-port trunk encapsulation dot1q', 'switch-port mode trunk',
    'switch-port trunk allowed vlan'
]
access = {
    '0/12': '10',
    '0/14': '11',
    '0/16': '17',
    '0/17': '150'
}
trunk = {
    '0/1': ['add', '10', '20'],
    '0/2': ['only', '11', '30'],
    '0/4': ['del', '20']
}
if __name__ == "__main__":
    for intf, values in trunk.items():
        print('interface FastEthernet' + intf)

        if values[0] == "add":
            print(f'''{trunk_template[1]}\n{trunk_template[0]}\n{trunk_template[2]}'''
                  f''' add {values[1]}, {values[2]}''')
        elif values[0] == "only":
            print(f'''{trunk_template[1]}\n{trunk_template[0]}\n{trunk_template[2]}'''
                  f''' {values[1]}, {values[2]}''')
        else:
            print(f'''{trunk_template[1]}\n{trunk_template[0]}\n{trunk_template[2]}'''
                  f''' remove {values[1]}''')
