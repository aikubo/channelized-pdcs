module massmod
        use parampost 
        use constants

        contains 
                subroutine massin
                
                OPEN(666, file='massinchannel.txt')
                print *, "Done writing 3D variables"
                DO t= 1,timesteps
                chmass = 0
                tmass = 0
                chmassd = 0

                DO I = 1,length1
                    J = EP_P(I,2,t)/2
                    bottom = tand(M)*2*(400-J)+20-depth
                    top = tand(M)*2*(400-J)+20

                    IF (EP_P(I,3,t)>bottom) THEN
                    IF (EP_P(I,1,t)<max_dilute) THEN
                        IF (EP_P(I,1,t) >0.000) THEN
                         tmass = tmass + ((EP_P(I,1,t))*Volume_Unit*rho_p)

                        IF (EP_P(I,4,t) >edge1) THEN
                         IF (EP_P(I,4,t) <edge2) THEN
                         chmass = chmass + ((EP_P(I,1,t))*Volume_Unit*rho_p)
                !         print*, "Mass in channel width", chmass

                        IF (EP_P(I,3,t)>bottom) THEN
                        IF (EP_P(I,3,t)<top) THEN
                         chmassd = chmassd + ((EP_P(I,1,t))*Volume_Unit*rho_p)

                !         print*, "Mass in channel depth", chmassd
                        END IF
                        END IF
                       END IF
                      END IF
                    END IF
                   END IF
                  END IF
                 END DO

                 WRITE(666, 403) chmass/tmass, chmassd/tmass
                END DO

        403 FORMAT(2F22.12)
        end subroutine massin 
end module mass
