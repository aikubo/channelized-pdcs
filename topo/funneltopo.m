clear all


IMAX = 400;
JMAX = 200;
ZMAX = 150;
dx = 2;
dy = 2;
dz = 2;
W = 25;

%XX = [1:IMAX];
%YY = [1:JMAX];
%lambda = IMAX;
%amp = .2*JMAX;
center = ZMAX/2;
edge1 = center-W/2;
edge2 = center+W/2;
Z = zeros(ZMAX,IMAX);
%bend = 100;

for theta = [5, 10, 20] 
    for D = [0, 6, 12, 18, 30] 
%theta = 20;

slope = tand(theta);
%D = 18; 
clearance = 20;
for W= [10, 25,50]
    edge1 = center-W/2;
    edge2 = center+W/2;

    slope = tand(theta);
    
        for i = 1:IMAX
            for z = 1:ZMAX
                        if i<IMAX/2
                            if z <= edge2 && z >= edge1
                                Z(z,i) = slope*dx*(IMAX -i) - D ; 
                            else 
                                Z(z,i) = slope*dx*(IMAX -i);
                            end
                        else
                            Z(z,i) = slope*dx*(IMAX -i) -D ;
                        end 
    
		end
	end
                    
     Z = Z +clearance ;
%surf(Z)
%figure()
%contour(Z)
%shading inter
   filen = ['topo_funnel_' num2str(theta) '_' num2str(D) '_' num2str(W)];
    dlmwrite( filen ,Z,'delimiter',' ')   
 %end


%for theta= [0,5,20,10]
X=zeros(ZMAX,IMAX);
    slope = tand(theta);
        for i = 1:IMAX
            for z = 1:ZMAX
                        if i>IMAX/2
                            if z <= edge2 && z >= edge1
                                X(z,i) = slope*dx*(IMAX -i) - D;
                            else
                                X(z,i) = slope*dx*(IMAX -i) ;
                            end
                        else
                            X(z,i) = slope*dx*(IMAX -i) -D ;
                        end

       	      end 
       end     
 X = X + clearance;
%surfc(X)
%figure()
%contour(X)
%shading inter
   filen = ['topo_nfunnel_'  num2str(theta) '_' num2str(D) '_' num2str(W)];
    dlmwrite( filen ,X,'delimiter',' ')
end             %end
    end
end

%surf(Z)

%figure;
%surf(X)

