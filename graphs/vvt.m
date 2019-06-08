% graphs horizontal velocity versus time 

cd ~/data
timesteps = 10 ; 

for theta = [10, 20]
  for D = [0, 18] 
    did = '%d_%dD_proc';
    currdir = sprintf(did, theta, D) ;
    cd(currdir)
    
    fid = sprintf('ugvt_%d%d.tiff', theta, D);

    X = 1:timesteps;
			
    % load total  <.99999
    sum1 = importdata('avgU1');
    % load dilute  <.999
    sum2 = importdata('avgU2');
    % load dense <.99
    sum3 = importdata('avgU3');

    %% calculate
    v1 = sum1(:,2);
    v2 = sum2(:,2);
    v3 = sum3(:,2);

%% graph 
    figure;
    hold on
    set(gca, 'XTick', 0:5:10, 'XTickLabel', {'0' '25' '50'}, 'FontName', 'Arial', 'FontSize', 12)
    ylabel('Average horizontal velocity per timestep (m/s)')
    xlabel('Time (seconds)')
    ylim([5 30])
    xlim([1,timesteps])
 
plot(X, v1, 'Color', [0 0.25 0.25], 'LineWidth', 2) 
plot(X, v2, 'Color', [0 0.5 0.5], 'LineWidth', 2) 
plot(X, v3, 'Color', [0 0.75 0.75], 'LineWidth', 2) 

%    area(X,temp3, 'FaceColor', [0 0.75 0.75])
%    area(X,temp2, 'FaceColor', [0 0.5 0.5])
%    area(X,temp1, 'FaceColor', [0 0.25 0.25])

    legend('Dilute (<.001 Particle fraction)', 'Mid particle fraction', 'Dense (<0.1 Particle Fraction)' , 'Location', 'NorthWest')

    cd ~/graphics/vvt
%% save file
    print(fid,'-dtiff')	
    cd ~/data
   
    end 
end
close all
cd ~/graphics 
