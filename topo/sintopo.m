IMAX = 400;
JMAX = 200;
ZMAX = 250;
dx = 2;
dy = 2;
dz = 2;

XX = [1:IMAX];
YY = [1:ZMAX];
lambda = IMAX;
amp = .2*ZMAX;
center = ZMAX/2 + 25;
edge1 = center-amp;
edge2 = center+amp;
Z = zeros(ZMAX,IMAX);
bend = 100;
clearance = 40;
D = 18;
W = 50;
theta = 20;
lambda = 400;
%for D = [30, 18, 12, 6]
for theta = 20 
    for lambda =[IMAX*2, IMAX, IMAX/2]
	for W = [25, 50]
       slope = tand(theta);
        center = ZMAX/2;
        for i = 1:IMAX
            for j = 1:ZMAX
            sinuous = amp*sind(i*360/lambda) + center;
                
                if j <= sinuous+W/2 && j >= sinuous-W/2
                    F= (-abs(j-sinuous)) +18;
                    Z(j,i) = slope*dx*(IMAX-i) - F; 
                else 
                    Z(j,i) = slope*dx*(IMAX-i);
                end
           % end
            end
          end
     Z=Z+clearance;
%surfc(Z)
%contour(Z)
%shading interp
    filen = ['topo_vwsin_' num2str(theta) '_' num2str(D) '_l' num2str(lambda) '_w' num2str(W)];
    dlmwrite( filen ,Z,'delimiter',' ')   
  end
end
end
%end
%surf(Z)

