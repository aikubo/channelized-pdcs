module find_richardson
        use parampost
        use constants
        use makeascii
        use formatmod 


        contains 
                subroutine gradrich(EP_P, T_G1, U_G, Ri, SHUY, printstatus)
                implicit none
                integer, intent(IN):: printstatus
                double precision, allocatable, intent(IN):: EP_P(:,:,:)
                double precision, allocatable, intent(INOUT)::U_G(:,:,:)
                double precision, allocatable, intent(IN):: T_G1(:,:) 
                double precision, allocatable, intent(INOUT):: Ri(:,:)
                double precision, allocatable, intent(INOUT):: SHUY(:,:)
                double precision:: Ri_grad 
                print*, "Begin richardson gradient calculation"
                open(1500, file='Richardson_t08.txt', FORMAT='FORMATTED')
                !call openascii(800, 'SHUY_t')
                
                DO t= 1,timesteps
!                
!                     DO I=1,length1
!                               Ri(I,1,t) = 1.000e3
!                               Ri(I,2,t) = XXX(I,1)
!                               Ri(I,3,t) = YYY(I,1)
!                               Ri(I,4,t) = ZZZ(I,1)
!                     END DO



                print*, "correct location of X an Z direction velocities"
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
                print*, "finished correction"


                print*, "calculate Ri"
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
                              
                !             print*, I

                      IF(T_G1(I_ym1,t)>272.0 .AND. EPP(I,t)<8.0 .AND. EPP(I,t)>0.0) THEN
                                               
                                                !------Y-Richardson-------!
                                                   ! Current density at each position
                                                int_pos1           = I_yp1
                                                int_min1           = I_ym1
                                                bottom             = 2*((abs(YYY(int_pos1,1)-YYY(I,1))))
                                                c_pos1             = rho_p*(10**-(EPP(int_pos1,t)))+(1-(10**-(EPP(int_pos1,t))))*(P_const/(R_vapor*T_G1(int_pos1,t)))
                                                c_min1             = rho_p*(10**-(EPP(int_min1,t)))+(1-(10**-(EPP(int_min1,t))))*(P_const/(R_vapor*T_G1(int_min1,t)))
                                               ! print*, EP_P(int_pos1,1,t),EP_P(int_pos1,3,t)
                                               ! print*, T_G1(int_pos1,t)
                                               ! print*, bottom, c_pos1, c_min1
                                                   ! Shear Velocity components, X & Z
                                                delta_V1           = (U_G(int_pos1,1,t)-U_G(int_min1,1,t))/bottom
                                                !delta_V3          = (U_G(int_pos1,3,t)-U_G(int_min1,3,t))/bottom
                                                !shear_v           = sqrt(delta_V1**2+delta_V3**2)
                                                shear_v            = delta_V1
                                                delta_rho          =(c_pos1-c_min1)/bottom
                                                Ri_grad            =((-gravity/rho_dry)*delta_rho)/(shear_v**2)
                                               ! print*, Ri_grad

                                                ! This is done for easier colorbar in
                                                ! Opendx,
                                                ! Therefore in the write out column 1 is
                                                ! the
                                                ! adjusted Ri and column 5 is the
                                                ! original
                                                !print*, "something off here"
                                                if (Ri_grad>5.0) THEN
                                                Ri(I,t) = 5.0
                                                !print *, "Ri", I, t, Ri
                                                elseif (Ri_grad<-5.0) THEN
                                                !print*, "entered elif"
                                                Ri(I,t) = -5.0
                                                !print*, "wrote ri"
                                               !print *, "Ri", I, t, Ri(I,1,t)
                                                else
                                                Ri(I,t) = Ri_grad
                                                end if

                                                Ri(I,t) = Ri_grad

                                                !print*, "shearv", shear_v 
                                                SHUY(I,t) = shear_v
                                               
                                              
                                                
                                                !------Y-Richardson-------!
                           END IF
                    END DO
                                                                             
                   END DO
                  END DO

                 ! fid_temp =1500 +t
                 ! fid_shuy =800 +t
                !   DO I=1,RMAX*ZMAX*YMAX
                !     WRITE(1500,format5var) 
                !  !   write(fid_shuy, format4var) SHUY(I, 1:4,t)
                !   END DO

        END DO

        if (printstatus .ne. 0) then
                DO I=1,RMAX*ZMAX*YMAX
                        WRITE(fid_temp,format4var) XXX(I,1), YYY(I,1), ZZZ(I,1), Ri(I,t)
                !   write(fid_shuy, format4var) SHUY(I, 1:4,t)
                END DO
        end if 
        
        !print*, "Ri calculation done" 

        if (printstatus .eq. 1) then

                print*, "write Ri"
                open(7777, file="Ri", form='unformatted')

                DO I=1,length1
                        write(7777) Ri(I,t) 
                end do 
        
        end if 

        print*, "finished Ri gradient subroutine"
                
end subroutine gradrich 
end module find_richardson


