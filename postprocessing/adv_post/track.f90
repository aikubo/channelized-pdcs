module track 
use formatmod
use parampost
use constants
use openbinary
use maketopo
use makeascii
use var_3d
use filehead

contains 

    subroutine track_parcel
        implicit none 
        integer:: n, tracers ! number of parcel tracers
        integer:: xc, rc, yc
        DOUBLE PRECISION:: XLOC, YLOC, ZLOC, intervalz, intervaly
        DOUBLE PRECISION, ALLOCATABLE:: location(:,:,:), start(:)
        double precision:: deltax, deltay, deltaz, U, V, W
        tracers=4
        allocate(location(tracers,3,timesteps))
        allocate(start(tracers))
        
        ! assign starting X locations of tracers 
        ! eventually add some in front of the flow
        do n=1,tracers
            start(n)=6
        end do 
    
        ! assign Y & Z locations of tracers based on starting location
        do n=1,tracers
            call edges(width, lambda, depth, start(n), edge1, edge2, bottom, top)
            print*, "edges and bottom" 
            print*, edge1, edge2, bottom
 
            intervalz=(width/tracers)/2
            intervaly=depth/tracers
            YLOC=floor((intervaly+bottom)/3)*3
            ZLOC=floor((n*intervalz+edge1)/3)*3

            location(n,1,1)=start(n)
            location(n,2,1)=YLOC
            location(n,3,1)=ZLOC

            print*, location(n,:,1)
        end do 

        ! begin to loop through time tracking velocity
        do n=1,tracers
            do t=2,timesteps 
                xc= int(floor(location(n,1,t-1))/3.0)
                yc= int(floor(location(n,2,t-1))/3.0)
                zc= int(floor(location(n,3,t-1))/3.0)

                call FUNIJK(xc,yc,zc,I)
                U=U_G1(I,t-1)
                V=V_G1(I,t-1)
                W=W_G1(I,t-1)                

                deltax= U*deltat
                deltay= V*deltat
                deltaz= W*deltat

                ! unrounded locations based on previous timestep
                
                XLOC= location(n,1,t-1) + deltax
                YLOC= location(n,2,t-1) + deltay
                ZLOC= location(n,3,t-1) + deltaz
                
                print*, XLOC, YLOC, ZLOC
                !print*,  U, V, W
                !print*, deltax, deltay, deltaz
                ! assign tracers new location
                location(n,1,t)=XLOC
                location(n,2,t)=YLOC
                location(n,3,t)=ZLOC
            end do 
        end do 

    end subroutine 

end module



