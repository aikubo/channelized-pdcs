module sinplane 

use constants
use maketopo
use var_3d
use parampost

        contains 

        subroutine sinuousplane(centercut)
                double precision, allocatable:: sinplane(:)
                double precision:: XLOC, sinecenter
                double precision, intent(in):: centercut
        
        write(*,*) "entering sinplane"
        allocate(sinplane(length1))
                
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
                I=I+1
          end do 
     end do 

end do 
write(*,*) "writing "
        open(8888, file='sinplane')
      do I=1,length1 
         write(8888,format4var) sinplane(I), XXX(I,1),YYY(I,1),ZZZ(I,1)
      end do 

write(*,*) "finishing"
end subroutine 

end module 
