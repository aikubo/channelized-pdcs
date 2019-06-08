% graphs entrainment versus time 

cd ~/data
timesteps = 15 ; 

%for theta = [5,10,20]
for theta = 20
  for D = 0 
    did = '%d_%dD';
    currdir = sprintf(did, theta, D) ;
    cd(currdir)
    
    fid = sprintf('entvtemp_%d%d.tiff', theta, D);

    if theta == 5 
	timesteps = 12 
    end 
	
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

   % load total  <.99999
    sum1t = importdata('avgT1');
    % load dilute  <.999
    sum2t = importdata('avgT2');
    % load dense <.99
    sum3t = importdata('avgT3');

    %% calculate
    temp1 = sum1t(:,2);
    temp2 = sum2t(:,2);
    temp3 = sum3t(:,2);

%% graph 
    figure;
    hold on
    set(gca,'XDir', 'reverse','FontName', 'Arial', 'FontSize', 12 )
    ylabel('Entrainment per timestep (10^{4} m^{3})')
    xlabel('Temperature (K)')
   % ylim([0,65])
   % xlim([0,timesteps])
   plot(temp1, entrain1)


    legend('Dilute (<.001 Particle fraction)', 'Mid particle fraction', 'Dense (<0.1 Particle Fraction)' , 'Location', 'NorthWest')

    cd ~/graphics/entvt
%% save file
%    print(fid,'-dtiff')	
	
	cd ~/data
   end 
end 
