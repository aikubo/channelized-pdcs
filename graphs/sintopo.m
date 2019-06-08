IMAX = 400;
JMAX = 200;
ZMAX = 150;
dx = 2;
dy = 2;
dz = 2;
W = 25;

XX = [1:IMAX];
YY = [1:ZMAX];
lambda = IMAX;
amp = .2*ZMAX;
center = ZMAX/2 + 25;
edge1 = center-amp;
edge2 = center+amp;
Z = zeros(ZMAX,IMAX);
bend = 100;
clearance = 20;
D = 18;
W = 50;
theta = 20;
lambda = 400;
% !for theta = [15,20] 
% !    for lambda =[IMAX, IMAX/2]
% !	for W = [25, 50]


       slope = tand(theta);
        center = ZMAX/2;
        for i = 1:IMAX
            for k = 1:JMAX
            sinuous1(i) = -2*(amp*sind(i*360/lambda) + center - W/2);
            sinuous2(i)= -2*(amp*sind(i*360/lambda) + center + W/2);
               %YY(i,k) = sinuous;
            end
           
        end
figure;
hold on 
plot(flipud(sinuous1))
plot(flipud(sinuous2))
%ylim([0 300])
grid on   
     
%surfc(Z)
%contour(Z)
%shading interp
   % filen = ['horizontalplane' ];
   % dlmwrite( filen ,Z,'delimiter',' ')   
%  ! end
% !end
% !end
%surf(Z)

