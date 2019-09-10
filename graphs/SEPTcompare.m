%% open file with directories 
labels=[ "AV4", "CV4", "BW4", "CW4", "SW4", "bw7", "AV7", "CV7", "SV4" ];
                                                                                                                                      
%%
[av4nose, av4ent, av4fr, av4mass] = openfiles(labels(1));


function [nose, ent, froude, massin] = openfiles(label)
path2file = '/gpfs/projects/dufeklab/akubo/channelized-pdcs/graphs/processed/';
nosefid='_nose.txt';
froudefid='_froude.txt';
slicefid='_slice_x200_z150.txt';
entrainmentfid='_entrainment.txt';
massfid='_massinchannel.txt';


%%
fid=strcat(path2file, label);

%% nose
locnose=strcat(fid, nosefid);
nose=importdata(locnose);

%% entrainment
locent=strcat(fid,entrainmentfid);
ent=importdata(locent);

%% slice
locslic=strcat(fid,slicefid);
slice=importdata(locslic);

%% froude
locfr=strcat(fid,froudefid);
froude=importdata(locfr);

%% mass in channel
locmass=strcat(fid, massfid);
massin=importdata(locmass);

%% mass in%% mass in channel
locmass=strcat(fid, massfid);
massin=importdata(locmass);

locavg=strcat(fid, avgfid);
avg=importdata(locavg);


end 

function makegrl(M20D0, M20D18, l400, l800)
    grlfigure()
    hold on
    ep(M20D0)
    ep(M20D18)
    ep(l400)
    ep(l800)
    legend('Unconfined', 'Straight Channel', '400m Wavelength', '800m Wavelength')
    hold off
    print('epg_vert', '-dpng')

    grlfigure()
    hold on
    vel(M20D0)
    vel(M20D18)
    vel(l400)
    vel(l800)
    legend('Unconfined', 'Straight Channel', '400m Wavelength', '800m Wavelength')
    print('vel_vert', '-dpng')
    hold off

    grlfigure()
    hold on
    Ri(M20D0)
    Ri(M20D18)
    Ri(l400)
    Ri(l800)
    legend('Unconfined', 'Straight Channel', '400m Wavelength', '800m Wavelength')
    print('Ri_vert', '-dpng')
    hold off

    grlfigure()
    hold on
    temp(M20D0)
    temp(M20D18)
    temp(l400)
    temp(l800)
    legend('Unconfined', 'Straight Channel', '400m Wavelength', '800m Wavelength')
    print('temp_vert', '-dpng')
    hold off

    end 

    function ep(data)
        xlabel('\epsilon_{p} ')
        ylabel('Height above Channel (m)')
        height = min(data(:,1));
        Z=data(:,1)-height;
        X = data(:,2);
        plot(X,Z);
        hold on
    end 

    function vel(data)
        U0= 10 ; % m/s
        ylabel('Height above Channel (m)')
        xlabel('U/U_{0}')
        height = min(data(:,1));
        Z=data(:,1)-height;
        Y=data(:,3)/U0;
        plot(Y,Z);
        hold on
end 

function Ri(data)

    ylabel('Height above Channel (m)')
    xlabel('Ri')
    height = min(data(:,1));
    Z=data(:,1)-height;
    W=data(:,4);
    W(W>5)=5;
    W(W<-5)=-5;
    plot(W,Z)  ;  
    hold on    
end 

function temp(data)
    T0= 800; % C
    ylabel('Height above Channel (m)')
    xlabel('Temperature (C)')
    height = min(data(:,1));
    Z=data(:,1)-height;
    W=data(:,5)/T0;
    plot(W,Z)  ;  
    hold on    
end 

function f = grlfigure()
width= 11.5;
height= 9.5;
f = figure;

set(f,'PaperUnits','centimeters')
set(f, 'PaperPositionMode', 'manual');
set(f,'PaperSize',[width,height])
set(f,'PaperPosition',[0,0,width,height])
set(gca, 'FontName', 'Arial', 'FontSize', 8)

end 
