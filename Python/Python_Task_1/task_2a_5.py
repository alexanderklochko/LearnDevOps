"""
Get the VLANs list from strings command1 and command2, which are in the
command1 and command2.
Result must be in the form: ['1', '3', '8']
"""

command1: str = 'switch-port trunk allowed vlan 1,2,3,5,8'
command2: str = 'switch-port trunk allowed vlan 1,3,8,9'

set_command1 = set(command1.split()[-1].split(",", ))
set_command2 = set(command2.split()[-1].split(",", ))

if __name__ == "__main__":
    print(sorted(set_command1 & set_command2), )
