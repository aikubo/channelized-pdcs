module massin

        subroutine massinchannel

        IMPLICIT NONE


        print*, 'mass in channel'
        OPEN(666, file='massinchannel.txt')
        print *, "Done writing 3D variables"
        DO t= 1,timesteps
        chmass = 0
        tmass = 0
        chmassd = 0


     !   center = (ZMAX-2)/2 + 25
     !   amp = .2*(ZMAX-2)
     !   lambda = RMAX-
     !   (400-J)+20-depth
     !       top = tand(M)*2*(400-J)+20

     !       ds = (J*360/lambda)*(0.0174533)
     !       edge1 = amp*sin(ds) + center + width/2
     !       edge2 = amp*sin(ds) + center - width/2


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

        WRITE(666, 403) chmass/tmass, 
        END DO
        !! done !!
        print*, 'mass in channel'

        !400 FORMAT(4F22.12)
        !403 FORMAT(2F22.12)

        END SUBROUTINE

end module 
