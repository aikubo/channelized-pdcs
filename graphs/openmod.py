import pandas as pd

def openmine(labels, path2file, fid, cols, out, colspec='infer', width='infer'):
    temp_all=pd.DataFrame()
    
    for sim in labels: 
        pathid=path2file+sim
        loc= pathid+fid
        print(loc)
        temp_1=pd.read_fwf(loc, header=None, skiprows=9, colspecs=colspec, width=width)
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

def openspillavg(labels, path):
    fid='_overspill_avg.txt'
    cols=['time', 'T_G','U_G','V_G','W_G','DPU', 'dT_G','dU_G','dV_G','dW_G','dDPU' ]
    colspec= [[1,4], [10,26], [33, 48], [57,70], [79,92], [101,114], [119,135],
              [140, 155], [160, 175], [180,195], [200,215]]
    spillTG=openmine(labels, path, fid, cols, 'T_G', colspec)-273
    spillUG=openmine(labels, path, fid, cols, 'U_G', colspec)
    spilldpu=openmine(labels, path, fid, cols, 'DPU', colspec)
    spillWG=openmine(labels, path, fid, cols, 'W_G', colspec)
    dspillTG=openmine(labels, path, fid, cols, 'dT_G', colspec)
    dspillWG=openmine(labels, path, fid, cols, 'dW_G', colspec)
    dspillUG=openmine(labels, path, fid, cols, 'dU_G', colspec)
    dspilldpu=openmine(labels, path, fid, cols, 'dDPU', colspec)

    return spillTG, spillUG, spilldpu, spillWG, dspillTG, dspillWG, dspillUG, dspilldpu
      

def openaverage(labels, path):
    fid='_average_all.txt'
    cols=['time',  'EP_P', 'rhoC','T_G','U_G','V_G','W_G','U_S1','DPU' ]
    colspec= [[1,4], [10,26], [33, 48], [57,70], [79,92], [101,114], [119,135]]
    avgTG=openmine(labels, path, fid, cols, 'T_G', colspec)-273
    avgUG=openmine(labels, path, fid, cols, 'U_G', colspec)
    avgdpu=openmine(labels, path, fid, cols, 'DPU', colspec)
    avgWG=openmine(labels, path, fid, cols, 'W_G', colspec)
    avgEPP=openmine(labels, path, fid, cols, 'EP_P')
    avgrho=openmine(labels, path, fid, cols, 'rhoC')

    return avgTG, avgUG, avgdpu, avgWG, avgEPP, avgrho

def opendenseaverage(labels, path):
    fid='_average_dense.txt'
    cols=['time', 'EP_P', 'rhoC', 'T_G','U_G','V_G','W_G','U_S1','DPU' ]
  
    avgTG=openmine(labels, path, fid, cols, 'T_G') -273
    avgUG=openmine(labels, path, fid, cols, 'U_G')
    avgEPP=openmine(labels, path, fid, cols, 'EP_P')
    avgrho=openmine(labels, path, fid, cols, 'rhoC')
    avgdpu=openmine(labels, path, fid, cols, 'DPU')
    avgWG=openmine(labels, path, fid, cols, 'W_G')

    return avgTG, avgUG, avgdpu, avgWG, avgEPP, avgrho


def openmassdist(labels, path):
    fid='_massinchannel.txt'
    # t Total Mass (m^3) TotalOutOfChannel Dense InChannel GT1ScaleH BuoyantOut DenseOut
    cols=['time', 'Total Mass', "Mass outside", "Dense", "InChannel", "ScaleH", "Buoyant", "Avulsed", "Areat", "Carea", "Area", "AreaOut"]
    colspec=[[1,6], [9,30], [37,55], [68,79], [93,105], [118, 130], [143,157], [168,180 ], [185,205], [212,230], [242,255], [267,279] ]
    massout=1-openmine(labels, path, fid, cols, "InChannel", colspec)
    avulsed=openmine(labels, path, fid, cols, "Avulsed",colspec)
    buoyant=openmine(labels, path, fid, cols, "Buoyant",colspec)
    area=openmine(labels, path, fid, cols, "Area",colspec)
    tot=openmine(labels, path, fid, cols, "Total Mass",colspec)
    areaout=openmine(labels, path, fid, cols, "AreaOut", colspec)

    return tot, avulsed, buoyant, massout, area, areaout

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
    avulseddense, buoyantelutriated, massout, area = openmassdist(labels, path)
    avgTG, avgUG, avgdpu = openaverage(labels, path)


    return avgTG, avgUG, avgdpu, peakin, peakout, xout, xin, zout, zin,  froude, front, bulk_ent, med_ent, dense_ent, avulseddense, buoyantelutriated, massout, area

def sumovertime(labels,path, fid, cols, out, colspec='infer'):
    result=pd.DataFrame()
    time=[1,2,3,4,5,6,7,8]

    for sim in labels: 
        

        pathid=path+sim
        loc= pathid+fid
        temp_1=pd.read_fwf(loc, header=None, skiprows=9,colspecs=colspec)
        temp_1.columns=cols

        for t in time:
            temp2=temp_1[temp_1['time']== t]
            if "XXX" in cols:
                temp2.sort_values(by=["XXX"])
            temp3 = temp2[out]
            if t==1:
                summass= temp3
            else:
                summass=summass+temp3.values

        result[sim]=summass

    return result 

def picktime(labels,path, fid, cols, out, twant, colspec='infer'):
    result=pd.DataFrame()
    for sim in labels: 

        pathid=path+sim
        loc= pathid+fid
        print(loc)
        temp_1=pd.read_fwf(loc, header=None, skiprows=9,colspecs=colspec)
        temp_1.columns=cols
        if "XXX" in cols:
            temp_1.sort_values(by=["XXX"])
        temp2=temp_1[temp_1['time']== twant]
        temp2.reset_index(drop=True, inplace=True)
        result[sim]=temp2[out]

    return result 