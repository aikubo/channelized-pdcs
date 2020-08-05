module maketopo

use parampost 
use constants
use formatmod

contains
subroutine handletopo(filename, OUTX, OUTY, OUTZ)

        
        implicit none 
        character(LEN=*), INTENT(IN):: filename 
        DOUBLE PRECISION, DIMENSION(:,:), INTENT(INOUT):: OUTX
        DOUBLE PRECISION, DIMENSION(:,:), INTENT(INOUT):: OUTY
        DOUBLE PRECISION, DIMENSION(:,:), INTENT(INOUT):: OUTZ
        



        !------------OPEN the topography files-------!
        OPEN(602,FILE=filename)
        !------------OPEN the topography files-------!i


       !-------------------------------READTOPOGRAPHY----------------------------------!
        REWIND(602)
        READ(602,*) channel_topo
        !-------------------------------READ TOPOGRAPHY----------------------------------!
        !print*, 'begin spatial deltas'

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
                                y_boundary=channel_topo(rc-2,zc-1) !-2.*DY(1)
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
       open(6010, file='topography')
       open(6011, file='topo2')
                print *, "writing topo for dx visuals"
                DO I = 1,RMAX*ZMAX*YMAX
                        WRITE(6010,format4var) topography(I),XXX(I,1),YYY(I,1),ZZZ(I,1)
                        WRITE(6011,format4var) topo2(I),XXX(I,1),YYY(I,1),ZZZ(I,1)
               END DO
end subroutine


subroutine edges(wid, lamb, dep, XLOC,slope, edge1, edge2, bottom, top)
       implicit none 
       double precision, intent(IN):: wid, dep, lamb, XLOC, slope
       double precision, intent(OUT):: edge1, edge2, bottom, top
       double precision:: deltz, centerline, center, clearance
        deltz=3.0
        center = (ZMAX-2)*deltz/2 

        clearance = 50.
        if (simlabel == 'test')then 
            clearance=3
        end if 
        
        if (lamb .eq. 0) then 
        centerline = center
        else 
          centerline = lamb*amprat*sind((360*XLOC)/lamb)+center
        end if 

        edge1=int((centerline-wid/2)/3)*3
        edge2=int((centerline+wid/2)/3)*3

        bottom= (int((slope*deltz*(RMAX-(XLOC/deltz)) +clearance -dep)/3))*3
        top= bottom+dep
end subroutine

subroutine edges2(wid, lamb, dep, XLOC,ZLOC, slope,top)
       implicit none
       double precision, intent(IN):: wid, dep, lamb, XLOC,ZLOC, slope
       double precision, intent(OUT):: top
       double precision:: deltz, centerline, center, clearance
        deltz=3.0
        center = (ZMAX-2)*deltz/2

        clearance = 50.
        if (simlabel == 'test')then
            clearance=DX(1)
        end if

        if (lamb .eq. 0) then
        centerline = center
        else
          centerline = lamb*amprat*sind((360*XLOC)/lamb)+center
        end if

        edge1=int((centerline-wid/2)/3)*3
        edge2=int((centerline+wid/2)/3)*3
        bottom= (int((slope*deltz*(RMAX-(XLOC/deltz)) +clearance -dep)/3))*3

        if (ZLOC .gt. edge1 .and. ZLOC .lt. edge2) then 
        top= (int((slope*deltz*(RMAX-(XLOC/deltz)) +clearance -dep)/3))*3
        else 
        top= bottom+dep

        end if 

end subroutine

subroutine FUNIJK(xl,yl,zl,IJK)
     implicit none 
     integer, intent(IN):: xl, yl, zl
     integer, intent(OUT):: IJK
     ! FUNIJK_GL (LI, LJ, LK) = 1 + (LJ - jmin3) +
     ! (LI-imin3)*(jmax3-jmin3+1) &
     ! + (LK-kmin3)*(jmax3-jmin3+1)*(imax3-imin3+1)

     IJK = 1 + (yl-1) +(xl-1)*(YMAX-1+1) +  (zl-1)*(YMAX-1+1)*(RMAX-1+1) 
end subroutine

subroutine loctoind(loc,ind)
     double precision, intent(IN):: loc
     integer, intent(out):: ind

     ind= int( floor(loc)/3)
end subroutine

end module maketopo
