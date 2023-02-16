"""
Process the ospf_route line and write the information to standard output in form:
Protocol: OSPF
Prefix: 10.0.24.0/24
AD/Metric: 110/41
Next-Hop: 10.0.13.3
Last update: 3d18h
Outbound
Interface:
"""

ospf_route = "O 10.0.24.0/24 [110/41] via 10.0.13.3, 3d18h, FastEthernet0/0"
ospf_route = ospf_route.replace(",", "").replace("[", "").replace("]", "")
ospf_route_list = ospf_route.split()

if __name__ == "__main__":
    print(f"Protocol: OSPF \nPrefix: {ospf_route_list[1]} \nAD/Metric: {ospf_route_list[2]}" +
          f"\nNext-Hop: {ospf_route_list[-3]} \nLast update: {ospf_route_list[-2]}" +
          f"\nOutbound \nInterface: {ospf_route_list[-1]}")
