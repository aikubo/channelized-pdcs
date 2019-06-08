% graphs entrainment versus time 

cd ~/data
timesteps = 10 ; 

for theta = 20
  for D = 18 
    did = '%d_%dD_proc';
    currdir = sprintf(did, theta, D) ;
    cd(currdir)
    
    fid = sprintf('entvv_%d%d.tiff', theta, D);

    X = 1:timesteps;
			
    % load total  <.99999
    sum1 = importdata('EP_G_sum1');
    % load dilute  <.999
    sum2 = importdata('EP_G_sum2');
    % load dense <.99
    sum3 = importdata('EP_G_sum3');

    %% calculate entrainment 
    %entrainment = delta volume
    entrain1 = zeros(timesteps,1);
    entrain2 = zeros(timesteps,1);
    entrain3 = zeros(timesteps,1);

    for t = 2:timesteps
        entrain1(t) = sum1(t,2) - sum1(t-1,2);
        entrain2(t) = sum2(t,2) - sum2(t-1,2);
        entrain3(t) = sum3(t,2) - sum3(t-1,2);
    end

    v1 = importdata('avgU1'); 
    v2 = importdata('avgU2');
    v3 = importdata('avgU3');
%% graph 
    figure;
    hold on
    
%    set(gca, 'XTick', 0:5:10, 'XTickLabel', {'0' '25' '50'}, 'FontName', 'Arial', 'FontSize', 12)
    xlabel('Entrainment per timestep (10^{4} m^{3})')
    ylabel('Velocity (m/s)')
    set(gca, 'XScale', 'log')
    plot(log(entrain1), v1(:,2), 'Color', [0 0.25 0.25], 'LineWidth', 2)
    plot(log(entrain2), v2(:,2), 'Color', [0 0.5 0.5], 'LineWidth', 2)
    plot(log(entrain3), v3(:,2), 'Color', [0 0.75 0.75], 'LineWidth', 2)

          
    legend('Dilute (<.001 Particle fraction)', 'Mid particle fraction', 'Dense (<0.1 Particle Fraction)' , 'Location','SouthEast')

  
%    cd ~/graphics/entvt
%% save filei
%    print(fid,'-djpeg')	

	cd ~/data
   end 
end
%close all
cd ~/graphics 
