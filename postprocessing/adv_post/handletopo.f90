module maketopo

use parampost
use constants
use formatmod

contains
subroutine handletopo(filename, dxi2, OUTX, OUTY, OUTZ)
        use parampost

        implicit none
        character(LEN=*), INTENT(IN):: filename
        DOUBLE PRECISION, DIMENSION(:,:), INTENT(INOUT):: OUTX
        DOUBLE PRECISION, DIMENSION(:,:), INTENT(INOUT):: OUTY
        DOUBLE PRECISION, DIMENSION(:,:), INTENT(INOUT):: OUTZ
        double precision, intent(IN):: dxi2



        !------------OPEN the topography files-------!
        OPEN(602,FILE=filename)
        !------------OPEN the topography files-------!i


       !-------------------------------READTOPOGRAPHY----------------------------------!
        REWIND(602)
        READ(602,*) channel_topo
        !-------------------------------READ TOPOGRAPHY----------------------------------!
        !print*, 'begin spatial deltas'

        DX(1)=dxi2
        x(1)=DX(1)
        DO rc=2,RMAX
        DX(rc)=DX(rc-1)
        x(rc)=DX(rc)+x(rc-1)
        END DO
        DY(1)=dxi2 !0.375
        y(1)=DY(1)
        DO zc=2,YMAX
         DY(zc)=DY(zc-1)
          y(zc)=DY(zc)+y(zc-1)
        END DO
       DZ(1)=dxi2
        !z(1)=2240. !Z is in reverse compared to X & Y
       ! z(1)=3.0
        DO zc=2,ZMAX
         DZ(zc)=DZ(zc-1)
         z(zc)=DZ(zc)+x(zc-1)
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
        deltz=DX(1)
        center = (ZMAX-2)*deltz/2

        clearance = 50.
        if (simlabel == 'test')then
            clearance=DY(1)
        end if

        if (lamb .eq. 0) then
        centerline = center
        else
          centerline = lamb*amprat*sind((360*XLOC)/lamb)+center
        end if
        write(*,*) centerline
        edge1=dble(ceiling((centerline-wid/2)/deltz)*deltz)-deltz
        edge2=dble(ceiling((centerline+wid/2)/deltz)*deltz)-deltz

        bottom= int(ceiling((slope*deltz*(RMAX-(XLOC/deltz)) +clearance-dep)/deltz))*deltz
        top= bottom+dep
end subroutine

subroutine whereedges(wid, lamb, dep, XLOC,slope, midline, edge1, edge2, bottom, top)
  implicit none
  double precision, intent(IN):: wid, dep, lamb, XLOC, slope
  double precision, intent(OUT):: edge1, edge2, bottom, top, midline
  double precision:: topchannel, bottochannel, deltz, centerline, center, clearance
  double precision:: mid, topo
  logical:: foundtop 
  integer:: I2
   deltz=dble(DX(3))
   mid=dble(ZMAX)
   !write(*,*) ZMAX, mid
   center = mid/2.0*deltz

   clearance = 50.
   if (simlabel == 'test')then
       clearance=2*deltz
   end if
   !write(*,*) clearance, center
   if (lamb .lt. 1) then
           centerline = center
   else
     centerline = lamb*amprat*sind((360*XLOC)/lamb)+center
   end if
   midline=centerline

   !write(*,*) centerline

   inchannel=.FALSE.
   edge1=dble(ceiling((centerline-wid/2)/deltz)*deltz)
   edge2=dble(ceiling((centerline+wid/2)/deltz)*deltz)
   topo = dble(ceiling((slope*deltz*(RMAX-(XLOC/deltz))+clearance)/deltz))*deltz !+6

   call findtop(XLOC, topo, 24, topchannel)
   top=topchannel
   bottom=topchannel-dep

  end subroutine

subroutine edgesdose(wid, lamb, dep, XLOC,YLOC,ZLOC, slope,truetop,inchannel)
       implicit none
       double precision, intent(IN):: wid, dep, lamb, XLOC,ZLOC, YLOC, slope
       double precision, intent(OUT):: truetop
       logical, intent(out):: inchannel
       double precision:: topchannel, bottochannel, deltz, centerline, center, clearance
       double precision:: mid, topo
       logical:: foundtop
       integer:: I2
        deltz=dble(DX(3))
        mid=dble(ZMAX)
        !write(*,*) ZMAX, mid
        center = mid/2.0*deltz

        clearance = 50.
        if (simlabel == 'test')then
            clearance=2*deltz
        end if
        !write(*,*) clearance, center
        if (lamb .lt. 1) then
                centerline = center
        else
          centerline = lamb*amprat*sind((360*XLOC)/lamb)+center
        end if

        !write(*,*) centerline

        inchannel=.FALSE.
        edge1=dble(ceiling((centerline-wid/2)/deltz)*deltz)
        edge2=dble(ceiling((centerline+wid/2)/deltz)*deltz)
        topo = dble(ceiling((slope*deltz*(RMAX-(XLOC/deltz))+clearance)/deltz))*deltz !+6

        call findtop(XLOC, topo, zloc, topchannel)
        truetop=topchannel
        call funIJK_dble(XLOC,YLOC,ZLOC,I)
        if (EP_G1(I,1) .ge. dble(0.001)) then
        if (ZLOC .ge. edge1-6*DX(1) .and. ZLOC .le. edge2+3*DX(1) ) then
                topo=topchannel-dep
                call findtop(XLOC, topo, ZLOC, bottochannel)
                truetop=bottochannel
                !write(*,*) bottochannel, bottochannel+dep
                if (YLOC .le. bottochannel+dep) then

                 if ( YLOC .ge. bottochannel) then
                      inchannel=.TRUE.
                     ! write(*,*) "inside", XLOC, YLOC, ZLOC, top
                 end if
                end if
        end if
       end if



end subroutine

subroutine edgesdose_debug(wid, lamb, dep, XLOC,YLOC,ZLOC, slope,truetop,inchannel)
       implicit none
       double precision, intent(IN):: wid, dep, lamb, XLOC,ZLOC, YLOC, slope
       double precision, intent(OUT):: truetop
       logical, intent(out):: inchannel
       double precision:: topchannel, bottochannel, deltz, centerline, center,clearance
       double precision:: mid, topo
       logical:: foundtop
       integer:: I2
        deltz=dble(DX(3))
        mid=dble(ZMAX)
        !write(*,*) ZMAX, mid
        center = mid/2.0*deltz

        clearance = 50.
        if (simlabel == 'test')then
            clearance=2*deltz
        end if
        !write(*,*) clearance, center
        if (lamb .eq. 0) then
                centerline = center
        else
          centerline = lamb*amprat*sind((360*XLOC)/lamb)+center
        end if

        !write(*,*) centerline

        inchannel=.FALSE.
        edge1=dble(ceiling((centerline-wid/2)/deltz)*deltz)
        edge2=dble(ceiling((centerline+wid/2)/deltz)*deltz)
        topo =dble(ceiling((slope*deltz*(RMAX-(XLOC/deltz))+clearance)/deltz))*deltz !+6

        call findtop_debug(XLOC, topo, ZLOC, topchannel)
        truetop=topchannel
        call funIJK_dble(XLOC,YLOC,ZLOC,I)
        if (EP_G1(I,1) .ge. dble(0.001)) then
        if (ZLOC .ge. edge1-6*DX(1) .and. ZLOC .le. edge2+3*DX(1) ) then
                topo=topchannel-dep
                call findtop_debug(XLOC, topo, ZLOC, bottochannel)
                truetop=bottochannel
                !write(*,*) bottochannel, bottochannel+dep
                if (YLOC .le. bottochannel+dep) then

                 if ( YLOC .ge. bottochannel) then
                      inchannel=.TRUE.
                     ! write(*,*) "inside", XLOC, YLOC, ZLOC, top
                 end if
                end if
        end if
       end if

        call funIJK_dble(XLOC,YLOC,ZLOC,I)
        !if (EP_G1(I,1) .lt. dble(0.001)) inchannel=.FALSE.


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

subroutine FUNIJK_dble(xl,yl,zl,IJK)
     implicit none
     double precision, intent(IN):: xl, yl, zl
     integer, intent(OUT):: IJK
     ! FUNIJK_GL (LI, LJ, LK) = 1 + (LJ - jmin3) +
     ! (LI-imin3)*(jmax3-jmin3+1) &
     ! + (LK-kmin3)*(jmax3-jmin3+1)*(imax3-imin3+1)

     IJK = 1 + ( int(yl/DX(1))-1) +( int(xl/DX(1))-1)*(YMAX-1+1) +  ( int((zl)/DX(1))-1)*(YMAX-1+1)*(RMAX-1+1)
end subroutine


subroutine loctoind(loc,ind)
     double precision, intent(IN):: loc
     integer, intent(out):: ind

     ind= int( floor(loc)/3)
end subroutine

subroutine findtop(XLOC, topo, ZLOC, truetop)
        implicit none
        double precision, intent(IN):: XLOC, topo, ZLOC
        double precision, intent(OUT):: truetop
        integer:: n
        logical:: foundtop
        double precision:: YLOC
        YLOC=topo




               foundtop=.TRUE.
               n=1
                do while (n .lt. 30 .and. foundtop)

                truetop=YLOC+(n-15)*DX(1)
                if (truetop .gt. DX(1)) then
                        call FUNIJK_dble(xloc,  truetop, zloc, I)
                if (EP_G1(I,1) .ge. dble(0.01)) then
                !        write(*,*) "FAILED", XLOC/DX(1), topy/DX(1), "truetop",
                        foundtop=.FALSE.
                end if
                end if
                n=n+1
                end do


end subroutine

subroutine findtop_debug(XLOC, topo, ZLOC, truetop)
        implicit none
        double precision, intent(IN):: XLOC, topo, ZLOC
        double precision, intent(OUT):: truetop
        integer:: n
        logical:: foundtop
        double precision:: YLOC, ex
        YLOC=topo
        write(*,*) "starting find topo"
        write(*,*) xloc, yloc, zloc
        call FUNIJK_dble(xloc, yloc, zloc, I)
        write(*,*) I
        !truetop= YLOC
        truetop=YLOC
        !if (EP_G1(I,1) .le. dble(0.01)) then
                write(*,*) "starting while looP"

               foundtop=.TRUE.
               n=1
                do n=1,30
                ex=YLOC+(n-15)*DX(1)
                call FUNIJK_dble(xloc,  ex, zloc, I)
                write(*,*) n, ex, EP_G1(I,1)

                end do

                n=1
                do while (n .lt. 30 .and. foundtop)

                truetop=YLOC+(n-15)*DX(1)
                if (truetop .gt. DX(1)) then
                        call FUNIJK_dble(xloc,  truetop, zloc, I)
                        write(*,*) n, truetop, EP_G1(I,1)
                if (EP_G1(I,1) .ge. dble(0.01)) then
                        write(*,*) XLOC, truetop, "truetop"
                        foundtop=.FALSE.
                end if
                end if
                n=n+1
                end do
                write(*,*) "finishing do loop"
       ! end if


        write(*,*) "found truetop", truetop
end subroutine

subroutine checktop(XLOC,YLOC,ZLOC, top)
        double precision, intent(in):: XLOC, YLOC, ZLOC
        logical, intent(out):: top
        integer:: id, iu

        call FUNIJK_dble(xloc,  yloc, zloc, I)
        call FUNIJK_dble(xloc,  yloc+DX(1), zloc, iu)
        call FUNIJK_dble(xloc,  yloc-DX(1), zloc, id)
        top=.FALSE.
                if (EP_G1(I,1) .gt. dble (0.1)) then
                       if (EP_G1(iu,1) .gt. dble(0.1)) then
                                if (EP_G1(Id,1) .le. dble(0.1)) then

                                    top=.TRUE.
                                end if
                        end if
                end if

end subroutine
end module maketopo
