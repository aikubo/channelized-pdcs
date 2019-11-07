module trackparcel 
use formatmod
use parampost
use constants
use openbinary
use maketopo
use makeascii
use var_3d
use filehead

contains 

    subroutine track
        implicit none 
        integer:: n, tracers ! number of parcel tracers
        DOUBLE PRECISION:: XLOC, YLOC, ZLOC, intervalz, intervalx
        DOUBLE PRECISION, ALLOCATABLE:: location(:,:,:), start(:)
        double precision:: deltax, deltay, deltaz, U, V, W
        tracers=2
        allocate(location(tracers,3,timesteps))
        allocate(start(tracers))
        
        ! assign starting X locations of tracers 
        ! eventually add some in front of the flow
        do n=1,tracers
            start(n)=0
        end do 
    
        ! assign Y & Z locations of tracers based on starting location
        do n=1,tracers
            call edges(width, lambda, depth, start(n), edge1, edge2, bottom, top)
            intervalz=width/tracers
            intervalx=depth/tracers
            ZLOC=floor((n*intervalx+edge1/3))*3
            YLOC=floor((n*intervalz+bottom/3))*3

            location(n,1,1)=start(n)
            location(n,2,1)=YLOC
            location(n,3,1)=ZLOC
        end do 

        ! begin to loop through time tracking velocity
        do n=1,tracers
            do t=2,timesteps 
                xc= int(floor(location(n,1,t-1))/3.0)
                yc= int(floor(location(n,2,t-1))/3.0)
                zc= int(floor(location(n,3,t-1))/3.0)

                call FUNIJK(xc,yc,zc,IJK)
                U=U_G1(IJK,t-1)
                V=V_G1(IJK,t-1)
                W=W_G1(IJK,t-1)                

                deltax= U*deltat
                deltay= V*deltat
                deltaz= W*deltat

                ! unrounded locations based on previous timestep
                
                XLOC= location(n,1,t-1) + deltax
                YLOC= location(n,2,t-1) + deltay
                ZLOC= location(n,3,t-1) + deltaz
                
                print*, XLOC, YLOC, ZLOC
                ! assign tracers new location
                location(n,1,t)=XLOC
                location(n,2,t)=YLOC
                location(n,3,t)=ZLOC
            end do 
        end do 

    end subroutine 

end module



