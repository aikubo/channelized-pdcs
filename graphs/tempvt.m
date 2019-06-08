% graphs temperature versus time 
clear all
cd ~/data
timesteps = 10 ; 

for theta = 20
  for D = 0 
    did = '%d_%dD_proc';
    currdir = sprintf(did, theta, D) ;
    cd(currdir)
    
    fid = sprintf('tempvt_%d%d.tiff', theta, D);

    %X = 1:timesteps;
			
    % load total  <.99999
    sum1 = importdata('avgT1');
    % load dilute  <.999
    sum2 = importdata('avgT2');
    % load dense <.99
    sum3 = importdata('avgT3');

    %% calculate
    temp1 = sum1(:,2);
    temp2 = sum2(:,2);
    temp3 = sum3(:,2);
      

    X = sum1(:,1);
%% graph 
    figure;
    hold on
    set(gca, 'XTick', 0:5:10, 'XTickLabel', {'0' '25' '50'}, 'FontName', 'Arial', 'FontSize', 12)
    ylabel('Average temperature per timestep (K)')
    xlabel('Time (seconds)')
    ylim([250 850])
    xlim([1 timesteps])
 
plot(X, temp1, 'Color', [0 0.25 0.25], 'LineWidth', 2) 
plot(X, temp2, 'Color', [0 0.5 0.5], 'LineWidth', 2) 
plot(X, temp3, 'Color', [0 0.75 0.75], 'LineWidth', 2) 

%    area(X,temp3, 'FaceColor', [0 0.75 0.75])
%    area(X,temp2, 'FaceColor', [0 0.5 0.5])
%    area(X,temp1, 'FaceColor', [0 0.25 0.25])
%    legend('Dilute (<.001 Particle fraction)', 'Mid particle fraction', 'Dense (<0.1 Particle Fraction)' , 'Location', 'NorthEast')

 %   legend('Dilute (<.001 Particle fraction)', 'Mid particle fraction', 'Dense (<0.1 Particle Fraction)' , 'Location', 'NorthEast')

    cd ~/graphics/tvt
%% save file
    print(fid,'-dtiff')
	close	
    cd ~/data
   
    end 
end

cd ~/graphics 
