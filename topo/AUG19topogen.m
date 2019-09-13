clear all
close all

IMAX = 400;
JMAX = 150;
ZMAX = 300;
dx = 3;
center=ZMAX/2;
slope=0.18;
clearance=20;
DZ=3;
lowz= 2;
edge1 = 100;
edge2 = 200;
GRAD = 0.02;
% TEST COMMIT
% for z=1:ZMAX
%     if z< edge1 
%         DZ(z)= lowz+(edge1-z)*GRAD;
%     elseif z>edge2
%         DZ(z)= lowz + (z-edge2)*GRAD;
%     else 
%         DZ(z)=lowz
%     end


Y=zeros(ZMAX, IMAX);
for lambda=[0,300,600,900,1200]
    for W=[102,201,300,450]
       
        amprat= .15;
        amp= lambda*amprat/DZ;
        aspect = 8;
        depth = W/aspect;
        width = W/DZ;
        if W> lambda
            break
        end 
       
        
        for i = 1:IMAX
             if lambda==0
                sinuous= center;
             else        
                sinuous = amp*sind(360*(i/lambda)) + center;
             end 
             
%             
             for z = 1:ZMAX
%                 if z< edge1 
%                     DZ(z)= lowz+(edge1-z)*GRAD;
%                 elseif z>edge2
%                     DZ(z)= lowz + (z-edge2)*GRAD;
%                 else 
%                     DZ(z)=lowz;
%                 end
                
                hill= slope*dx*(IMAX -i) + clearance;
                
                if z >= sinuous-width/2 && z <= sinuous+width/2
                    
                    Y(z,i) = hill-depth;      
                else 
                    Y(z,i) = hill;
                end 
               
            end
        end

    
%figure;   
%contourf(Y)


%figure;
%correct = importdata('topo_20_18C');
%surf(correct)

%shading interp
    filen = ['l' num2str(lambda) '_W' num2str(W)];
    dlmwrite( filen ,Y,'delimiter',' ')   
        end
end
    
%surf(Y)
%contour(Y)



