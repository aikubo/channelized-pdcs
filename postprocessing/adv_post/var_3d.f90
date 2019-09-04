module var_3d
use parampost 
use constants 
!use formatmod

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

!----------------------------------------------------------------!
        subroutine makeEP(fid_EPP, VOL, ifwrite)
        use formatmod
        use parampost
        implicit none
        logical, intent(IN):: ifwrite
        INTEGER, INTENT(IN):: fid_EPP
        DOUBLE PRECISION, DIMENSION(:,:,:), INTENT(OUT)::VOL
 
        print*, 'writing ep-p' 
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
                        
                          if (ifwrite .EQ. .TRUE.) THEN
                          WRITE(fid_EP_P, format4var) VOL(I,1:4,t)
                          end if                           

                        end do 
        end do 
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

