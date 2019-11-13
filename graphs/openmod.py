import pandas as pd

def openmine(labels, path2file, fid, cols, out):
    temp_all=pd.DataFrame()

    for sim in labels: 
        pathid=path2file+sim
        loc= pathid+fid
        temp_1=pd.read_fwf(loc, header=None, skiprows=9)
        temp_1.columns=cols
        temp_all[sim]=temp_1[out]
    return temp_all

frcols= ['time', 'AvgU','AvgEP','AvgT','Froude','Front',' Width','Height' ]

masscol=['time', 'Total Mass (m^3)', "Mass outside", "Dilute", "Medium", "Dense", "InChannel", "InWidth", "LtScale", "ScaleH", "Buoyant", "AvulseD"]
avgcol=['time', 'T_G','U_G','V_G','W_G','U_S1','DPU'  ]
crossstream=['time', 'U','AVGUDOM', 'V', 'AVGVDOM', 'W', 'AVGWDOM']
dpupeak=['time', 'peak','XXX', 'ZZZ', 'peakin', 'XXX', 'ZZZ','peakout']
pex=['Potential']
kex=['Kinetic']
perpx=['Perpx']

def openaverage(labels, path):
    fid='_average_all.txt'
    cols=['time', 'T_G','U_G','V_G','W_G','U_S1','DPU' ]
    avgTG=openmine(labels, path, fid, cols, 'T_G')
    avgUG=openmine(labels, path, fid, cols, 'U_G')
    avgdpu=openmine(labels, path, fid, cols, 'DPU')

    return avgTG, avgUG, avgdpu

def openmassdist(labels, path):
    fid='_massinchannel.txt'
    cols=['time', 'Total Mass (m^3)', "Mass outside", "Dilute", "Medium", "Dense", "InChannel", "InWidth", "LtScale", "ScaleH", "Buoyant", "AvulseD"]
    massout=openmine(labels, path, fid, cols, "Mass outside")
    avulsed=openmine(labels, path, fid, cols, "AvulseD")
    buoyant=openmine(labels, path, fid, cols, "Buoyant")
    return avulsed, buoyant, massout

def openent(labels,path):
    fid='_entrainment.txt'
    entcol= ['time', 'bulk', 'medium', 'dense']
    bulk_ent = openmine(labels, path, fid, entcol, 'bulk')
    med_ent = openmine(labels, path, fid, entcol, 'medium')
    dense_ent = openmine(labels, path, fid, entcol, 'dense')

    return bulk_ent, med_ent, dense_ent

def openfroude(labels, path):
    froudefid='_froude.txt'
    frcols= ['time', 'AvgU','AvgEP','AvgT','Froude','Front',' Width','Height' ]
    froude=openmine(labels, path, froudefid, frcols, 'Froude')
    front=openmine(labels, path, froudefid, frcols, 'Front')
    return froude, front

def openpeakdpu(labels,path):
    fid='_dpu_peak.txt'
    cols=['time', 'peak','XXXin', 'ZZZin', 'peakin', 'XXXout', 'ZZZout','peakout']
    peakin=openmine(labels, path, fid, cols, 'peakin')
    peakout=openmine(labels, path, fid, cols, 'peakout')
    xout=openmine(labels, path, fid, cols, 'XXXout')
    zout=openmine(labels, path, fid, cols, 'ZZZout')
    xin=openmine(labels, path, fid, cols, 'XXXin')
    zin=openmine(labels, path, fid, cols, 'ZZZin')
    # peakin.drop(peakin.index[8])
    # peakout.drop(peakout.index[8])
    # xin.drop(xin.index[8])
    # zin.drop(zin.index[8])
    # zout.drop(zout.index[8])
    # xout.drop(xout.index[8])
    return peakin, peakout, xout, xin, zout, zin

def openall(labels,path):
    peakin, peakout, xout, xin, zout, zin = openpeakdpu(labels,path)
    froude, front = openfroude(labels, path)
    bulk_ent, med_ent, dense_ent = openent(labels,path)
    avulseddense, buoyantelutriated, massout = openmassdist(labels, path)
    avgTG, avgUG, avgdpu = openaverage(labels, path)


    return avgTG, avgUG, avgdpu, peakin, peakout, xout, xin, zout, zin,  froude, front, bulk_ent, med_ent, dense_ent, avulseddense, buoyantelutriated, massout
