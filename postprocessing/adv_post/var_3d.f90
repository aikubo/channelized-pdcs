module var_3d
use parampost 
use constants 
!use formatmod
        contains 
        
        subroutine make3dvar
        implicit none
        print*, 'writing ep-p' 
        DO t=1,timesteps
                       DO I=1,RMAX*ZMAX*YMAX
                          !------------------ Volume Fraction of Gas or
                          !Particles
                          !------------------!
                          if (T_G1(I,t)==0.0 .OR. EP_G1(I,t) >0.9999999) THEN ! Try to make sure not to calculate infinity densities
                                                         
                          current_density = 0.0
                          else
                          current_density =rho_p*(1-EP_G1(I,t))+(EP_G1(I,t))*(P_const/(R_vapor*T_G1(I,t)))
                          end if

                          EP_P(I,1,t) = -LOG10(1-EP_G1(I,t)+1e-14)
                          EP_P(I,2,t) = XXX(I,1)
                          EP_P(I,3,t) = YYY(I,1)
                          EP_P(I,4,t) = ZZZ(I,1)
                          !------------------------ Temperature of Gas
                          !-----------------------------!
        !                  T_G(I,1,t) = T_G1(I,t)
        !                  T_G(I,2,t) = XXX(I,1)
        !                  T_G(I,3,t) = YYY(I,1)
        !                  T_G(I,4,t) = ZZZ(I,1)
                          !------------------------ Velocity
                          !of Gas
                          !--------------------------------!
        !                  U_G(I,1,t) = U_G1(I,t)
        !                  U_G(I,2,t) = V_G1(I,t)
        !                  U_G(I,3,t) = W_G1(I,t)
        !                  U_G(I,4,t) = XXX(I,1)
        !                  U_G(I,5,t) = YYY(I,1)
        !                  U_G(I,6,t) = ZZZ(I,1)

                        END DO
        END DO
        print*, 'done writing ep-p'
        end subroutine make3dvar 


 
        subroutine makedxfiles
        implicit none
        ! writes outs opendx files 
        ! in format file(1:I,1:4)=data, XX, YY, ZZ 
       
                print *, "Start writing 3D variables"
                DO t=1,timesteps
                        fid_EP_P  = 1100+t
          !              fid_U     = 1200+t
         !               fid_temp  = 1250+t
                        DO I=1,length1
           !              WRITE(fid_temp,4F22.12) T_G(I,1:4,t) 
           !              WRITE(fid_U,300) U_G(I,1:6,t)                 
                         WRITE(fid_EP_P,400) EP_P(I,1:4,t)
                        END DO
                END DO 
        400 FORMAT(4F22.12)
        end subroutine makedxfiles 
end module var_3d

