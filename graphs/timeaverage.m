clear all
close all

% % graphign script 7/22/2019
%% takes time average of slice_middle file in the following directories
path= '/home/akubo/myprojects/straightchannels/20_18_50/';
M20D18=taverage(path);

path= '/home/akubo/myprojects/straightchannels/20_0D_proc/';
M20D0=taverage(path);

% 
%path= '/home/akubo/myprojects/sinchannels/INFLOW/';
%l400=taverage(path);
 
path= '/home/akubo/myprojects/sinchannels/sin_20_18_l800_w50/';
l800=taverage(path);

% 
path= '/home/akubo/myprojects/sinchannels/DENSE_l400/';
Dl400=taverage(path);

% this function creates vertical profiles of volume fraction
% velocity & Richardson number

makegrl(M20D0, M20D18, l800, Dl400);

%avg=taverage(path)

function avg = taverage(path)
    tstart=4;
    tstop=8;
    timesteps=tstop-tstart+1;
    fileid='slice_middle0';
    data=cell(1,timesteps);
    

    maxh= 100; 
    height=[1:1:maxh];

    tmp= NaN(maxh,5,timesteps);
    
    for t=[tstart:1:tstop]
        fid=sprintf('slice_middle0%d.txt', t);
        path2file=strcat(path,fid);
        data=importdata(path2file);
        [row,column]=size(data);
        tmp(1:row ,:,t-3)=data;
    end
    bottom=tmp(1,1,1);     
    avg=nanmean(tmp,3);
    
    avg(:,1)= bottom+2*height;
    avg(any(isnan(avg),2), :) = []
%    while size(avg,1) == maxh 
%    for i=[1:1:50];
%    	 if sum(avg(i,:)) == avg(i,1) 
%  		avg=avg(1:i-1,:);
% 		break
%     	end 
%     end 
%    end 
end

function makegrl(M20D0, M20D18,  l800, Dl400)
    grlfigure()
    hold on
    ep(M20D0)
    ep(M20D18)
    %ep(l400)
    ep(l800)
    ep(Dl400)
    legend('Unconfined', 'Straight Channel', '800m Wavelength', 'Dense 400m')
    hold off
    print('epg_vert', '-dpng')

    grlfigure()
    hold on
    vel(M20D0)
    vel(M20D18)
    %vel(l400)
    vel(l800)
    vel(Dl400)
    legend('Unconfined', 'Straight Channel', '800m Wavelength','Dense 400m')
    print('vel_vert', '-dpng')
    hold off

    grlfigure()
    hold on
    Ri(M20D0)
    Ri(M20D18)
    %Ri(l400)
    Ri(l800)
    Ri(Dl400)
    legend('Unconfined', 'Straight Channel', '800m Wavelength', 'Dense 400m')
    print('Ri_vert', '-dpng')
    hold off

    grlfigure()
    hold on
    temp(M20D0)
    temp(M20D18)
    %temp(l400)
    temp(l800)
    temp(Dl400)
    legend('Unconfined', 'Straight Channel', '800m Wavelength', 'Dense 400m')
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
