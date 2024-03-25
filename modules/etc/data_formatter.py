num = 0xeb2c4575fa7a162db776e9751d0d21346ba65f6ea407919ffe0c1abcbadc47089860922ea3a8b3d2ed340862c3c0b4b662ae3ef48f3fd1786b8ba11d130c05f5
find = 0xa3a8b3d2
for i in range(16):
    if (num >> (i*32) & 0xFFFFFFFF == find):
        print(i)
        break
    
for i in range(16):
    print(i, "\t:\t", hex(num >> (i*32) & 0xFFFFFFFF))