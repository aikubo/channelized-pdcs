module massdist
        USE maketopo
        USE CONSTANTS 
        USE PARARMPOST 
        USE FORMATMOD
        
        contains

        subroutine massinchannel(WIDTH, LAMBDA, SCALEHEIGHT)

        IMPLICIT NONE
        double precision:: elumass, medmass, densemass, inchannel, SCALEMASS, scalemass1, scalemass2
        
        print*, 'mass in channel'
        OPEN(666, file='massinchannel.txt')
        write(666,*) "Total Mass - Elutriated - Medium - Dense - Inchannel- Within Width - scaleheight-scaleheight1 - scaleheight2"
        print *, "Done writing 3D variables"
        DO t= 1,timesteps
        chmass = 0
        tmass = 0
        chmassd = 0
        elumass=0
        inchannel=0
        densemass =0 
        inchannel=0
        scalemass=0
        scalemass2=0
        scalemass1=0

        DO I=1, length1
            call edges(width, lambda, XXX(I,1), edge1, egde2, bottom, top)

            IF (YYY(I,1)>bottom) THEN
                IF (EPP(I,t) <max_dilute) THEN
                IF (EPP(I,t) >0.000) THEN
                ! total mass 
                 tmass = tmass + (1-EP_G1(I,t))*Volume_Unit*rho_p

                ! MASS ABOVE CERTAIN SCALE HEIGHTS
                 if ( YYY(I,1) .LT. SCALEHEIGHT+bottom ) then
                         SCALEMASS= SCALEMASS + (1-EP_G1(I,t))*Volume_Unit*rho_p
                 end if

                 if ( YYY(I,1) .GT. SCALEHEIGHT+bottom ) then
                        SCALEMASS1= SCALEMASS1 + (1-EP_G1(I,t))*Volume_Unit*rho_p
                end if

                if ( YYY(I,1) .GT. 2.*SCALEHEIGHT+bottom ) then
                        SCALEMASS2= SCALEMASS2 + (1-EP_G1(I,t))*Volume_Unit*rho_p
                end if

                ! elutriated masss
                 IF (EPP(I,t) > 5.0) THEN
                        elumass= elumass+(1-EP_G1(I,t))*Volume_Unit*rho_p
                 END if

                 ! medium mass
                 if (EPP(I,t) .gt. min_dense .and. EPP(I,t) .lt. min_dilute) then
                        medmass= medmass + (1-EP_G1(I,t))*Volume_Unit*rho_p
                 end if 

                 !dense mass 
                 if (EPP(I,t) .lt. min_dense) then 
                        densemass = densemass + (1-EP_G1(I,t))*Volume_Unit*rho_p
                 end if


                ! MASS IN THE CHANNEL
                IF (YYY(I,1)<top) THEN
                        inchannel = inchannel + (1-EP_G1(I,t))*Volume_Unit*rho_p
                end if 

                ! MASS WITHIN THE WIDTH OF THE CHANNEL INCLUDING ABOVE IT
                IF (ZZZ(I,1) >edge1) THEN
                        IF (ZZZ(I,1) <edge2) THEN
                                chmass = chmass + (1-EP_G1(I,t))*Volume_Unit*rho_p
                        END IF
                END IF


               END IF
              END IF
          END IF
         END DO
        
         WRITE(666, formatmass) t, tmass, elumass, medmass, densemass, inchannel, chmass, scalemass, scalemass1, scalemass2
        END DO
        !! done !!
        print*, 'mass in channel done'
        END SUBROUTINE massinchannel

end module 
