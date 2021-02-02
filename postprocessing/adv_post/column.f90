module column
use formatmod
use parampost
use constants
use openbinary
use maketopo
use makeascii
use var_3d
use filehead
use massdist
contains
!        subroutine setup_col()
!        end subroutine setup_col

        subroutine slice(width, depth, lambda, XC, ZC, locstring, numunit)
        use formatmod

        implicit none
          !call allocate_arrays
          CHARACTER(len=*), intent(IN):: locstring
          integer, intent(IN):: numunit
          DOUBLE PRECISION, INTENT(IN):: width, lambda, depth, XC, ZC
          DOUBLE PRECISION:: VOLFR, DYNAM
          DOUBLE PRECISION:: clearance, slope, dx
          DOUBLE PRECISION :: hill
          double precision:: XLOC, ZLOC
          character(3)::Xstring, zstring
          CHARACTER(LEN=10) :: str_b

          str_b= '(I3.1)'
          write(xstring,str_b) InT(XC)
          write(zstring,str_b) int(ZC)


          routine="column.mod/slice"
          description='Veritcal column at x'//trim(xstring)//'_z'//trim(zstring)
          datatype=" t  YYY  EPP   U_G   DPU   T_G   Ri   WG"
          print*, xstring, zstring
          filename='slice_'//locstring//'.txt'
          print*, "open slice file", xstring, zstring
          call headerf(numunit, filename, simlabel, routine, DESCRIPTION, datatype)

          print*, "start checking column"
           DO t=1,timesteps
            print*,t
            DO I= 1, length1
              !DYNAM= (1-EP_G1(I,t))*1950*(U_S1(I,t)*U_S1(I,t))
              ! VOLFR = -LOG10(1-EP_G1(I,t)+1e-14)
                !PRINT*, VOLFR
                ! IF ( YYY(I,1) .GT. hill .AND. YYY(I,1) .LT. hill+102 ) THEN
                   IF( ZZZ(I,1) .EQ. ZC) THEN
                !        print*, ZZZ(I,1)
                    IF( XXX(I,1) .EQ. XC) THEN
                       ! print*, XXX(I,1)
                      IF(EPP(I,t) .GT. 0.00) THEN
                      !print*, YYY(I,1)-hill, Ri_all(I,1,t)

                        WRITE(numunit,format8col) t, YYY(I,1), EPP(I,t), U_G1(I,t), DPU(I,t), T_G1(I,t), Ri(I,t), W_G1(I,t)
                      end if
                 !     END IF
                   END IF
                  END IF
                end do
           END DO
         end subroutine slice

        SUBROUTINE SLICES2
        use maketopo
        implicit none
        double precision:: ZLOC, XLOC
        print*, "slices"
        XLOC=300
        call edges(width, lambda, depth, XLOC, slope, edge1, edge2, bottom, top)
        ZLOC=floor((edge2-width/2)/3)*3  ! mid line
        print*, XLOC, ZLOC
        CALL SLICE(width, depth, lambda, XLOC, ZLOC, 'middle',  10001)
        print*, XLOC, ZLOC
        XLOC=floor((lambda)*(0.5)/3)*3
        call edges(width, lambda, depth, XLOC, slope, edge1, edge2, bottom, top)
        ZLOC=floor((edge2+6)/3)*3
        print*, XLOC, ZLOC

        call slice(width, depth, lambda, XLOC, ZLOC, 'halfl', 10002)

        XLOC=floor((lambda)/3)*3
        call edges(width, lambda, depth, XLOC, slope, edge1, edge2, bottom, top)
        ZLOC=floor((edge2+6)/3)*3
        print*, XLOC, ZLOC
        call slice(width, depth, lambda, XLOC, ZLOC, 'onel', 10003)


        XLOC=floor((lambda)*(0.75)/3)*3
        call edges(width, lambda, depth, XLOC, slope, edge1, edge2, bottom, top)
        ZLOC=floor((edge2+100)/3)*3
        print*, XLOC, ZLOC

        call slice(width, depth, lambda, XLOC, ZLOC, '3quarter_100m', 10003)





        end subroutine

        SUBROUTINE SLICES_STRAIGHT
        use maketopo
        implicit none
        double precision:: ZLOC, XLOC
        print*, "slices"
        XLOC=501
        call edges(width, lambda, depth, XLOC, slope, edge1, edge2, bottom, top)
        ZLOC=450  ! mid line
        print*, XLOC, ZLOC
        CALL SLICE(width, depth, lambda, XLOC, ZLOC, 'head',  10301)
        print*, XLOC, ZLOC
        XLOC=1002
        ZLOC=450
        call edges(width, lambda, depth, XLOC, slope, edge1, edge2, bottom, top)
        print*, XLOC, ZLOC

        call slice(width, depth, lambda, XLOC, ZLOC, 'body', 10302)

        XLOC=252
        call edges(width, lambda, depth, XLOC, slope, edge1, edge2, bottom, top)
        ZLOC=450
        print*, XLOC, ZLOC
        call slice(width, depth, lambda, XLOC, ZLOC, 'tail', 10303)


        end subroutine


SUBROUTINE countspills
implicit none
double precision:: seg_l, XLOC, topo, centerline, rho_c, mass
integer:: spillcount, segments,n, rstart, rstop
logical, allocatable:: spillhere(:,:)
logical:: inchannel, plain
integer:: numunit 
double precision:: bottom, top 
numunit=1099
routine="column.mod/countspills"
description='Number of spills over time'
datatype=" t  spill count "
filename='spillcount.txt'
call headerf(numunit, filename, simlabel, routine, DESCRIPTION, datatype)
seg_l=lambda/4
segments= int(floor(1200/(seg_l)))
write(*,*) seg_l, segments

allocate(spillhere(2,segments))
!spill here : logical of (2 by segments)
!records if there has been a spill in this segment on each side
! 1 = edge1 and 2 = edge 2

do t=2,timesteps
  do n=1,segments
    rstart=int((seg_l/3)*(n-1))
    if (n .eq. 1) rstart = 4
    rstop=int((seg_l/3)*n)
    do rc=rstart, rstop
      XLOC=dble(rc*3)
      
        call where_edges(width, lambda, depth, xloc,dble(240), dble(24), slope, top, inchannel, plain, edge1, edge2)
        centerline=edge1+width/2 
        do yc=int((top-9)/3), int((top+24)/3)
        do zc= int((edge1-24)/3), int(centerline/3)
          call funijk(rc,yc,zc, I)
          call where_edges(width, lambda, depth, XXX(I,1), YYY(I,1), ZZZ(I,1), slope, top,inchannel, plain, edge1, edge2)
          if ( plain ) then
            call density(I, t, rho_c, mass)
            if (rho_c .gt. rho_dry) then
              if ( .NOT. spillhere(1,n)) then
                spillhere(1,n)=.TRUE.
                spillcount=spillcount+1
              end if
            end if
          end if
        end do
        do zc= int(centerline/3), int((edge2+24)/3)
          call funijk(rc,yc,zc, I)
            call where_edges(width, lambda, depth, XXX(I,1), YYY(I,1), ZZZ(I,1),slope, top,inchannel, plain, edge1, edge2)
           if (plain) then 
            call density(I, t, rho_c, mass)
            if (rho_c .gt. rho_dry) then
              if ( .NOT. spillhere(2,n)) then
                spillhere(2,n)=.TRUE.
                spillcount=spillcount+1
              end if
            end if
          end if
        end do

      end do
    end do
   end do 
    write(*,*) t, spillcount
        write(*,*) spillhere
  end do

end subroutine


end module

!program sliceit
!use parampost

!use constants
!use alloc_arrays
!use openbin
!use openascii
!use column
!IMPLICIT NONE


!call allocate_arrays

!call openbin(100, 'EP_G', EP_G1)
!call openbin(200, 'U_G', U_G1)
!call openbin(300, 'T_G', T_G1)

!t=4
!str_c = '(I2.2)'
!write(x1,str_c) t
!OPEN(1500,FILE='Richardson_t'//trim(x1)//'.txt')

!DO I=1,length1
!        READ(1500) Ri(I,:)
!end do

!call handletopo(topo, XXX, YYY, ZZZ)

!middle = 2500
!OPEN(middle, file='slice_middle04.txt')

!call slice(middle, 200, 150)


!405 FORMAT(5F22.12)
!400 FORMAT(4F22.12)
!end program
