module massdist
        subroutine massinchannel
        USE handletopo
        IMPLICIT NONE


        print*, 'mass in channel'
        OPEN(666, file='massinchannel.txt')
        print *, "Done writing 3D variables"
        DO t= 1,timesteps
        chmass = 0
        tmass = 0
        chmassd = 0

        DO I=1, length1
            call edges(width, lambda, XXX(I,1), edge1, egde2, bottom, top)
        
            IF (YYY(I,1)>bottom) THEN
            IF (EPP(I,t) <max_dilute) THEN
                IF (EPP(I,t) >0.000) THEN
                 tmass = tmass + ((EP_G1(I,t))*Volume_Unit*rho_p)

                IF (YYY(I,1)>bottom) THEN
                IF (YYY(I,1)<top) THEN
                 chmassd = chmassd + ((EP_G1(I,t))*Volume_Unit*rho_p)

                IF (ZZZ(I,1) >edge1) THEN
                 IF (ZZZ(I,1) <edge2) THEN
                 chmass = chmass + ((EP_G1(I,t))*Volume_Unit*rho_p)
        !         print*, "Mass in channel width", chmass

                IF (YYY(I,1)>bottom) THEN
                IF (YYY(I,1)<top) THEN
                 chmassd = chmassd + ((EP_G1(I,t))*Volume_Unit*rho_p)

        !         print*, "Mass in channel depth", chmassd
                END IF
                END IF
               END IF
              END IF
          END IF
         END DO

        WRITE(666, 403) chmass/tmass, 
        END DO
        !! done !!
        print*, 'mass in channel'

        !400 FORMAT(4F22.12)
        !403 FORMAT(2F22.12)

        END SUBROUTINE

end module 
