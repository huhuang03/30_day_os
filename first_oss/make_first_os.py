import os
from binascii import unhexlify

hex = """EB 4E 90 48 45 4C 4C 4f - 49 50 4C 00 02 01 01 00 
         02 E0 00 40 0B F0 09 00 - 12 00 02 00 00 00 00 00
         40 0B 00 00 00 00 29 FF - FF FF FF 48 45 4C 4C 4F 
         2D 4F 53 20 20 20 46 41 - 54 31 32 20 20 20 00 00
         00 00 00 00 00 00 00 00 - 00 00 00 00 00 00 00 00
         B8 00 00 8E D0 BC 00 7C - 8E D8 8E C0 BE 74 7C 8A
         04 83 C6 01 3C 00 74 09 - B4 0E BB 0F 00 CD 10 EB
         EE F4 EB FD 0A 0A 68 65 - 6C 6C 6F 2C 20 77 6F 72
         6C 64 0A 00"""


with open("first_os.img", 'wb') as f:
    for i in range(0, 0x168010):
        f.write(b'\x00')

    f.seek(0)
    f.write(unhexlify(hex.replace(" ", "").replace("-", "").replace('\n', '')))
    f.seek(0x1FE)
    f.write(bytes(bytearray([0x55, 0xAA, 0xF0, 0xFF])))
    f.seek(0x1400)
    f.write(bytes(bytearray([0xF0, 0xFF, 0xFF])))

