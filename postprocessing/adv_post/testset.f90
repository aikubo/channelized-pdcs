!! test module 

module test 
use parampost 
use constants
use formatmod 
use maketopo 
contains
subroutine createtestdata(X,Y,Z,slope, data2)
    implicit none 
    integer, intent(in):: X,Y,Z 
    double precision, intent(in):: slope
    integer:: midx, midy, midz
    
    double precision, allocatable:: data(:,:,:)
    double precision, allocatable, intent(inout):: data2(:,:)
    allocate(data(X,Y,Z))
    
    midx=X/2 
    midy=y/2
    midz=z/2
    ! 4 x 4 x 4 
    ! make topography 
    do rc =1,X 
        do zc=1,Z
            do yc=1,Y 
                data(rc, yc, zc)=1.0 
            end do 
        end do
    end do   
    
    !do rc =1,X
    !    do zc=midz-width/2, midz+width/2   
    !        do yc=2,Y
    !            data(rc,yc,zc)=0.9
    !        end do 
    !    end do 
    !end do 
    
        data(1,4,2)=0.9
        data(1,4,3)=0.99
        data(2,4,2)=0.9 
        data(2,4,3)=0.999
        data(3,3,3)=0.9999
        data(4,3,2)=0.9
        !data(2,2,3)=0.9 
        !data(1,3,2)=0.9        
   

    do t=1,timesteps
        do rc=1,X
            do yc=1,Y
                do zc=1,Z
                    call FUNIJK(rc,yc,zc,I)
                    
                    data2(I,t)=data(rc,yc,zc)
                end do 
            end do 
        end do
    end do 
                    
    end subroutine 
   
    subroutine testtopo(OUTX,OUTY,OUTZ)
        implicit none 
        DOUBLE PRECISION, DIMENSION(:,:), INTENT(INOUT):: OUTX
        DOUBLE PRECISION, DIMENSION(:,:), INTENT(INOUT):: OUTY
        DOUBLE PRECISION, DIMENSION(:,:), INTENT(INOUT):: OUTZ
                DX(1)=1.0
            x(1)=DX(1)
            DO rc=2,RMAX
            DX(rc)=DX(rc-1)
            x(rc)=DX(rc)+x(rc-1)
            END DO
            DY(1)=1.0!0.375
            y(1)=DY(1)
            DO zc=2,YMAX
             DY(zc)=DY(zc-1)
              y(zc)=DY(zc)+y(zc-1)
            END DO
            DZ(1)=1.0
            !z(1)=2240. !Z is in reverse compared to X & Y
            DO zc=2,ZMAX
           
             DZ(zc)=DZ(zc-1)
             z(zc)=DY(zc)+z(zc-1)
            END DO
            !! end create spatial deltas!!
    
            !------------------------------ Create grid matrices of length
            !RMAX*ZMAX*YMAX ----------------------------!
            I=1
            DO zc=1,ZMAX
                 DO rc=1,RMAX
                      DO yc=1,YMAX
                            XX(rc,yc,zc)=x(rc)
                            OUTX(I,1)=XX(rc,yc,zc)
                            YY(rc,yc,zc)=y(yc)
                            OUTY(I,1)=YY(rc,yc,zc)
                            ZZ(rc,yc,zc)=z(zc)
                            OUTZ(I,1)=ZZ(rc,yc,zc)
                            I=I+1
                      END DO
                 END DO
            END DO
            
    end subroutine 
        
        
   end module  
