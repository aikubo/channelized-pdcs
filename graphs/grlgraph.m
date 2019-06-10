clear alvl
close all

% graphign script 3/8/2019
timesteps = 8;
fid='slice_middle04.txt';
delimiterIn=' ';
path= '/home/akubo/myprojects/straightchannels/20_18_50/';
path2file=strcat(path,fid);
M20D18=importdata(path2file);

path= '/home/akubo/myprojects/straightchannels/20_0D_proc/';
path2file=strcat(path,fid);
M20D0=importdata(path2file);

path= '/home/akubo/myprojects/sinchannels/sin_20_l400_w50/';
path2file=strcat(path,fid);
l400=importdata(path2file);

path= '/home/akubo/myprojects/sinchannels/sin_20_18_l800_w50/';
path2file=strcat(path,fid);
l800=importdata(path2file);


% this function creates vertical profiles of volume fraction
% velocity & Richardson number

makegrl(M20D0, M20D18, l400, l800);


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
