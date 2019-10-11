import pandas as pd
import numpy as np 
import matplotlib.pyplot as plt
import seaborn as sns 


alllabels= [ "AVY4","AWX4", "AWY4", "BVY4", "BWX4", "CVY4", "CWX4", "SV4", "SV7", "BVY4", "CWY7", "CWY4", "SW7", "SV7"]
alllabels.sort()

def setcolors(labels):
    length=len(labels)

    Alabel=0
    Blabel=0
    Clabel=0
    Slabel=0 
    Elabel=0
    Dlabel=0

    for i in labels:
        if "A" in i:
            Alabel+=1
        elif "B" in i:
            Blabel+=1
        elif "C" in i:
            Clabel+=1
        elif "S" in i:
            Slabel+=1
        elif "E" in i:
            Elabel+=1
        elif "D" in i:
            Dlabel+=1

    Acolors=sns.color_palette("Reds", Alabel)
    Bcolors=sns.color_palette( "YlGn", Blabel)
    Ccolors=sns.color_palette("Blues", Clabel)
    Dcolors=sns.color_palette("PuBu", Clabel)
    Ecolors=sns.color_palette("Purples", Clabel)
    Scolors=sns.color_palette("Greys", Slabel )

    temp_colors= Acolors+Bcolors+Ccolors+Scolors

    colors= sns.color_palette(temp_colors)

    return colors


colors= setcolors(alllabels)
sns.palplot(colors)
plt.show()
#sns.set_palette()

