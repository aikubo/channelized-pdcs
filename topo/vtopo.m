clear all


IMAX = 400;
JMAX = 200;
ZMAX = 150;
dx = 2;
dy = 2;
dz = 2;
W = 50;

%XX = [1:IMAX];
%YY = [1:JMAX];
%lambda = IMAX;
%amp = .2*JMAX;
center = ZMAX/2;
%edge1 = center-W/2;
%edge2 = center+W/2;
Z = zeros(ZMAX,IMAX);
%bend = 100;
%D= [18, 10];
%for theta =[10,20]
 %   for D = [6, 12, 18, 30] 
 %       for W=[10, 25,50]
clearance = 20;
theta=20;
        slope= tand(theta); 
        edge1 = center-W/2;
        edge2 = center+W/2;
        for i = 1:IMAX
            for z = 1:ZMAX
                if z <= edge2 && z >= edge1
                    D= -abs(z-center)+18;
                    Z(z,i) = slope*dx*(IMAX -i)-D+clearance; 
                  
                else 
                    Z(z,i) = slope*dx*(IMAX -i)+clearance;
                end 
                
                if theta == 0
                    Z(z,i) = Z(z,i) + clearance;
                end
            end
        end

    
figure;   
surfc(Z)
%contourf(Z)
%correct = importdata('topo_20_18C');

%shading interp
    filen = ['vtopo_' num2str(theta) '_' num2str(D) '_' num2str(W)];
    dlmwrite( filen ,Z,'delimiter',' ')   
        %end
    %end
%end

