import numpy as np
import matplotlib.pyplot as plt
import matplotlib.font_manager as font_manager
from matplotlib.offsetbox import (TextArea, DrawingArea, OffsetImage,
                                  AnnotationBbox)
from matplotlib import cm 
import pandas as pd
import seaborn as sns

#colors = sns.cubehelix_palette(8)
labels=[ "AV4", "CV4", "BW4", "SW4", "BW7", "AV7", "CV7", "EV7", "EV4", "SV4" ]
labels.sort()

def setcolorandstyle(labels):
    palette=sns.color_palette("coolwarm", len(labels))

    colordf=pd.DataFrame()
    colordf['label']=labels
    colordf['color']=palette
    colordf.set_index('label', drop=True, inplace=True)
    sns.set()
    sns.set_style("white")
    sns.set_style( "ticks",{"xtick.direction": "in","ytick.direction": "in"})
    sns.set_context("paper")

    return palette

palette= setcolorandstyle(labels)

def openslicet(labels, twant, loc):
    path2file = '/home/akh/myprojects/channelized-pdcs/graphs/processed/'
    labels = res = [k for k in labels if 'S' not in k]

    if loc in "in":
        slicefid='_slice_middle.txt'
    else :
        slicefid='_slice_outsidehalfl.txt'
    print(slicefid)
    
    slice_EPP=pd.DataFrame()
    slice_UG=pd.DataFrame()
    slice_TG=pd.DataFrame()
    slice_Ri=pd.DataFrame()
    slice_DPU=pd.DataFrame()


    UG=[]
    EPP=[]
    TG=[]
    Ri=[]
    DPU=[]

    for sim in labels:
        print(sim)
        slicet=pd.DataFrame()
        fid=path2file+sim
        loc=fid + slicefid
        slice_temp=pd.read_table(loc, header=None, sep= '\s+', skiprows=9)
        if 'S' in sim: 
            continue

        col = ['UG', 'DPU', 'TG', 'Ri' ]
        slice_temp.columns = ['time', 'YYY',  'EPP', 'UG', 'DPU', 'TG', 'Ri' ]

        for i in col:
            slicet=slice_temp[slice_temp['time']== twant]
        slicet.reset_index(drop=True, inplace=True)

        UG.append(slicet['UG'])
        EPP.append(slicet['EPP'])
        TG.append(slicet['TG'])
        DPU.append(slicet['DPU'])
        Ri.append(slicet['Ri'])

        del slicet
    slice_UG=pd.concat(UG, axis=1, ignore_index=True)
    slice_EPP=pd.concat(EPP, axis=1, ignore_index=True)
    slice_TG=pd.concat(TG, axis=1, ignore_index=True)
    slice_DPU=pd.concat(DPU, axis=1, ignore_index=True)
    slice_Ri=pd.concat(Ri, axis=1, ignore_index=True)

    slice_UG.columns=labels
    slice_TG.columns=labels
    slice_EPP.columns=labels
    slice_DPU.columns=labels
    slice_Ri.columns=labels

    return slice_UG, slice_EPP, slice_DPU, slice_TG, slice_Ri

slicein_UG, slicein_EPP, slicein_DPU, slicein_TG, slicein_Ri= openslicet(labels, 7, 'in')
sliceout_UG, sliceout_EPP, sliceout_DPU, sliceout_TG, sliceout_Ri= openslicet(labels, 7, 'out')

def opensliceavg(labels):
    path2file = '/home/akh/myprojects/channelized-pdcs/graphs/processed/'
    slicefid='_slice_x200_z150.txt'
    slice_EPP=pd.DataFrame()
    slice_UG=pd.DataFrame()
    slice_TG=pd.DataFrame()
    slice_Ri=pd.DataFrame()
    slice_DPU=pd.DataFrame()


    UG=[]
    EPP=[]
    TG=[]
    Ri=[]
    DPU=[]

    for sim in labels:
        sliceavg=pd.DataFrame()
        fid=path2file+sim
        loc=fid + slicefid
        slice_temp=pd.read_table(loc, header=None, sep= '\s+', skiprows=9)
        col = ['UG', 'DPU', 'TG', 'Ri' ]
        slice_temp.columns = ['time', 'YYY',  'EPP', 'UG', 'DPU', 'TG', 'Ri' ]

        height= slice_temp['YYY'].min()
        klength=int((456-height)/3 +1)
        height_flow= (slice_temp['YYY']-height)
        height_flow=height_flow[0:klength]


        # first split by timestep
        sliceavg=slice_temp[0:klength]
        tavg=0
        for t in range(1,9):
            bottom=(t-1)*klength
            top=t*klength
            df=slice_temp[bottom:top]
            if df.iloc[0,2] < 7.5:
                #add to average
                tavg=tavg+1
                sliceavg = sliceavg+df.values
        # divide by time
        sliceavg=sliceavg/tavg
        sliceavg.reset_index(inplace=True, drop=True)

        UG.append(sliceavg['UG'])
        EPP.append(sliceavg['EPP'])
        TG.append(sliceavg['TG'])
        DPU.append(sliceavg['DPU'])
        Ri.append(sliceavg['Ri'])

        del sliceavg

    slice_UG=pd.concat(UG, axis=1, ignore_index=True)
    slice_EPP=pd.concat(EPP, axis=1, ignore_index=True)
    slice_TG=pd.concat(TG, axis=1, ignore_index=True)
    slice_DPU=pd.concat(DPU, axis=1, ignore_index=True)
    slice_Ri=pd.concat(Ri, axis=1, ignore_index=True)

    slice_UG.columns=labels
    slice_TG.columns=labels
    slice_EPP.columns=labels
    slice_DPU.columns=labels
    slice_Ri.columns=labels

    return slice_UG, slice_EPP, slice_DPU, slice_TG, slice_Ri

def openlabel(labels):
    path2file = '/home/akh/myprojects/channelized-pdcs/graphs/processed/'
    nosefid='_nose.txt'
    froudefid='_froude.txt'
    slicefid='_slice_x200_z150.txt'
    entrainmentfid='_entrainment.txt'
    massfid='_massinchannel.txt'
    avgf='_average_all.txt'
    cross='_cross_stream.txt'
    dpu='_dpu_peak.txt'


    ent=pd.DataFrame()
    froude=pd.DataFrame()
    avg_UG=pd.DataFrame()
    front=pd.DataFrame()

    inchannelmass=pd.DataFrame()
    buoyantelutriated=pd.DataFrame()
    avulseddense=pd.DataFrame()
    avg_TG=pd.DataFrame()
    crossU=pd.DataFrame()
    crossV= pd.DataFrame()
    crossW=pd.DataFrame()

    frac_crossU=pd.DataFrame()
    frac_crossV= pd.DataFrame()
    frac_crossW=pd.DataFrame()

    peak_dpuin=pd.DataFrame()
    peak_dpuout=pd.DataFrame()


    for sim in labels:
        fid=path2file + sim
        # nose
        #loc=fid + nosefid
        #nose=pd.read_fwf(loc, header=None, skiprows=9)

        # froude
        loc=fid + froudefid
        fr_temp=pd.read_fwf(loc, header=None, skiprows=9)
        fr_temp.columns=['time', 'AvgU','AvgEP','AvgT','Froude','Front',' Width','Height' ]
        froude[sim]=fr_temp['Froude']
        front[sim]=fr_temp['Front']

        # ent
        loc=fid + entrainmentfid
        ent_temp=pd.read_fwf(loc, header=None, skiprows=9)
        ent_temp.columns=['time', 'bulk', 'medium', 'dense']
        ent[str(sim)]=ent_temp['bulk']

        # massin
        loc=fid + massfid
        mass_temp=pd.read_fwf(loc, header=None, skiprows=9)
        # t, tmass, outsum, elumass, medmass, densemass, inchannel, chmass, scalemass, scalemass1, buoyant, current
        mass_temp.columns=['time', 'Total Mass (m^3)', "Mass outside", "Dilute", "Medium", "Dense", "InChannel", "InWidth", "LtScale", "ScaleH", "Buoyant", "AvulseD"]
        mass_temp.fillna(0)
        buoyantelutriated[sim]=mass_temp['Buoyant']
        inchannelmass[sim]=mass_temp['InChannel']
        avulseddense[sim]=mass_temp['AvulseD']


        # average
        loc=fid + avgf
        avg_temp=pd.read_fwf(loc, header=None, skiprows=9)
        avg_temp.columns = ['time', 'T_G','U_G','V_G','W_G','U_S1','DPU'  ]
        avg_UG[sim]=avg_temp['U_G']
        avg_TG[sim]=avg_temp['T_G']

        #cross stream
        #t Total Mass (Higest velocity) U W V
        loc=fid+cross
        cross_temp=pd.read_fwf(loc, header=None, skiprows=9)
        cross_temp.columns=['time', 'U','AVGUDOM', 'V', 'AVGVDOM', 'W', 'AVGWDOM']
        crossU[sim]= cross_temp['U']
        crossW[sim]= cross_temp['W']
        crossV[sim]= cross_temp['V']

        frac_crossU[sim]= cross_temp['U']
        frac_crossW[sim]= cross_temp['W']
        frac_crossV[sim]= cross_temp['V']

        #peak dpu 
        loc=fid+dpu
        dpu_temp=pd.read_fwf(loc, header=None, skiprows=9)
        dpu_temp.columns=['time', 'peak', 'peakin', 'peakout']
        peak_dpuin[sim]=dpu_temp['peakin']
        peak_dpuout[sim]=dpu_temp['peakout']



    return ent, froude, avg_UG, avg_TG, buoyantelutriated, inchannelmass, avulseddense, front, peak_dpuin, peak_dpuout, crossU, crossW, crossV
def entrain(data):
    print('hello entrainment')
    vol=[]
    deltaV=pd.DataFrame(columns=labels)
    for j in range(0,len(labels)):
        sim=labels[j]
        v=[]
        for i in range(2,8):
            dv=data.iloc[i,j]-data.iloc[i-1, j]
            v.append(dv)
        deltaV[sim]=v

    return deltaV

def plottogether(fid, df, ylab, xlab):
    print("plotting")
    print(fid)
    df.fillna(0)
    time=['0','5','10','15','20','25','30','35', '40']
    fig1, ax1 = plt.subplots()
    ax1.set_xticklabels(time)
    sns.lineplot(data=df, palette=palette, dashes=False)
    ax1.set_xlabel(xlab)
    ax1.set_ylabel(ylab)
    ax1.set_xlim(left=0)
    savefigure(fid)

def plotcol(df, xlab, ylab):
    df1=df.fillna(14)
    fig1, ax1 = plt.subplots()
    sns.lineplot(data=df1, palette=palette, dashes=False)
    ax1.set_xlabel(xlab)
    ax1.set_ylabel(ylab)
    ax1.invert_yaxis()

    plt.tight_layout()

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

def horizplot(df, loc, labels):
    maxy=(len(df))
    top=3*maxy
    height = np.arange(0,top,3)

    df1=df.fillna(df.min())
    for i in df.columns:
        j=labels.index(i)
        loc.plot(df1[i], height, label=i, color=palette[j] )

def setgrl(fig, axes, h,l):

    #fontsll
    font_path="/usr/share/fonts/truetype/msttcorefonts"
    myfont= "arial.tff"
    plt.rcParams['font.family']='Arial'

    fig.set_figheight(h)
    fig.set_figwidth(l)

def savefigure(name):
    path= "/home/akh/myprojects/channelized-pdcs/graphs/figures"
    fid=name + '.eps'
    plt.savefig(fid, format='eps', dpi=600)

def plotallcol(fid, df1, df2, df3, df4, df5):
    fig, axes= plt.subplots(1,4, sharey=True, sharex=False)
    setgrl(fig, axes, 4, 8)
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
    temp=df5
    #horizplot(temp, loc, labels)
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

def plotby(fid, df1, df2, datalabel1, datalabel2):
    palette= setcolorandstyle(labels)
    fig3, ax3 = plt.subplots()
    for sim in labels:
        i=labels.index(sim)
        c=palette[i]
        df3=pd.DataFrame()
        df3['x']=df2[sim]
        df3[sim]=df1[sim]
        sns.lineplot(x=df3.x, y=df3.iloc[:,1], color=c, label=sim, legend='brief')
    ax3.set_ylabel(datalabel1)
    ax3.set_xlabel(datalabel2)
    savefigure(fid)

def normalizebywave(data):
    for sim in labels:
        if "A" in sim :
            wave=300
        elif "C" in sim :
            wave= 900
        elif "S" in sim :
            wave=1200
        elif "B" in sim or "b" in sim:
            wave=600

        data[sim]= data[sim]/wave

    return front

def normalizebydepth(depth):
    for sim in labels:
        if "V" in sim :
            d=27
        elif "W" in sim :
            d=39
        elif "N" in sim :
            d=15

        depth[sim]= depth[sim]/d

    return depth

def normalizebywidth(data):
    for sim in labels:
        if "V" in sim :
            CA=200
        elif "W" in sim :
            CA=300
        elif "N" in sim :
            CA=100

        data[sim]= data[sim]/CA

    return data

def channelfrontplot(ax, data, xlabel, wavelabel, wave):
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
    palette=sns.color_palette("coolwarm", len(labels))
    ax2=ax.twinx()

    ax.get_yaxis().set_ticks([])

    for sim in ourlabels:
        i=labels.index(sim)
        print(sim)
        print(front[sim])
        print(data[sim])
        ax2.plot(front[sim], data[sim], label=sim, color=palette[i])

    ax2.set_xlabel(xlabel)
    ax2.set_ylim([y1-y2, y2+y2*.10])
    #plt.show()

def twotime(fid, df1, df2, datalabel1, datalabel2):
    palette= setcolorandstyle(labels)
    fig3, ax1 = plt.subplots()
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


def channelfrontsubplot(fid, data, ylab):
    fig, axes = plt.subplots(4, 1, sharex=True)
    setgrl(fig, axes, 6, 3)
    inchannelmass.iloc[0] = 1
    axes[3].set_xlabel("Down Slope distance (m)")
    channelfrontplot(axes[0], data, ylab, 'A', 300.)
    channelfrontplot(axes[1], data, ylab, 'B', 600.)
    channelfrontplot(axes[2], data, ylab, 'C', 900.)
    channelfrontplot(axes[3], data, ylab, 'E', 1200.)
    labelsubplots(axes, "uleft")
    savefigure(fid)

ent, froude, avg_UG, avg_TG, buoyantelutriated, inchannelmass, avulseddense, front, peak_dpuin, peak_dpuout, crossU, crossW, crossV = openlabel(labels)

peak_dpuin= np.log10(peak_dpuin + 0.000001)
peak_dpuout= np.log10(peak_dpuout + 0.000001)
# print(front)

channelfrontsubplot('avulsedmassbywavelength', avulseddense, 'Avulsed Mass Fraction')
channelfrontsubplot('elumassbywavelength',buoyantelutriated, 'Elutriated Mass Fraction')
channelfrontsubplot('peakdpubywavelength',peak_dpuin, 'Peak Dynamic Pressure in Channel ( Log (Pa))')
channelfrontsubplot('peakdpuoutbywavelength',peak_dpuout, 'Peak Dynamic Pressure outside Channel ( Log (Pa))')
channelfrontsubplot('crossstreambywavelength',crossV, 'Mass Fraction moving Cross Stream')
plt.close("all")
# nfront = normalizebywave(front)
deltaV = entrain(ent)
print(buoyantelutriated)
print( avulseddense)
plottogether("entrainmentall", deltaV, "Entrainment (m^3)", "Time")
plottogether("froude", froude, "Froude Number", "Time")
plottogether('avgUG', avg_UG, "Average Velocity (U/UO)", "Time")
plottogether('Elutriatedmass', buoyantelutriated, 'Elutriated Mass Fraction', "Time")
plottogether('inchannel', inchannelmass, 'Mass in Channel (%)', 'Time')
plottogether('avulsed', avulseddense, 'Mass Avulsed (%)', 'Time')
plottogether("front", front, "Front Location (m)", 'Time')
plottogether("peakdpuout", peak_dpuout, 'Peak Dynamic Pressure Outside Channel (Pa)', 'Time')
plottogether("peakdpuin", peak_dpuin, 'Peak Dynamic Pressure Inside Channel (Pa)', 'Time')

plt.close("all")
plottogether("cross_streamV", crossV, 'Mass Fraction with Dominant Cross Stream Velocity', 'Time')

plotby("massinchannel_byUG", inchannelmass, avg_UG, "% Mass in Channel", "Velocity (m/s)")
#plotby("DPU by UG", peak_dpuin, avg_UG, "Dynamic Pressure (Log Pa)", "Velocity (m/s)")

#plotby("ent_elu", buoyantelutriated, deltaV, "Elutriated Mass Fraction (%)", "Entrainment (m^3)")
#plotby("elu_avul", buoyantelutriated, avulseddense, "Elutriated Mass Fraction (%)", "Avulsed Mass Fraction")
#plotby("avul", avulseddense, avg_UG, "Avulsed Mass Fraction (%)", "Velocity (m/s)")
#twotime("entveluovertime", ent, gtscaleheight, "Entrainment (m^3)", "Elutriated Mass (%)")

fid = 'col_in'
plotallcol(fid, slicein_EPP, slicein_UG, slicein_DPU, slicein_Ri, slicein_TG)
fid = 'col_out'
plotallcol(fid, sliceout_EPP, sliceout_UG, sliceout_DPU, sliceout_Ri, sliceout_TG)
plt.close("all")
def labelparam(label):
    if "A" in label:
        wave = 300
    elif "B" in label:
        wave = 600
    elif "C" in label:
        wave = 900
    elif "D" in label:
        wave = 1200
    elif "E" in label:
        wave = 2400
    else:
        wave = 0 

    if "N" in label: 
        width = 100
        depth = 15 
    elif "W" in label: 
        width=300
        depth = 39
    elif "V" in label: 
        width = 200 
        depth= 27
    else :
        width=0 
        depth =0

    if "4" in labels:
        inlet=0.4
    elif "7" in labels:
        inlet=0.7
    elif "1" in labels:
        inlet=0.1
    else:
        inlet=1
    rho= 1950*(0.4)
    v = 10 
    vflux= depth*inlet*width*rho*v

    return wave, width, depth, inlet, vflux


def regime(data, ylab):
    fig,axes=plt.subplots(3)
    setgrl(fig,axes, 6, 4)
    palette=setcolorandstyle(labels)

    for sim in labels:
        i=labels.index(sim)
        c=palette[i]      
        wave, width, depth, inlet, vflux = labelparam(sim)
        end = data.loc[data.index[-1], sim]
        axes[0].scatter(wave, end, color=c)
        axes[1].scatter(width, end, color=c)
        axes[2].scatter(vflux, end, color=c)

    for i in range(len(axes)):
        axes[i].autoscale()
        axes[i].set_ylabel(ylab)

    axes[0].set_xlabel("Wavelength")
    axes[1].set_xlabel("Width")
    axes[2].set_xlabel("Volume Flux")
    labelsubplots(axes, 'uleft')
    plt.show()

# now plot based on label 

#regime(1-inchannelmass, "Avulsed Mass %")

def regime2(data, ylab):
    fig,axes=plt.subplots()
    setgrl(fig,axes, 4,4)
    palette=setcolorandstyle(labels)
    lamb=[]
    vei=[]
    end =[] 

    for sim in labels:
        wave, width, depth, inlet, vflux = labelparam(sim)
        end.append(data.loc[data.index[-1], sim])
        lamb.append(wave)
        vei.append(vflux)

    vmin=min(vei)
    vmax=max(vei)
    cs=axes.scatter(lamb, end, s=40, c=vei, cmap=cm.jet, vmin=vmin, vmax=vmax)
       # axes[1].scatter(width, end, color=c)
        #axes[2].scatter(vflux, end, color=c)

    plt.colorbar(cs)
    axes.autoscale()
    axes.set_ylabel(ylab)

    axes.set_xlabel("Wavelength")
    #axes[1].set_xlabel("Width")
    #axes[2].set_xlabel("Volume Flux")
    #labelsubplots(axes, 'uleft')
    savefigure("regime2")

#regime2(avulseddense, "Avulsed Mass %")