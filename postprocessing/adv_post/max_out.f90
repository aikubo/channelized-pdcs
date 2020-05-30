module maxout

use parampost 
use constants
use formatmod 
use maketopo

contains 
        subroutine dxmaxof(field, filename, nunit)
        double precision, allocatable, intent(in):: field(:,:) 
        character(len=*), intent(in):: filename 
        integer, intent(in):: nunit
        double precision, allocatable:: dxfieldmax(:)
        ! find max of all timesteps and writes out for opendx !
        open(nunit, file=filename)
        allocate(dxfieldmax(length1))
        write(*,*) 1
        do i=1,length1
                dxfieldmax(i)=0
        end do 
        write(*,*) 2 
        do t=1,timesteps
                do i=1,length1
                        if ( field(i,t) .gt. dxfieldmax(i)) then 
                               dxfieldmax(i)=field(i,t) 
                        end if 
                end do 
        end do 
        write(*,*) 4
        do i=1,length1
                write(nunit, format4var) dxfieldmax(i), XXX(i,1), YYY(i,1), ZZZ(i,1)
        end do

        write(*,*) 5
        end subroutine 


        subroutine dxminof(field, filename, nunit)
        double precision, allocatable, intent(in):: field(:,:)
        character(len=*), intent(in):: filename
        double precision, allocatable:: fieldmin(:)
        integer, intent(in):: nunit
        ! find max of all timesteps and writes out for opendx !
        open(nunit, file=filename)
        allocate(fieldmin(length1))
        do i=1,length1
                fieldmin(i)=0
        end do

        do t=1,timesteps
                do i=1,length1
                        if ( field(i,t) .lt. fieldmin(i)) then   
                                fieldmin(i)=field(i,t)
                        end if
                end do
        end do

         do i=1,length1
                write(nunit, format4var) fieldmin(i), XXX(i,1), YYY(i,1),ZZZ(i,1)
        end do
        end subroutine

        subroutine TOUTAVE
        double precision:: XLOC
        double precision:: sum_out 
        double precision, allocatable:: T_OUT_AV(:)
        
        allocate(T_OUT_AV(timesteps))

              DX(1)=3.0
        x(1)=DX(1)
        DO rc=2,RMAX
        DX(rc)=DX(rc-1)
        x(rc)=DX(rc)+x(rc-1)
        END DO
        DY(1)=3.0!0.375
        y(1)=DY(1)
        DO zc=2,YMAX
         DY(zc)=DY(zc-1)
          y(zc)=DY(zc)+y(zc-1)
        END DO
        DZ(1)=3.0
        !z(1)=2240. !Z is in reverse compared to X & Y
        DO zc=2,ZMAX

         DZ(zc)=DZ(zc-1)
         z(zc)=DY(zc)+x(zc-1)
        END DO
        !! end create spatial deltas!!

        do t=1,timesteps
        !------------------------------ Create grid matrices of length
        !RMAX*ZMAX*YMAX ----------------------------!
        sum_in=0
        DO zc=1,ZMAX
             DO rc=1,RMAX
                  DO yc=1,YMAX
                        XLOC=rc*3.0
                        call edges(width, lambda, depth, XLOC, edge1, edge2, bottom, top)
                        
                        if ( yc*DY(1) .gt. top .and. yc*DY(1) .lt. top+10) then 
                                if ( zc*DZ(1) .gt. edge2) then 
                                        call FUNIJK(rc,yc,zc,IJK)
                                        sum_in=sum_in+1
                                        T_OUT_AV(t)=(1-EP_G1(i,t))*T_G1(i,t)+T_OUT_AV(t)
                                end if 
                        end if 

                  end do 
              end do 

        end do 

        T_OUT_AV(t)=T_OUT_AV(t)/sum_in

        write(*,*) t, T_OUT_AV(t)
        end do

        end subroutine 
                                    
end module    
                    
