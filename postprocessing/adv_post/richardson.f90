module richardson
        use parampost
        use constants
        use makeascii

        contains 
                subroutine gradrich
                
                call openascii(1500, 'Richardson_t')
                call openascii(800, 'SHUY_t')
                
                DO t= 1,timesteps
                
                     DO I=1,RMAX*ZMAX*YMAX
                               Richardson(I,1,t) = 1.000e3
                               Richardson(I,2,t) = XXX(I,1)
                               Richardson(I,3,t) = YYY(I,1)
                               Richardson(I,4,t) = ZZZ(I,1)
                     END DO




                ! CORRECT THE LOCATION OF THE X AND Z DIRECTION
                ! VELOCITIES--------------------------!
                  DO rc =4,RMAX-4           !X
                   DO zc = 4,ZMAX-4         !Z
                    DO yc = YMAX-4,4,-1     !Y
                                ! FUNIJK_GL (LI, LJ, LK) = 1 + (LJ - jmin3) +
                                ! (LI-imin3)*(jmax3-jmin3+1) &
                                ! + (LK-kmin3)*(jmax3-jmin3+1)*(imax3-imin3+1)
                             I       = 1 + (yc-1) +(rc-1)*(YMAX-1+1) + (zc-1)*(YMAX-1+1)*(RMAX-1+1)

                             I_xm1   = 1 + (yc-1) +(rc-1-1)*(YMAX-1+1) + (zc-1)*(YMAX-1+1)*(RMAX-1+1)
                             I_zm1   = 1 + (yc-1) +(rc-1)*(YMAX-1+1) + (zc-1-1)*(YMAX-1+1)*(RMAX-1+1)

                             U_G(I,1,t) = U_G1(I_xm1,t)
                             U_G(I,2,t) = V_G1(I,t)
                             U_G(I,3,t) = W_G1(I,t)

                    END DO
                   END DO
                  END DO
                ! CORRECT THE LOCATION OF THE X AND Z DIRECTION
                ! VELOCITIES--------------------------!




                ! NOW THE VELOCITIES ARE CORRECT FOR THE CALCULATION OF GRADIENT
                ! RICHARDSON
                  DO rc =4,RMAX-4           !X
                   DO zc = 4,ZMAX-4         !Z
                    DO yc = YMAX-4,4,-1     !Y
                                ! FUNIJK_GL (LI, LJ, LK) = 1 + (LJ - jmin3) +
                                ! (LI-imin3)*(jmax3-jmin3+1) &
                                ! + (LK-kmin3)*(jmax3-jmin3+1)*(imax3-imin3+1)
                             I       = 1 + (yc-1) +(rc-1)*(YMAX-1+1) +  (zc-1)*(YMAX-1+1)*(RMAX-1+1)
                             I_yp1   = 1 + (yc+1-1) +(rc-1)*(YMAX-1+1) + (zc-1)*(YMAX-1+1)*(RMAX-1+1) !Cell above
                             I_ym1   = 1 + (yc-1-1) +(rc-1)*(YMAX-1+1) +(zc-1)*(YMAX-1+1)*(RMAX-1+1) !Cell above


                             IF(T_G(I_ym1,1,t)>272.0 .AND. EP_P(I,1,t)<8.0) THEN
                                                !------Y-Richardson-------!
                                                   ! Current density at each position
                                                int_pos1           = I_yp1
                                                int_min1           = I_ym1
                                                bottom             = 2*((abs(EP_P(int_pos1,3,t)-EP_P(I,3,t))))
                                                c_pos1             = rho_p*(10**-(EP_P(int_pos1,1,t)))+(1-(10**-(EP_P(int_pos1,1,t))))*(P_const/(R_vapor*T_G(int_pos1,1,t)))
                                                c_min1             = rho_p*(10**-(EP_P(int_min1,1,t)))+(1-(10**-(EP_P(int_min1,1,t))))*(P_const/(R_vapor*T_G(int_min1,1,t)))
                                                   ! Shear Velocity components, X & Z
                                                delta_V1           = (U_G(int_pos1,1,t)-U_G(int_min1,1,t))/bottom
                                                !delta_V3           =
                                                !(U_G(int_pos1,3,t)-U_G(int_min1,3,t))/bottom
                                                !shear_v            =
                                                !sqrt(delta_V1**2+delta_V3**2)
                                                shear_v            = delta_V1
                                                delta_rho          =(c_pos1-c_min1)/bottom
                                                Ri                 =((-gravity/rho_dry)*delta_rho)/(shear_v**2)


                                                ! This is done for easier colorbar in
                                                ! Opendx,
                                                ! Therefore in the write out column 1 is
                                                ! the
                                                ! adjusted Ri and column 5 is the
                                                ! original
                                                if (Ri>5) THEN
                                                Richardson(I,1,t) = 5.0
                                                !print *, "Ri", I, t, Ri
                                                elseif (Ri<-5) THEN
                                                Richardson(I,1,t) = -5.0
                                                !print *, "Ri", I, t, Ri
                                                else
                                                Richardson(I,1,t) = Ri
                                                end if

                                                Richardson(I,2,t) = XXX(I,1)
                                                Richardson(I,3,t) = YYY(I,1)
                                                Richardson(I,4,t) = ZZZ(I,1)
                                                Richardson(I,5,t) = Ri



                                                SHUY(I,1) = shear_v
                                                SHUT(I,2) = XXX(I,1)
                                                SHUY(I,3) = YYY(I,1)
                                                SHUY(I,4) = ZZZ(I,1)
                                                !------Y-Richardson-------!
                           END IF
                    END DO
                                                                             
                   END DO
                  END DO

                  fid_temp =1500 +t
                  fid_shuy =800 +t
                  DO I=1,RMAX*ZMAX*YMAX
                    WRITE(fid_temp,401) Richardson(I,1:5,t)
                    write(fid_shuy, 400) SHUY(I, 1:4)
                  END DO

        END DO

        400 FORMAT(4F22.12)
        401 FORMAT(4F22.12,1x,ES22.5)
end subroutine gradrich 
end module richardson


