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
    double precision:: top, m  
    logical:: inchannel
    double precision, allocatable:: data(:,:,:)
    double precision, allocatable, intent(inout):: data2(:,:)
    allocate(data(X,Y,Z))
    m=slope
    midx=X/2 
    midy=y/2
    midz=z/2
    ! 4 x 4 x 4 
    ! make topography
   
    !do rc =1,X
        !zc=4
        !yc=6
        !call edgesdose(width, lambda, depth, dble(rc),dble(zc),dble(yc),m,top,inchannel)
        !write(*,*) rc, top,inchannel
        !write(*,*) "expecting",rc, ceiling((.5*(8-rc))+1), "F"
    !    do zc=1,Z!midz-width/2, midz+width/2   
    !        do yc=1,Y !2,Y
    do t=1,timesteps
     I=1
        DO zc=1,ZMAX
             DO rc=1,RMAX
                  DO yc=1,YMAX      
                  call edgesdose(width, lambda, depth, XXX(I,1), YYY(I,1),  ZZZ(I,1), m,top,inchannel)
                if (inchannel) then 
                        data2(I,t)=0.9
   !                     write(*,*) XXX(I,1), ZZZ(I,1), YYY(I,1), data2(I,t)
                else 
                        data2(I,t)=1
                end if 
                I=I+1
            end do 
        end do 
    end do 
   end do 
        !data(1,4,2)=0.9
        !data(1,4,3)=0.99
        !data(2,4,2)=0.9 
        !data(2,4,3)=0.999
        !data(3,3,3)=0.9999
        !data(4,3,2)=0.9
        !data(2,2,3)=0.9 
        !data(1,3,2)=0.9        
                   
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
            !DZ(1)=1.0
            !z(1)=2240. !Z is in reverse compared to X & Y
            z(1)=DZ(1)
            DO zc=2,ZMAX
           
             DZ(zc)=DZ(zc-1)
             z(zc)=DY(zc)+x(zc-1)

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
                            !write(*,*) rc, OUTX(I,1), yc, OUTY(I,1), zc,OUTZ(I,1)
                            I=I+1
                            !write(*,*) rc, OUTX(I,1), yc, OUTY(I,1), zc, OUTZ(I,1) 
                      END DO
                 END DO
            END DO
            
    end subroutine 
        
        
   end module  
