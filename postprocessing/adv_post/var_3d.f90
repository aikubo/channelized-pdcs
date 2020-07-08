module var_3d
use parampost 
use constants 
use makeascii
use formatmod
use filehead
use maketopo

        contains 


        subroutine  logvolfrc(EP_G, EPP)
        double precision, dimension(:,:), intent(IN):: EP_G
        double precision, dimension(:,:), intent(INOUT):: EPP
 

        do t=1,timesteps 
           do I=1,length1
                EPP(I,t)=  -LOG10(1-EP_G1(I,t)+1e-14)
                        !if (EP_G1(I,t) .lt. 0.01) then 
                        !        EPP(I,t)=14.0
                        !end if 
           end do 
        end do 

        end subroutine


        subroutine dynamicpressure(EP_G, U_S1, W_S1, V_S1, DPU)
                double precision, dimension(:,:), intent(IN):: EP_G, U_S1, W_S1, V_S1
                double precision, dimension(:,:), intent(OUT):: DPU
                double precision:: vel
                print*, "making dpu"

                   do t=1,timesteps
                        do I=1,length1
                                vel = sqrt(   U_S1(I,t)**2 + V_S1(I,t)**2 + W_S1(I,t)**2)
                                DPU(I,t)=(1-EP_G1(I,t))*1950*(vel**2)*(0.5) 
                        end do
                   end do
        

        end subroutine

        subroutine find_min_diff(to_find, a, idx)
                implicit none 
                double precision, intent(IN):: to_find 
                double precision, dimension(:), intent(IN):: a
                integer, intent(out):: idx
                double precision:: diff, min_diff
                min_diff = 1.0
                idx = 0

                do I = 1, size(a)
                        diff = abs(a(I)-to_find)
                        if ( diff < min_diff) then
                                idx = I
                                min_diff = diff
                        end if
                end do
                        
        end subroutine 

        subroutine dpupeak
        use maketopo


        double precision:: maxdpu, maxdpuin, maxdpuout
        logical, dimension(length1):: maskshapein, maskshapeout
        LOGICAL, dimension(length1):: locin, locout
        routine="var_3d/dpupeak"
        description="Calculate peak dynamic pressure inside and outside channel"
        datatype=" t, peak pressure, X, Z, peak inside, X,Z, peak outside of channel"
        filename='dpu_peak.txt'
        call headerf(4020, filename, simlabel, routine, DESCRIPTION, datatype)

        print*, "calculating peak dpu"
        
        do t=1,timesteps
                maxdpuin=0
                maxdpuout=0
                do I=1,length1
                call edges(width, lambda, depth, XXX(I,1), edge1, edge2,bottom, top)

                if ( YYY(I,1) .lt. top .and. EPP(I,t) .gt. 1.0 .and. EPP(I,t) .lt. 8.0 ) then
                        if (DPU(I,t) .gt. maxdpuin ) then 
                        maxdpuin= DPU(I,t)
                        end if 
                elseif ( YYY(I,1) .gt. top .and. EPP(I,t) .gt. 1.0 .and. EPP(I,t) .lt. 8.0) then
                        if (DPU(I,t) .gt. maxdpuout ) then 
                                maxdpuout= DPU(I,t)
                        end if
                end if  
                end do 
                call find_min_diff(maxdpuin, DPU(:,t), rc)
                call find_min_diff(maxdpuout, DPU(:,t), yc)
                !write(*, *) t, XXX(rc,1), YYY(rc,1), maxdpuin, XXX(yc,1), YYY(yc,1), maxdpuout
                write(4020, format8col) t, max(maxdpuin, maxdpuout), XXX(rc,1), ZZZ(rc,1), maxdpuin, XXX(yc,1), ZZZ(yc,1), maxdpuout
        end do 

        end subroutine 

!----------------------------------------------------------------!
        subroutine makeEP(fid_EPP, VOL, ifwrite, tfind)
        use formatmod
        use parampost
        implicit none
        INTEGER, INTENT(IN):: fid_EPP, tfind, ifwrite
        DOUBLE PRECISION, DIMENSION(:,:,:), INTENT(OUT)::VOL
        CHARACTER(LEN=10) :: str_d
        character(LEN=10) :: x2
        str_d = '(I2.2)' 

        print*, 'writing ep-p' 

        if (ifwrite .eq. 1) then
        call openascii(6200, 'EP_P_t')
        DO t=tstart,tstop
                fid_EP_P  = fid_EPP+t
                       DO I=1,RMAX*ZMAX*YMAX
                          !------------------ Volume Fraction of Gas or
                          !Particles
                          !------------------!
                          if (EP_G1(I,t)<0.000001) THEN ! Try to make sure not to calculate infinity densities
                           EP_G1(I,t)=0.0
                                                        
                          end if

                          VOL(I,1,t) = -LOG10(1-EP_G1(I,t)+1e-14)
                          VOL(I,2,t) = XXX(I,1)
                          VOL(I,3,t) = YYY(I,1)
                          VOL(I,4,t) = ZZZ(I,1)
                        
                          WRITE(fid_EP_P, format4var) VOL(I,1:4,t)

                        end do 
        end do 
        else !if ( ifwrite .eq. 2 ) then 
        t= tfind
        write(x2,str_d) t 
        open(6100, file='EP_P_t'//trim(x2)//'.txt')
        open(6101, file='U_G_t'//trim(x2)//'.txt')

        DO I=1,RMAX*ZMAX*YMAX
           !------------------ Volume Fraction of Gas or
           !Particles
           !------------------!
           if (EP_G1(I,t)<0.01) THEN ! Try to make sure not to calculate infinity densities
            EP_G1(I,t)=0.0
                                                
           end if

           VOL(I,1,t) = -LOG10(1-EP_G1(I,t)+1e-14)
           VOL(I,2,t) = XXX(I,1)
           VOL(I,3,t) = YYY(I,1)
           VOL(I,4,t) = ZZZ(I,1)
         
           WRITE(6100, format4var) VOL(I,1:4,t)

           write(6101, format4var) U_G1(I,t), XXX(I,1), YYY(I,1), ZZZ(I,1)

         end do 

end if 
        print*, "done writing ep-p"
        end subroutine

!----------------------------------------------------------------!

        subroutine makedxtxt(filen,fid_tp, TEMP, time)
        use parampost 
        use formatmod 
        use constants 

        implicit none
        INTEGER, INTENT(IN):: fid_tp, time
        DOUBLE PRECISION, DIMENSION(:,:), INTENT(IN)::TEMP
        CHARACTER(LEN=10) :: str_c
        character(LEN=10) :: x1
        character(LEN=*), intent(in) :: filen
        character(len=6):: eppfile
        eppfile="EP_P_t"
        print*, 'writing for open dx'
        t=time
        str_c = '(I2.2)'


                write(x1,str_c) t

                open(fid_tp+time, file=filen//trim(x1)//'.txt')



               DO I=1,RMAX*ZMAX*YMAX
                          !------------------------ Temperature of Gas
                          !-----------------------------!

                        if ( TEMP(I,t) .eq. EPP(I,t) ) then 
                            if (TEMP(I,time) .le. dble(0.10)) then
                                WRITE(fid_tp+time,format4var) dble(14), XXX(I,1),YYY(I,1), ZZZ(I,1)
    
                            else 
                                WRITE(fid_tp+time,format4var) TEMP(I,t), XXX(I,1),YYY(I,1), ZZZ(I,1)

                            end if 
                        else  
                         WRITE(fid_tp+time,format4var) TEMP(I,t), XXX(I,1),YYY(I,1), ZZZ(I,1)
                       end if
                END DO
        
        end subroutine
!----------------------------------------------------------------!
        subroutine makeUG(fid_UG, VEL, ifwrite)
        use formatmod 
        use parampost 
        use constants
        implicit none
        INTEGER, INTENT(IN):: fid_UG
        INTEGER, INTENT(IN):: ifwrite
        DOUBLE PRECISION, DIMENSION(:,:,:), INTENT(OUT)::VEL

        print*, 'writing ep-p'
        !DO t= tstart,tstop
              open(6101, file='U_G_t08.txt')
  
                DO I=1,RMAX*ZMAX*YMAX
                          !------------------------ Velocity
                          !of Gas
                          !--------------------------------!
                          VEL(I,1,t) = U_G1(I,t)
                          VEL(I,2,t) = V_G1(I,t)
                          VEL(I,3,t) = W_G1(I,t)
                          VEL(I,4,t) = XXX(I,1)
                          VEL(I,5,t) = YYY(I,1)
                          VEL(I,6,t) = ZZZ(I,1)
      
                        if (ifwrite .eq. 1) then
                        WRITE(6101,format6var) VEL(I,1:6,8)
                        end if 
          END DO

        !END DO
        print*, 'done writing ep-p'

        end subroutine makeUG

!----------------------------------------------------------------!



end module var_3d

