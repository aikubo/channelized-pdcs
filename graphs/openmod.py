import pandas as pd

def openmine(labels, path2file, fid, cols, out, colspec='infer'):
    temp_all=pd.DataFrame()
    
    for sim in labels: 
        pathid=path2file+sim
        loc= pathid+fid
        print(loc)
        temp_1=pd.read_fwf(loc, header=None, skiprows=9, colspecs=colspec)
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
    colspec= [[1,4], [12,26], [33, 48], [57,70], [79,92], [101,114], [119,135]]
    avgTG=openmine(labels, path, fid, cols, 'T_G', colspec)
    avgUG=openmine(labels, path, fid, cols, 'U_G', colspec)
    avgdpu=openmine(labels, path, fid, cols, 'DPU', colspec)

    return avgTG, avgUG, avgdpu

def opendenseaverage(labels, path):
    fid='_average_dense.txt'
    cols=['time', 'T_G','U_G','V_G','W_G','U_S1','DPU' ]
    colspec= [[1,4], [12,26], [33, 48], [57,70], [79,92], [101,114], [119,135]]
    avgTG=openmine(labels, path, fid, cols, 'T_G', colspec)
    avgUG=openmine(labels, path, fid, cols, 'U_G', colspec)
    avgdpu=openmine(labels, path, fid, cols, 'DPU', colspec)

    return avgTG, avgUG, avgdpu


def openmassdist(labels, path):
    fid='_massinchannel.txt'
    # t Total Mass (m^3) TotalOutOfChannel Dense InChannel GT1ScaleH BuoyantOut DenseOut
    cols=['time', 'Total Mass', "Mass outside", "Dense", "InChannel", "ScaleH", "Buoyant", "Avulsed", "Area"]
    colspec=[[1,6], [17,30], [37,55], [68,79], [93,105], [118, 130], [143,157], [168,180 ], [187,205] ]
    massout=openmine(labels, path, fid, cols, "Mass outside", colspec)
    avulsed=openmine(labels, path, fid, cols, "Avulsed",colspec)
    buoyant=openmine(labels, path, fid, cols, "Buoyant",colspec)
    area=openmine(labels, path, fid, cols, "Area",colspec)
    return avulsed, buoyant, massout, area

def openent(labels,path):
    fid='_entrainment.txt'
    entcol= ['time', 'bulk', 'medium', 'dense']
    colspec= [[2,5], [17, 26], [31, 48], [54,69]]
    bulk_ent = openmine(labels, path, fid, entcol, 'bulk',colspec)
    med_ent = openmine(labels, path, fid, entcol, 'medium',colspec)
    dense_ent = openmine(labels, path, fid, entcol, 'dense',colspec)

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