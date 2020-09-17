module sinplane 

use constants
use maketopo
use var_3d
use parampost

        contains 

        subroutine sinuousplane(tout)
                double precision, allocatable:: sinplane(:)
                double precision, allocatable:: isocut(:), isocut2(:)
                double precision, allocatable:: edge2iso(:)
                double precision:: XLOC, sinecenter
                double precision:: centercut
                integer, intent(in):: tout 
        centercut=(ZMAX*3.0)/2

        write(*,*) "entering sinplane"
        allocate(sinplane(length1))
        allocate(isocut(length1))
        allocate(isocut2(length1))
        allocate(edge2iso(length1))
                
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
write(*,*) "entering loop"
I=1
DO zc=1,ZMAX
     DO rc=1,RMAX
          DO yc=1,YMAX
                XLOC=rc*DX(1)
                centerline = lambda*amprat*sind((360*XLOC)/lambda)+centercut
                sinplane(I)= (centerline-zc*(3.0))
                edge2= lambda*amprat*sind((360*XLOC)/lambda)+centercut+width/2 - zc*3.0
                
                if (lambda .eq. 0) then 
                        sinplane(I)=(ZMAX/2)*3
                end if 


                if (sinplane(I) .gt. 0) then 
                         isocut(I)=EPP(I,tout)
                         isocut2(I)=0
                        if (EPP(I,8) .le. dble(0.0000000010)) then 
                                isocut(I)=dble(14)
                        end if 
                else   
                         isocut(I)=dble(14)
                         isocut2(I)=EPP(I,tout)       
                end if 
                
                if ( edge2 .gt. 0 ) then 
                        edge2iso(I)=EPP(I,tout)
                else 
                        edge2iso(I)=14
                end if 

                

                I=I+1
          end do 
     end do 

end do 
write(*,*) "writing "

if (tout .eq. 1) then
        open(8888, file='sinplane')
end if 
        open(8889, file="isocut")
        open(8890, file="mapcut")
        open(8891, file="edge2iso")
      do I=1,length1

        if (tout .eq. 1) then  
         write(8888,format4var) sinplane(I), XXX(I,1),YYY(I,1),ZZZ(I,1)
        end if 

         write(8889,format4var) isocut(I), XXX(I,1),YYY(I,1),ZZZ(I,1)
         write(8890,format4var) isocut2(I), XXX(I,1),YYY(I,1),ZZZ(I,1)
         write(8891, format4var) edge2iso(I), XXX(I,1),YYY(I,1),ZZZ(I,1)
      end do 

write(*,*) "finishing"
end subroutine 

end module 
