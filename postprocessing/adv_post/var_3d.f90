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
           end do 
        end do 

        end subroutine


        subroutine dynamicpressure(EP_G, U_S1, DPU)
                double precision, dimension(:,:), intent(IN):: EP_G, U_S1
                double precision, dimension(:,:), intent(OUT):: DPU 

                   do t=1,timesteps
                        do I=1,length1
                                DPU(I,t)=(1-EP_G1(I,t))*1950*(U_S1(I,t)*U_S1(I,t))*(0.5) 
                        end do
                   end do
        

        end subroutine 

        subroutine dpupeak(width, lambda, depth, DPU)
        double precision, intent(IN):: width, lambda, depth
        double precision, dimension(:,:), intent(INOUT):: DPU
        double precision:: maxdpu, maxdpuin, maxdpuout
        logical, dimension(length1):: maskshapein, maskshapeout

        routine="var_3d/dpupeak"
        description="Calculate peak dynamic pressure inside and outside channel"
        datatype=" t "
        filename='dpu_peak.txt'
        call headerf(4020, filename, simlabel, routine, DESCRIPTION, datatype)
        
        do I= 1,length1
                call edges(width, lambda, depth, XXX(I,1), edge1, edge2, bottom, top)

                if ( YYY(I,1) .lt. top) then
                        maskshapein(I) = .TRUE.
                else 
                        maskshapein(I)= .FALSE.
                end if 

                if ( YYY(I,1) .gt. top) then
                        maskshapeout(I) = .TRUE.
                else 
                        maskshapeout(I)= .FALSE.
                end if 
        end do 

        print maskshapein


        do t=2,timesteps
                maxdpu = maxval(DPU(:,t))
                maxdpuin= maxval(DPU(:,t), MASK=maskshapein)
                maxdpuout= maxval(DPU(:,t), MASK=maskshapeout)

                print*, maxdpu
        
                write(4020, formatent) t, maxdpu, maxdpuin, maxdpuout
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
                          if (EP_G1(I,t)<0.01) THEN ! Try to make sure not to calculate infinity densities
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

        subroutine makeTG(fid_tp, TEMP, ifwrite)
        use parampost 
        use formatmod 
        use constants 

        implicit none
        INTEGER, INTENT(IN):: fid_tp
        LOGICAL, INTENT(IN):: ifwrite
        DOUBLE PRECISION, DIMENSION(:,:,:), INTENT(OUT)::TEMP

        print*, 'writing ep-p'
        DO t=tstart,tstop
                fid_temp=fid_tp+t
                DO I=1,RMAX*ZMAX*YMAX
                          !------------------------ Temperature of Gas
                          !-----------------------------!
                          TEMP(I,1,t) = T_G1(I,t)
                          TEMP(I,2,t) = XXX(I,1)
                          TEMP(I,3,t) = YYY(I,1)
                          TEMP(I,4,t) = ZZZ(I,1)
                        
                        !if (ifwrite .EQ. .TRUE.) then
                        !  print*, "writing"
                          WRITE(fid_temp,format4var) TEMP(I,1:4,t)
                        !end if
                END DO
        END DO 

        end subroutine
!----------------------------------------------------------------!
        subroutine makeUG(fid_UG, VEL, ifwrite)
        use formatmod 
        use parampost 
        use constants
        implicit none
        INTEGER, INTENT(IN):: fid_UG
        LOGICAL, INTENT(IN):: ifwrite
        DOUBLE PRECISION, DIMENSION(:,:,:), INTENT(OUT)::VEL

        print*, 'writing ep-p'
        DO t= tstart,tstop
                fid_U=fid_UG +t 
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
      
                        if (ifwrite) then
                        WRITE(fid_U,format6var) VEL(I,1:6,t)
                        end if 
          END DO

        END DO
        print*, 'done writing ep-p'

        end subroutine makeUG

!----------------------------------------------------------------!
end module var_3d

