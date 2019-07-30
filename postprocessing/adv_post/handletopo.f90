module maketopo

use parampost 
use constants

contains
subroutine handletopo(filename, OUTX, OUTY, OUTZ)

        
        implicit none 
        character(LEN=*), INTENT(IN):: filename 
        DOUBLE PRECISION, DIMENSION(:,:), INTENT(INOUT):: OUTX
        DOUBLE PRECISION, DIMENSION(:,:), INTENT(INOUT):: OUTY
        DOUBLE PRECISION, DIMENSION(:,:), INTENT(INOUT):: OUTZ
        



        !------------OPEN the topography files-------!
        OPEN(600,FILE='topo',form='formatted')
        OPEN(601,FILE='topo2',form='formatted')
        OPEN(602,FILE=filename)
        !------------OPEN the topography files-------!i


       !-------------------------------READTOPOGRAPHY----------------------------------!
        REWIND(602)
        READ(602,*) channel_topo
        !-------------------------------READ TOPOGRAPHY----------------------------------!
        !print*, 'begin spatial deltas'

        DX(1)=2.0
        x(1)=DX(1)
        DO rc=2,RMAX
        DX(rc)=DX(rc-1)
        x(rc)=DX(rc)+x(rc-1)
        END DO
        DY(1)=2.0!0.375
        y(1)=DY(1)
        DO zc=2,YMAX
         DY(zc)=DY(zc-1)
          y(zc)=DY(zc)+y(zc-1)
        END DO
        DZ(1)=2.0
        !z(1)=2240. !Z is in reverse compared to X & Y
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
                y_boundary=-0.0022*(x(rc)**3)+0.1082*(x(rc)**2)-1.8888*x(rc)+12.817
                y_boundary=0.0
                     IF (rc>2 .and. rc<RMAX-2) THEN
                         IF (zc>1 .and. zc<ZMAX-1) THEN
                                y_boundary=channel_topo(rc-2,zc-1)-2.*DY(1)
                         END IF
                     END IF
                topography(I)=y_boundary-y(yc)
                topo2(I)=y(yc)
                I=I+1
          END DO
     END DO
END DO

print*, 'topography loaded'
!------------------------------ Create grid matrices of length
!RMAX*ZMAX*YMAX ----------------------------!
end subroutine handletopo

subroutine writedxtopo
       implicit none 
                print *, "writing topo for dx visuals"
                DO I = 1,RMAX*ZMAX*YMAX
                        WRITE(600,400) topography(I),XXX(I,1),YYY(I,1),ZZZ(I,1)
                        WRITE(601,400) topo2(I),XXX(I,1),YYY(I,1),ZZZ(I,1)
               END DO
        400 FORMAT(4F22.12)
end subroutine


end module maketopo