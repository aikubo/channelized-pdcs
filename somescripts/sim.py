import numpy as np
labelwave=['S', 'A', 'B', 'C', 'D', 'E']
wave=[0, 300,600,900,1200,2400]

labelamp=['X', 'Y', 'Z']
amp=[9,15,20]

widdepth=['N', 'V', 'W']
width=[100, 200, 300]
depth=[15, 27, 39]

vollabel=[ '1', '4', '7', '0']
vol=[ 0.1, 0.4, 0.7, 1.0]

def paramwhat(i,name,param):
    x= name.index(i)
    y= param[x]
    y=str(y)
    return y

y =paramwhat('S', labelwave, wave)
fid = 'help.txt'


print(y)
for i in labelwave: 
    for j in widdepth:
        for k in labelamp:
            for z in vollabel:
                label = (i+j+k+z)

                L=paramwhat(i,labelwave, wave)
                A=paramwhat(k, labelamp, amp)
                W=paramwhat(j,widdepth, width)
                D=paramwhat(j,widdepth, depth)
                H=paramwhat(z,vollabel, vol)
                H= np.ceil(float(H)*float(D)/3)*3

                tot= label+','+L+','+A+','+W+','+ str(H)

                with open(fid, 'a') as file:
                    file.write(tot+'\n')
