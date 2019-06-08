% graph_entrainvt 
% this is a matlab script that reads in then plots bulk entrainment versus time
% this reads in the EP_G_sum# .txt files 
% graph_entrainvt 
% this is a matlab script that reads in then plots bulk entrainment versus time
% this reads in the EP_G_sum# .txt files 

figure(1)
hold on
set(gca,'FontName', 'Arial', 'FontSize', 12)
ylabel('Bulk entrainment (m^{3})')
xlabel( 'Slope of ramp (degrees)')

xticks([5 10 20])
xticklabels({'5', '10', '20'})

cd ~/data
timesteps = 12 ;

% written by AK, 11/29
for theta = 5, 10, 20
  for D = 0 
    fid = '%d_%dD';
    currdir = sprintf(fid, theta, D) ;
    cd(currdir)

    % load total  <.9999
    sum1 = importdata('EP_G_sum1');
    entrain = sum1(timesteps,2) - sum1(1,2);

    figure(1)
    hold on

    if D == 0
      plot(theta, entrain, 'k.', 'Size', 4)
    else
      plot(theta, entrain, 'b.', 'Size', 4)
    end

    cd ~/data
  end
end
cd ~/graphics 
%figure(1) 
%print('bulk_entrainment.tiff', '-dtiff')
                                                                                                                                         
                                                  
