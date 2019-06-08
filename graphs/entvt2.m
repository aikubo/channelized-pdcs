% graphs entrainment versus time 

cd ~/data
timesteps = 10 ; 

for theta = [10,20]
  D1 = 0; 
  D2 = 18; 
    
    fid = sprintf('%d_entrainvt', theta);
    
    did1 = '~/data/%d_%dD_proc';
    currdir = sprintf(did1, theta, D1) ;
    cd(currdir)
    
   % fid = sprintf('entvt_%d%d.tiff', theta, D);

    X = 1:timesteps;
			
    % load total  <.99999
    sum1 = importdata('EP_G_sum1');
    %% calculate entrainment 
    %entrainment = delta volume
    entrain1 = zeros(timesteps,1);
  
    did2 = '~/data/%d_%dD_proc';
    currdir = sprintf(did2, theta, D2) ;
    cd(currdir)

        % load total  <.99999
    sum2 = importdata('EP_G_sum1');
    %% calculate entrainment 
    %entrainment = delta volume
    entrain2 = zeros(timesteps,1);
 
   for t = 2:timesteps
        entrain1(t) = sum1(t,2) - sum1(t-1,2);
        entrain2(t) = sum2(t,2) - sum2(t-1,2);
   end
%% graph 
    figure;
    hold on
    set(gca, 'XTick', 0:5:10, 'XTickLabel', {'0' '25' '50'}, 'FontName', 'Arial', 'FontSize', 12)
    ylabel('Entrainment per timestep (10^{4} m^{3})')
    xlabel('Time (seconds)')
    ylim([0,35])
    xlim([0,timesteps])
    area(X,entrain1/10^4, 'FaceColor', [0 0.25 0.25])
    area(X,entrain2/10^4, 'FaceColor', [0 0.5 0.5])
 %   area(X,entrain3/10^4, 'FaceColor', [0 0.75 0.75])
    legend( 'Unconfined', 'Channelized','Location', 'NorthWest')
    
    cd ~/graphics/entvt
%% save file
    print(fid, '-djpeg')	

	cd ~/data
   end 

close all
cd ~/graphics 
