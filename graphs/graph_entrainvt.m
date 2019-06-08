% graph_entrainvt 
% this is a matlab script that reads in then plots bulk entrainment versus time
% this reads in the EP_G_sum# .txt files 

% written by AK, 11/29

timesteps = 15 ; 	% number of timesteps 
X = 1:timesteps;
%% load EP_G_sum#
% sum is a two column by t matrix of volumes (m^3)

% load total  <.99999
sum1 = importdata('EP_G_sum1');

% load dilute  <.999
sum2 = importdata('EP_G_sum2');

% load dense <.99

sum3 = importdata('EP_G_sum3'); 


%% calculate entrainment 
%entrainment = delta volume
entrain1 = zeros(1,timesteps);
entrain2 = zeros(1,timesteps);
entrain3 = zeros(1,timesteps);


for t = 2:timesteps 
	entrain1(t) = sum1(t,2) - sum1(t-1, 2); 
	entrain2(t) = sum2(t,2) - sum2(t-1, 2);
	entrain3(t) = sum3(t,2) - sum3(t-1, 2);
end 


%% graph 

%figure(1) 
%hold on 
%set(gca,'XTickLabel',0:25:75, 'FontName', 'Arial', 'FontSize', 12)
%ylabel('Entrainment per timestep (10^{4} m^{3})')
%xlabel('Time (seconds)')

%plot(1:15, entrain1/10^4) 
%plot(1:timesteps, entrain2/10^4)
%plot(1:timesteps, entrain3/10^4)

figure;
hold on
set(gca,'XTickLabel',0:25:75, 'FontName', 'Arial', 'FontSize', 12)
ylabel('Entrainment per timestep (10^{4} m^{3})')
xlabel('Time (seconds)')
%legend('Dilute (<.001 Particle fraction)', 'Mid particle fraction', 'Dense (<0.1 Particle Fraction)' , 'Location', 'NorthWest')
area(X,entrain1/10^4, 'FaceColor', [0 0.25 0.25]) 
area(X,entrain2/10^4, 'FaceColor', [0 0.5 0.5]) 
area(X,entrain3/10^4, 'FaceColor', [0 0.75 0.75])

legend('Dilute (<.001 Particle fraction)', 'Mid particle fraction', 'Dense (<0.1 Particle Fraction)' , 'Location', 'NorthWest')

cd ~/graphics 

print('entvt_2018.tiff','-dtiff')


