def inc(c):
    c_str = "{:03d}".format(c)
    a,b,c = int(c_str[0]), int(c_str[1]), int(c_str[2])
    if c >= 5:
        c = 0
        if b >= 5:   
            a += 1
            b = 0
        else:
            b += 1
    else: 
        c +=1
    return int(str(a) + str(b) + str(c))

def blacklist(c):
    c_str = "{:03d}".format(c)
    count = 0
    max = 3 # set 2 or 3; 3->56 2->108
    if int(c_str[0]) <= max:
        count += 1
    if int(c_str[1]) <= max:
        count += 1
    if int(c_str[2]) <= max:
        count += 1
    return count >= 2

p = 0
t = 0
for i in range(6*6*6):
    if blacklist(p): 
        p = inc(p)
        continue
    t+=1
    #print('    ["{:<}"] = "{:03d}",'.format(i, p)) # LUA
    print('\t\t\t\t\t, "{:03d}": "{}"'.format(p, i)) # AHK
    p = inc(p)
print(t)
