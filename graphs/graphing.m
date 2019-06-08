clear all
close all

% graphign script 3/8/2019
timesteps = 8;

ZMAX=150 ;
RMAX=400;
YMAX=200;
Volume_Unit = 2.*2.*2.; % !From your 3D grid dx, dy, dz
gravity = 9.81; %!m^2/s
P_const = 1.0e5; %!Pa
R_vapor = 461.5; %!J/kg K
R_dryair = 287.058; %!J kg/K
T_amb    = 273.0; %!K
rho_dry  = P_const/(R_dryair*T_amb);  %!kg/m**3
char_length = 20.0;
mu_g        = 2.0e-5 ;% !Pa s
rho_p = 1950;
D = 5e-5;
ROP_0 = 0.10; 
u0= 10;
gstar = gravity ;%!ROP_0*gravity*(rho_p/rho_dry)
Hstar = (u0*u0)/gstar ;
stokesv =(2/9)*(rho_p-rho_dry)*gravity*D*D/mu_g;
stokest = Hstar/stokesv;



%% DPU distro
dpu200=importdata('dpuinchannel200.txt');
dpu600=importdata('dpuinchannel600.txt');
dpu400=importdata('dpuinchannel400.txt');
figure;
hold on;
title('Center of Channel')

right400 = min(dpu400(dpu400(:,3)==1, 2))+2;
left400= max(dpu400(dpu400(:,3)==1, 2))-2;
center400= floor(mean((dpu400(dpu400(:,3)==1, 2))));

right200 = min(dpu200(dpu200(:,3)==1, 2))+2;
left200= max(dpu200(dpu200(:,3)==1, 2))-2;
center200= floor(mean((dpu200(dpu200(:,3)==1, 2))));

right600 = min(dpu600(dpu600(:,3)==1, 2))+2;
left600= max(dpu600(dpu600(:,3)==1, 2))-2;
center600= 2*floor(0.5*mean((dpu600(dpu600(:,3)==1, 2))));

timeseries(dpu400, center400)
timeseries(dpu600, center600)
timeseries(dpu200, center200)
print('center', '-dtiff')

hold off;

figure;
hold on;

timeseries(dpu400, right400)
timeseries(dpu600, right600)
timeseries(dpu200, right200)
title('Left Edge of Channel')
print('leftedge', '-dtiff')

hold off;

figure;
hold on;

timeseries(dpu400, left400)
timeseries(dpu600, left600)
timeseries(dpu200, left200)
title('Right Edge of Channel')

print('rightedge', '-dtiff')
hold off;




function timeseries(data,center)
time=[0:5:40];
dput=data(data(:,2)==center, 4);
eppt= log10( (1-data(data(:,2)==center, 3)) + 1.0000e-14);


xlabel('Time (s)')
set(gca, 'FontName', 'Arial', 'FontSize', 12)
yyaxis left
ylabel('Dynamic Pressure (Pa)')
ylim([0, 9000])
plot(time, dput(:), 'b','LineWidth', 2)


yyaxis right
ylabel('Volume Fraction Particles')
ylim([ -14, 0])
plot(time, eppt(:), 'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', 2)

end 


function dpudistro(data, name)
[step1, step2, step3, step4, step5, step6, step7, step8, step9] =splitit(data);

figure;
hold on;
%titled= sprintf('Dynamic Pressure Distribusion in Channel %d m',name );
%t%itle(titled)
ylabel('Dynamic Pressure (Pascals)')
xlabel('Z direction (m)')
xlim([0 300])
plot(step1(:,2), step1(:,4))
plot(step2(:,2), step2(:,4))
plot(step3(:,2), step3(:,4))
plot(step4(:,2), step4(:,4))
plot(step5(:,2), step5(:,4))
plot(step6(:,2), step6(:,4))
plot(step7(:,2), step7(:,4))
plot(step8(:,2), step8(:,4))
plot(step9(:,2), step9(:,4))

all=cat(3, step1(:,4), step2(:,4),step3(:,4), step4(:,4), step5(:,4), step6(:,4),step7(:,4), step8(:,4), step9(:,4));
avg= mean(all,3);
fid = sprintf('dpudistro%d.tiff',name );
plot(step1(:,2), avg, 'k-.', 'LineWidth',2)
print(fid, '-dtiff')

hold off
end 


%% mass in channel 

%mass = importdata('massinchannel.txt');
%figure;
%plot(time, mass(:,1))
%print('massinchannel','-djpeg')


%% entrainment
%     % load total  <.99999
%     sum1 = importdata('EP_G_sum1');
%     % load dilute  <.999
%     sum2 = importdata('EP_G_sum2');
%     % load dense <.99
%     sum3 = importdata('EP_G_sum3');
% 
%     %% calculate entrainment 
%     %entrainment = delta volume
%     entrain1 = zeros(timesteps,1);
%     entrain2 = zeros(timesteps,1);
%     entrain3 = zeros(timesteps,1);
% 
%     for t = 2:timesteps
%         entrain1(t) = sum1(t,2) - sum1(t-1,2);
%         entrain2(t) = sum2(t,2) - sum2(t-1,2);
%         entrain3(t) = sum3(t,2) - sum3(t-1,2);
%     end
% %% graph 
%     figure;
%     hold on
%     set(gca, 'XTick', 0:5:10, 'XTickLabel', {'0' '25' '50'}, 'FontName', 'Arial', 'FontSize', 12)
%     ylabel('Entrainment per timestep (10^{4} m^{3})')
%     xlabel('Time (seconds)')
%     ylim([0,5])
%     xlim([0,timesteps])
%     area(time,entrain1/10^4, 'FaceColor', [0 0.75 0.75])
%     area(time,entrain2/10^4, 'FaceColor', [0 0.5 0.5])
%     area(time,entrain3/10^4, 'FaceColor', [0 0.25 0.25])
%     legend('Dilute (<.001 Particle fraction)', 'Mid particle fraction', 'Dense (<0.1 Particle Fraction)' , 'Location', 'NorthWest')
% print('entvt', '-djpeg')
% hold off


%%
% all= importdata('average_all.txt');
% 
% medium= importdata('average_medium.txt');
% 
% dense=importdata('average_dense.txt');
%  
%% temp
% figure;
% hold on
%     set(gca, 'FontName', 'Arial', 'FontSize', 12)
%     ylabel('Average temperature per timestep (K)')
%     xlabel('Time (seconds)')
%     ylim([300, 850])
% 
% 
% plot(time, all(:,1), 'Color', [0 0.75 0.75], 'LineWidth', 2) 
% plot(time, medium(:,1), 'Color', [0 0.5 0.5], 'LineWidth', 2)
% plot(time, dense(:,1), 'Color', [0 0.25 0.25], 'LineWidth', 2)
% legend('Dilute (<.001 Particle fraction)', 'Mid particle fraction', 'Dense (<0.1 Particle Fraction)' , 'Location', 'northoutside')
% print('tvt', '-djpeg')
% hold off

%% velocity

%% magnitude
% figure;
% hold on 
%     set(gca, 'FontName', 'Arial', 'FontSize', 12)
%     ylabel('Velocity Magnitude in Z direction (m/s)')
%     xlabel('Time (seconds)')
    %ylim([0,10])
%magnitude = sqrt(all(:,2).^2 + all(:,3).^2 + all(:,3).^2);

%plot(time, magnitude, 'Color', [0 0.75 0.75], 'LineWidth', 3) 
    
%plot(time, all(:,2), 'Color', [0 0.75 0.75], 'LineWidth', 3) 
%plot(time, dense(:,2), 'Color', [0 0.25 0.25], 'LineWidth', 3)
% print('magvt', '-djpeg')
% hold off

%% U_S1
% figure;
% hold on
% plot(time, all(2:9,5), 'o-') 
% plot(time, medium(2:9,5), 'o-')
% plot(time, dense(2:9,5), 'o-')
% print('uvt', '-djpeg')
% hold off
%% W_G
% figure;
%hold on
% plot(time, all(:,3), 'Color', [0 0.75 0.75], 'LineWidth', 2) 
% plot(time, medium(:,3), 'Color', [0 0.5 0.5], 'LineWidth', 2)
% plot(time, dense(:,3), 'Color', [0 0.25 0.25], 'LineWidth', 2)
% print('wvt', '-djpeg')
% hold off
%% V_G
% figure;
% hold on
%     set(gca, 'FontName', 'Arial', 'FontSize', 12)
%     ylabel('Average velocity in  Z (m/s)')
%     xlabel('Time (seconds)')
% 
%plot(time, all(:,4), 'Color', [0 0.75 0.75], 'LineWidth', 2) 
%plot(time, medium(:,4), 'Color', [0 0.5 0.5], 'LineWidth', 2)
%plot(time, dense(:,4), 'Color', [0 0.25 0.25], 'LineWidth', 2)
%print('vvt', '-djpeg')
% hold off
%% slice 
% 
% maxima = importdata('slice_maxima.txt');
% minima = importdata('slice_minima.txt');
% % t, Y, EP_P, U_G, T_G, dpu
% timax = unique(maxima(:,1));
% timin = unique(minima(:,1));
% 
% %[step1, step2, step3, step4, step5, step6, step7, step8, step9] =splitit(minima);
% 
% 
% %slice(step4)
% %slice(step6)
function [step1, step2, step3, step4, step5, step6, step7, step8, step9] = splitit(M)

time=[1:10];

step1=M(M(:,1)==1,:);
step2=M(M(:,1)==2,:);
step3=M(M(:,1)==3,:);
step4=M(M(:,1)==4,:);
step5=M(M(:,1)==5,:);
step6=M(M(:,1)==6,:);
step7=M(M(:,1)==7,:);
step8=M(M(:,1)==8,:);
step9=M(M(:,1)==9,:);
step10=M(M(:,1)==10,:);


%step1=M(M(:,1)=1,:);
%step1=M(M(:,1)=1,:);
% [~,~,X] = unique(M(:,1));
% C = accumarray(X,1:size(M,1),[],@(r){M(r,:)});
% X = unique(M(:,1));
% steps = length(X);
% for t=1,steps
%     r=X(t);
%     new=M(M(:,1)==r,:)
% 
% end
% C=new;
end

% 
% figure; 
% title('Minima')
% ylabel('Height above channel')
% set(gca, 'FontName', 'Arial', 'FontSize', 12)
% subplot(1,2,1);
% plot(minima(:,2), minima(:,1)-minima(1,1), 'Color', [ 0.9100 0.4100 0.1700])
% title('Log Volume Fraction')
% xlabel('EP _ P')
% xlim([1.2 6.7])
% 
% subplot(1,2,2);
% plot(minima(:,3)/u0, minima(:,1)-minima(1,1))
% title('Vertical Velocity Profile')
% xlabel('U/U_o')
% xlim([0 3.3])
% %print('slice_minima', '-djpeg')
% 
% 
% 
% function slice(column) 
% time= column(1,1);
% u0=10;
% figure('position', [0, 0, 350, 500]);
% set(gca, 'FontName', 'Arial', 'FontSize', 12)
% ylabel('Height above channel')
% ylim([
% title('Simulation Time ')
% plot(column(:,3), column(:,2)-column(1,2), 'Color', [ 0.9100 0.4100 0.1700])
% xlabel('Log Volume Fraction')
% xlim([1.2 6.7])   
% fid = sprintf('col_EPG%d.tiff',time );
% print(fid,'-dtiff')	
% close; 
% 
% figure('position', [0, 0, 350, 500]);
% set(gca, 'FontName', 'Arial', 'FontSize', 12)
% ylabel('Height above channel')
% plot(column(:,4)/u0, column(:,2)-column(1,2))
% title('Simulation Time ')
% xlabel('Scaled Velocity U/U_o')
% xlim([-2 3.3])
% fid = sprintf('col_UG%d.tiff',time );
% print(fid,'-dtiff')	
% close; 
% 
% figure('position', [0, 0, 350, 500]);
% set(gca, 'FontName', 'Arial', 'FontSize', 12)
% ylabel('Height above channel')
% plot(column(:,5), column(:,2)-column(1,2))
% title('Simulation Time ')
% xlabel('Temperature (K)')
% xlim([273, 800])
% fid = sprintf('col_TS%d.tiff',time );
% print(fid,'-dtiff')	
% close; 
% 
% figure('position', [0, 0, 350, 500]);
% set(gca, 'FontName', 'Arial', 'FontSize', 12)
% ylabel('Height above channel')
% plot(column(:,6), column(:,2)-column(1,2))
% title('Simulation Time ')
% xlabel('Dynamic Pressure (Pascals)')
% fid = sprintf('col_DPU%d.tiff',time );
% print(fid,'-dtiff')	
% close;
% 
% 
% end 





