import pandas as pd
import numpy as np 
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import os 
from matplotlib.ticker import (MultipleLocator, FormatStrFormatter, AutoMinorLocator)
import matplotlib.ticker

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

def printlegend(labels, filename):
    colors = setcolors(labels)
    fig = plt.figure()
    patches = [ 
        mpatches.Patch(color=color, label=label) 
        for label, color in zip(labels, colors)]
    fig.legend(patches, labels, loc='center', frameon=False)
    savefigure(filename)
    


def setcolorandstyle(labels):
    palette=setcolors(labels)

    sns.set()
    sns.set_style("whitegrid")
    sns.set_style( "ticks",{"xtick.direction": "in","ytick.direction": "in"})
    sns.set_context("paper")

    return palette

def setgrl(labels, fig, axes, h,l):
    palette= setcolorandstyle(labels)
    #fontsll
    font_path="/usr/share/fonts/truetype/msttcorefonts"
    myfont= "arial.tff"
    plt.rcParams['font.family']='Arial'
    plt.rcParams["font.size"] = "36"
    fig.set_figheight(h)
    fig.set_figwidth(l)
    return palette

def labelsubplots(axes, loc):
    alpha=['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
    if loc in "uleft":
        xy = (0.05, 0.8)
    elif loc == "lleft":
        xy = (0.05, 0.05)
    elif loc == "lright":
        xy = (0.85, 0.5)
    elif loc == "uright":
        xy = (0.85, 0.85)

    for i in range(len(axes)):
        text = axes[i].annotate(alpha[i], weight='bold', size=10, xy=xy, xycoords="axes fraction")


def savefigure(name):
    path= os.getcwd()
    path+= "/figures/"
    fid=name + '.eps'
    #fid=path + name +'.png'
    plt.savefig(fid, dpi=600)

def plottogether(labels, fid, df, ylab, xlab):

    fig, ax=plt.subplots()

    palette=setgrl(labels, fig, ax, 5, 5)
    print(len(palette))
    print("plotting")
    print(fid)
    df.fillna(0)
    
    for i in labels:
        x=df[i]
        j=labels.index(i)
        time=np.arange(0,35,5)
        plt.plot(time, x, color=palette[j], label=i)

   # ax.legend(bbox_to_anchor=(1.01, 1.01))
    ax.set_xticks(time)
    ax.set_xlabel(xlab)
    ax.set_ylabel(ylab)
    ax.set_xlim(left=0)
    plt.tight_layout()
    plt.show()
    #savefigure(fid)

def plottogether3(labels, fid, df, ylab, xlab,ticks):

    fig, ax=plt.subplots()

    palette=setgrl(labels, fig, ax, 5, 5)
    print(len(palette))
    print("plotting")
    print(fid)
    df.fillna(0)
    
    for i in labels:
        x=df[i]
        j=labels.index(i)
        plt.plot(ticks, x, color=palette[j], label=i)
   # ax.legend(bbox_to_anchor=(1.01, 1.01))
    ax.set_xlabel(xlab)
    ax.set_ylabel(ylab)
    ax.set_xlim(left=0)
    plt.tight_layout()
    plt.show()
    #savefigure(fid)


def plotscatter(labels, fid, x,y, ylab, xlab, fig, ax):
    palette=setcolors(labels)
    print("plotting")
    print(fid)
    for sim in labels:
        i=labels.index(sim)
        plt.scatter(x[sim], y[sim], color=palette[i])
    ax.set_xlabel(xlab)
    ax.set_ylabel(ylab)
    savefigure(fid)


def plottogether2(labels, fid, df, x, ylab, xlab, fig, ax):
    labels=df.columns.tolist()
    palette=setcolors(labels)
    print(len(palette))
    print("plotting")
    print(fid)
    df.fillna(0)
    
    for i in labels:
        y=df[i]
        j=labels.index(i)
        ax.plot(x,y, color = palette[j], label=i)

    ax.set_xlabel(xlab)
    ax.set_ylabel(ylab)

def pltbytimebyx(df, t, fig, ax):
    labels=df.columns.tolist()
    palette=setcolors(labels)
    start=(t*404)
    end=(t+1)*404
    xxx=np.arange(0,1212,3)

    for i in labels:
        y_temp=df[i]
        y=y_temp[start:end]
        j=labels.index(i)
        ax.plot(xxx,y, color=palette[j], label=i)


def horizplot(df, loc, labels):
    maxy=(len(df))
    top=3*maxy
    height = np.arange(0,top,3)
    #palette=setcolorandstyle(labels)

    df1=df.fillna(df.min())
    for i in df.columns:
        j=labels.index(i)
        loc.plot(df1[i], height, label=i, linewidth=2 )

def cm2inch(*tupl):
    inch = 2.54
    if isinstance(tupl[0], tuple):
        return tuple(i/inch for i in tupl[0])
    else:
        return tuple(i/inch for i in tupl)

def plotallcol( fig, axes, labels, fid, df1, df2, df3, df4, df5):
    #fig, axes= plt.subplots(1,4, sharey=True, sharex=False)
    #setgrl(labels, fig, axes, 5, 8)
    df5.fillna(273.0)

    for i in range(len(axes)):
        axes[i].tick_params(labelsize=8) 
    # EPP
    loc=axes[0]
    fonts= 8
    EPP=10**(-1*df1)
    horizplot(EPP, loc, labels)
    loc.set(xscale='log')
    axes[0].set_ylabel('Height (m)', fontsize=fonts)
    axes[0].set_xlabel('Volume  Fraction',fontsize=fonts)
    loc.set_ylim([0,35])
    loc.set_xlim([10**-8, 1])
    loc.set_xticks([ 10**-7, 10**-5, 10**-3, 10**-1])
    locmin=matplotlib.ticker.LogLocator(base=10.0, subs=(0.1,0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9), numticks=12)
    loc.xaxis.set_minor_locator(locmin)
    loc.xaxis.set_minor_formatter(matplotlib.ticker.NullFormatter())

    loc.spines['right'].set_color('none')
    loc.spines['top'].set_color('none')
    loc.spines['left'].set_position(('outward', 5))
    # UG
    loc=axes[1]
    u0=10.0
    horizplot(df2, loc, labels)
    axes[1].set_xlabel('Velocity (m/s)',fontsize=fonts)
    loc.set_ylim([0,35])
    loc.set_xlim([-7,30])
    loc.spines['right'].set_color('none')
    loc.spines['top'].set_color('none')
    loc.spines['left'].set_position(('outward', 5))
    loc.set_xticks([0,10, 20,30])
    loc.xaxis.set_minor_locator(MultipleLocator(2))
    loc.tick_params(which='both')

    # temperature
    loc=axes[2]
    t0=800.0
    temp=df5.astype(float)
    print(temp-273)
    horizplot(temp-273, loc, labels)
    axes[2].set_xlabel('Temperature (C)', fontsize=fonts)
    loc.set_ylim([0,35])
    loc.set_xticks([100,300,500])
    loc.spines['right'].set_color('none')
    loc.spines['top'].set_color('none')
    loc.spines['left'].set_position(('outward', 5))
    loc.xaxis.set_minor_locator(MultipleLocator(50))
    loc.tick_params(which='both')

    # DPU
    loc=axes[3]
    #dpu=np.log10(df3+(10**-5))
    loc.set(xscale='log')
    loc.set_ylim([0,35])
    horizplot(df3/1000, loc, labels)
    axes[3].set_xlabel('Dynamic Pressure (kPa)', fontsize=fonts)
    loc.get_xaxis().get_major_formatter().labelOnlyBase=False
    loc.set_xticks([1, 10, 10**2])
    loc.spines['right'].set_color('none')
    loc.spines['top'].set_color('none')
    loc.spines['left'].set_position(('outward', 5))
    locmin=matplotlib.ticker.LogLocator(base=10.0, subs=(0.4,0.6,0.8), numticks=12)
    #locmaj=matplotlib.ticker.LogLocator(base=10.0)
    loc.xaxis.set_minor_locator(locmin)
    #loc.xaxis.set_major_locator(locmaj)
    #loc.xaxis.set_major_formatter(matplotlib.ticker.NullFormatter())

    #loc.xaxis.set_minor_formatter(matplotlib.ticker.NullFormatter())
   

    loc.set_ylim([0,50])
    loc.set_xlim([.1,10**2.5])
    

    # Richardson Number
    # loc=axes[4]
    # horizplot(df4, loc, labels)
    # axes[4].set_xlabel('Richardson Number')
    # loc.set_xlim([-5, 5])
    # loc.set_ylim([0,150])



    # fig.legend(    # The line objects
    #        labels=df1.columns,   # The labels for each line
    #        loc="center right",   # Position of legend
    #        borderaxespad=0.5,    # Small spacing around legend box
    #        title="Geometries",  # Title for the legend
    #        )

    #labelsubplots(axes, "uright")

    #savefigure(fid)
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
    palette = setgrl(labels, fig, ax, 6, 5)
    amp = 0.15*wave
    x = np.linspace(0,1200,70)
    channel = amp*np.sin((x/wave)*(2*np.pi)) + 450
    y2= max(data.max())
    y1= min(data.min())
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
    ax2.set_ylim([y1, y2+y2*.10])
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
    fig, axes = plt.subplots(3, 1, sharex=True)
    palette= setgrl(labels, fig, axes, 6, 3)
    axes[2].set_xlabel("Down Slope distance (m)")
    channelfrontplot(labels, fig, axes[0], front, data, ylab, 'A', 300.)
    channelfrontplot(labels, fig, axes[1], front, data, ylab, 'B', 600.)
    channelfrontplot(labels, fig, axes[2], front, data, ylab, 'C', 900.)
    labelsubplots(axes, "uleft")
    savefigure(fid)

def subplotsbywave(path, fid, datacol, out, pltby, pid, xlab, ylab):
    
    fig, axes = plt.subplots(1,4, sharey=True)
    palette=setgrl(alllabels, fig, axes, 4, 8)
    for i in waves:
        labels=[j for j in alllabels if i in j]
        print(labels)
        loc=waves.index(i)
        ax=axes[loc]
        data=openmine(labels, path, fid, datacol, out)
        plottogether2(pid, data, pltby, ylab, xlab, fig, ax)
    
    axes[0].set_ylabel(ylab)

    fig.legend(    # The line objects
            bbox_to_anchor=(1.01, 0.9), #outside on right
            labels=alllabels,   # The labels for each line
            #loc="center right",   # Position of legend
            #borderaxespad=0.5,    # Small spacing around legend box
            title="Geometries",  # Title for the legend
            )
    plt.show()
    #savefigure(pid)

def xxxplotsbywave(path, fid, datacol, out, pid, xlab, ylab):
    
    #path ="/home/akh/myprojects/channelized-pdcs/graphs/processed/"
    fig, axes = plt.subplots(1,4, sharey=True)
    palette=setgrl(alllabels, fig, axes, 5, 8)
    t=5
    for i in waves:
        labels=[j for j in alllabels if i in j]
        print(labels)
        loc=waves.index(i)
        ax=axes[loc]
        data=openmine(labels, path, fid, datacol, out)
        pltbytimebyx(data, t, fig, ax)
    
    axes[0].set_ylabel(ylab)

    fig.legend(    # The line objects
            bbox_to_anchor=(1.01, 0.9), #outside on right
            labels=alllabels,   # The labels for each line
            #loc="center right",   # Position of legend
            #borderaxespad=0.5,    # Small spacing around legend box
            title="Geometries",  # Title for the legend
            )
    #plt.show()
    savefigure(pid)

def xxxplotsnorm(path, fid1, datacol1, out1, fid2, datacol2, out2, pid, xlab, ylab):
    
    #path ="/home/akh/myprojects/channelized-pdcs/graphs/processed/"
    fig, axes = plt.subplots(1,4, sharey=True)
    palette=setgrl(alllabels, fig, axes, 5, 8)
    t=4
    for i in waves:
        labels=[j for j in alllabels if i in j]
        print(labels)
        loc=waves.index(i)
        ax=axes[loc]
        data1=openmine(labels, path, fid1, datacol1, out1)
        data2=openmine(labels, path, fid2, datacol2, out2)
        data=data1/data2
        pltbytimebyx(data, t, fig, ax)
    
    axes[0].set_ylabel(ylab)

    fig.legend(    # The line objects
            bbox_to_anchor=(1.01, 0.9), #outside on right
            labels=alllabels,   # The labels for each line
            #loc="center right",   # Position of legend
            #borderaxespad=0.5,    # Small spacing around legend box
            title="Geometries",  # Title for the legend
            )
   # plt.show()
    savefigure(pid)