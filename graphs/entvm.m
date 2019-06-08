% graphs entrainment versus time 

cd ~/data
timesteps = 10 ; 

    figure(1);
    hold on
    set(gca, 'XTick', 0:10:20, 'FontName', 'Arial', 'FontSize', 12)
    ylabel('Bulk Entrainment (10^{4} m^{3})')
    xlabel('Slope (degrees)')
    ylim([0,170])
    xlim([0,30])

k1 = 0 ;
k2 = 0 ;
for M = [10,20]
  for D = [0,18] 
    did = '%d_%dD_proc';
    currdir = sprintf(did, M, D) ;
    cd(currdir)
    
    fid = sprintf('entvm_%d%d.tiff',M, D);
			
    % load total  <.99999
    sum1 = importdata('EP_G_sum1');

    %% calculate entrainment 
    %entrainment = delta volume
    entrain1 = zeros(timesteps,1);
  
    for t = 2:timesteps
        entrain1(t) = sum1(t,2) - sum1(t-1,2);
    end

    bulk = sum(entrain1)/10^4; 
    
%% graph 
    figure(1);
    hold on

    if D == 18 
      % k2 = k2+1;
       plot(M, bulk, 'k.', 'MarkerSize', 25)
      % b2(k2) = bulk    
    end 
     
  
    
    if D == 0
      % k1 = k1+1; 
       plot(M,bulk, 'b.', 'MarkerSize', 25)
      % b1(k1) = bulk
    end

    if M == 10 & D == 18
      legend('Unconfined', 'Channelized', 'Location', 'NorthWest')
    end

%cd ~/graphics/entvt
%% save file
%   print(fid,'-djpeg')	

	cd ~/data
   clear bulk 
   clear entrain1 
   clear sum1
   end 
end

cd ~/graphics

print('entvm', '-dtiff')
clear all



%close all
%M = [ 10 20]; 

%p1 = polyfit(M,b1,1)
%f1 = polyval(p1,M);
%hold on
%plot(M,f1,'--r')


%p2 = polyfit(M,b2,1)
%f2 = polyval(p2,M);
%hold on
%plot(M,f2,'--r')

