import pandas as pd
import numpy as np 
import matplotlib.pyplot as plt
import seaborn as sns 
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



def setcolorandstyle(labels):
    palette=setcolors(labels)

    colordf=pd.DataFrame()
    colordf['label']=labels
    colordf['color']=palette
    colordf.set_index('label', drop=True, inplace=True)
    sns.set()
    sns.set_style("white")
    sns.set_style( "ticks",{"xtick.direction": "in","ytick.direction": "in"})
    sns.set_context("paper")

    return palette

def setgrl(labels, fig, axes, h,l):
    palette= setcolorandstyle(labels)
    #fontsll
    font_path="/usr/share/fonts/truetype/msttcorefonts"
    myfont= "arial.tff"
    plt.rcParams['font.family']='Arial'
    fig.set_figheight(h)
    fig.set_figwidth(l)
    return palette

def labelsubplots(axes, loc):
    alpha=['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H']
    if loc in "uleft":
        xy = (0.05, 0.85)
    elif loc == "lleft":
        xy = (0.05, 0.05)
    elif loc == "lright":
        xy = (0.85, 0.5)
    elif loc == "uright":
        xy = (0.85, 0.85)

    for i in range(len(axes)):
        text = axes[i].annotate(alpha[i], weight='bold', size=12, xy=xy, xycoords="axes fraction")


def savefigure(name):
    path= "/home/akh/myprojects/channelized-pdcs/graphs/figures"
    fid=name + '.eps'
    plt.savefig(fid, format='eps', dpi=600)

def plottogether(labels, fid, df, ylab, xlab):
    fig, ax = plt.subplots()
    palette=setgrl(labels, fig, ax, 5, 5)
    print(len(palette))
    print("plotting")
    print(fid)
    df.fillna(0)
    
    for i in labels:
        x=df[i]
        time=np.arange(0,5*(len(x)),5)
        j=labels.index(i)
        plt.plot(time, x, color=palette[j], label=i)
    ax.legend(bbox_to_anchor=(1.01, 1.01))
    ax.set_xticklabels(time)
    ax.set_xlabel(xlab)
    ax.set_ylabel(ylab)
    ax.set_xlim(left=0)
    plt.tight_layout()
    savefigure(fid)

def horizplot(df, loc, labels):
    maxy=(len(df))
    top=3*maxy
    height = np.arange(0,top,3)
    palette=setcolorandstyle(labels)

    df1=df.fillna(df.min())
    for i in df.columns:
        j=labels.index(i)
        loc.plot(df1[i], height, label=i, color=palette[j] )

def plotallcol(labels, fid, df1, df2, df3, df4, df5):
    fig, axes= plt.subplots(1,4, sharey=True, sharex=False)
    setgrl(labels, fig, axes, 4, 8)
    df5.fillna(273.0)
    # EPP
    loc=axes[0]
    horizplot(df1, loc, labels)
    axes[0].set_ylabel('Height (m)', size=9)
    axes[0].set_xlabel('Log Volume fraction', size=9)
    loc.set_ylim([0,150])
    loc.set_xlim([0,14])
    sns.despine()
    # UG
    loc=axes[1]
    u0=10.0
    horizplot(df2/u0, loc, labels)
    axes[1].set_xlabel('Velocity (U/U0)',size=9)
    loc.set_ylim([0,150])

    # temperature
    loc=axes[2]
    t0=800.0
    temp=df5.astype(float)
    horizplot(temp/t0, loc, labels)
    axes[2].set_xlabel('Temperature (T/T0)', size=9)
    loc.set_ylim([0,150])

    # DPU
    loc=axes[3]
    horizplot(df3, loc, labels)
    axes[3].set_xlabel('Dynamic Pressure', size=8)
    loc.set_ylim([0,150])

    # Richardson Number
    # loc=axes[4]
    # horizplot(df4, loc, labels)
    # axes[4].set_xlabel('Richardson Number')
    # loc.set_xlim([-5, 5])
    # loc.set_ylim([0,150])



    fig.legend(    # The line objects
           labels=df1.columns,   # The labels for each line
           loc="center right",   # Position of legend
           borderaxespad=0.5,    # Small spacing around legend box
           title="Geometries",  # Title for the legend
           )

    labelsubplots(axes, "uright")

    savefigure(fid)
    #plt.show()

def plotby(labels, fid, df1, df2, datalabel1, datalabel2):
    fig, ax = plt.subplots()
    palette = setgrl(labels, fig, ax, 5, 4)
    for sim in labels:
        i=labels.index(sim)
        c=palette[i]
        df3=pd.DataFrame()
        df3['x']=df2[sim]
        df3[sim]=df1[sim]
        sns.lineplot(x=df3.x, y=df3.iloc[:,1], color=c, label=sim, legend='brief')
    ax.set_ylabel(datalabel1)
    ax.set_xlabel(datalabel2)
    savefigure(fid)

def channelfrontplot(labels, fig, ax, front, data, xlabel, wavelabel, wave):
    palette = setgrl(labels, fig, ax, 5, 4)
    amp = 0.15*wave
    x = np.linspace(0,1200,70)
    channel = amp*np.sin((x/wave)*(2*np.pi)) + 450
    y2= max(data.max())
    y1= min(data.min())
    ax.set_ylim([0,900])
    ax.set_xlim([0,1200])
    ax.plot(x, channel, color='grey')
    width=[200,300]
    wcolor=['darksalmon', 'lightskyblue']
    #for i in range(len(wcolor)):
    #    ax.plot(x,channel-width[i]/2, color=wcolor[i])
    #    ax.plot(x,channel+width[i]/2, color=wcolor[i])

    ourlabels=[s for s in labels if wavelabel in s]
    ax2=ax.twinx()

    ax.get_yaxis().set_ticks([])

    for sim in ourlabels:
        i=labels.index(sim)
        ax2.plot(front[sim], data[sim], label=sim, color=palette[i])

    ax2.set_xlabel(xlabel)
    ax2.set_ylim([y1-y2, y2+y2*.10])
    #plt.show()

def twotime(labels, fid, df1, df2, datalabel1, datalabel2):

    fig3, ax1 = plt.subplots()
    palette= setgrl(labels, fig3, ax1, 4, 4)
    ax2= ax1.twinx()
    for sim in labels:
        i=labels.index(sim)
        c=palette[i]
        df3=pd.DataFrame()
        df3['x']=df2[sim]
        df3[sim]=df1[sim]
        ax1.plot(df1, color=c, label=sim)
        ax2.plot(df2, color=c)

    ax1.set_ylabel(datalabel1)
    ax2.set_ylabel(datalabel2)
    ax1.set_xlabel("Time")
    savefigure(fid)

def channelfrontsubplot(labels, fid, front, data, ylab):
    fig, axes = plt.subplots(4, 1, sharex=True)
    palette= setgrl(labels, fig, axes, 6, 3)
    axes[3].set_xlabel("Down Slope distance (m)")
    channelfrontplot(labels, fig, axes[0], front, data, ylab, 'A', 300.)
    channelfrontplot(labels, fig, axes[1], front, data, ylab, 'B', 600.)
    channelfrontplot(labels, fig, axes[2], front, data, ylab, 'C', 900.)
    channelfrontplot(labels, fig, axes[3], front, data, ylab, 'E', 1200.)
    labelsubplots(axes, "uleft")
    savefigure(fid)