module grangass
        use parampost
        use constants
        use makeascii
        use formatmod 
        use openbinary
        use var_3d 
        use maketopo 
        use find_richardson
        contains 
                subroutine calc_tau 
                double precision:: dtheta
                call openbin(9901, 'MU_G', MU_G1)
                call openbin(9902, 'MU_S1',MU_S)
                call openbin(9904, 'THETA_M1', THETA_S) 
                open(89098,file='TAU_RATIO_t08.txt')

                do t=1,timesteps
                ! NOW THE VELOCITIES ARE CORRECT FOR THE CALCULATION OF GRADIENT
                ! RICHARDSON
                  DO rc = 2,RMAX-2           !X
                   DO zc = 2,ZMAX-2         !Z
                    DO yc = YMAX-1,1,-1     !Y
                                ! FUNIJK_GL (LI, LJ, LK) = 1 + (LJ - jmin3) +
                                ! (LI-imin3)*(jmax3-jmin3+1) &
                                ! + (LK-kmin3)*(jmax3-jmin3+1)*(imax3-imin3+1)
                             I       = 1 + (yc-1) +(rc-1)*(YMAX-1+1) +  (zc-1)*(YMAX-1+1)*(RMAX-1+1)
                             I_yp1   = 1 + (yc+1-1) +(rc-1)*(YMAX-1+1) + (zc-1)*(YMAX-1+1)*(RMAX-1+1) !Cell above
                             I_ym1   = 1 + (yc-1-1) +(rc-1)*(YMAX-1+1) +(zc-1)*(YMAX-1+1)*(RMAX-1+1) !Cell above
                             dtheta=(THETA_S(I_yp1,t)-THETA_S(I_ym1,t))/DY(1) 
                             
                             TAU_G(I,t)=(1/MU_G1(I,t))*SHUY(I,t)
                             TAU_S(I,t)=(1/MU_S(I,t))*dtheta   

                             TAU_RATIO(I,t)=TAU_S(I,t)/TAU_G(I,t)
                      END DO 
                    END DO 
                  END DO 

                

                end do 


                do i=1,length1
                        write(89098, format4var) TAU_RATIO(I,8), XXX(I,1), YYY(I,1), ZZZ(I,1)
                end do 

               end subroutine calc_tau 
end module grangass


