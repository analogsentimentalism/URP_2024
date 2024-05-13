import os

path = os.path.dirname(os.path.realpath(__file__))+'\\'

with open(path+"qr.dump", 'r') as file:
    lines = file.readlines()
    with open(path+"qr.txt", 'w') as new_file:
        for line in lines:
            if(line[0] != ' '):
                continue
            line_temp = line.strip().split("\t")
            print(line_temp[1].strip())
            new_file.write(line_temp[1].strip()+'\n')