IMAX = 400;
JMAX = 200;
ZMAX = 700;
dx = 2;
dy = 2;
dz = 2;

oldZMAX= 150;

lambda = IMAX;
amp = .2*oldZMAX;
center = ZMAX/2 ;
%for D = [30, 18, 12, 6]
%for theta = [15,20] 
%    for lambda =[IMAX*2, IMAX, IMAX/2]
%	for W = [25, 50]
theta=20;
clearance= 8;
D= 65;
W=500;
       slope = tand(theta);
        center = ZMAX/2;
        for i = 1:IMAX
            for j = 1:ZMAX
            %sinuous = amp*sind(i*360/lambda) + center;
                
                if j <= center+W/2 && j >= center-W/2
                    Z(j,i) = slope*dx*(IMAX-i) - D; 
                else 
                    Z(j,i) = slope*dx*(IMAX-i);
                end
           end
         end
%          end
     Z=Z+clearance;
%surfc(Z)
%contour(Z)
%shading interp
    filen = ['topo_big_M' num2str(theta) '_D' num2str(D) '_w' num2str(W)];
    dlmwrite( filen ,Z,'delimiter',' ')   
  %end
%end
%end
%end
%surf(Z)

