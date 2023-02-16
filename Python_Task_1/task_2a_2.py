"""
Convert string mac from format XXXX:XXXX:XXXX
into the format XXXX.XXXX.XXXX.XXXX.XXXX.XXXX
"""
mac = "AAAA:BBBB:CCCC"

if __name__ == "__main__":
    print(mac.replace(":", "."))
