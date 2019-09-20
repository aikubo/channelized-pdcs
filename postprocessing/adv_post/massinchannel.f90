module massdist
        USE maketopo
        USE CONSTANTS 
        USE PARAMPOST 
        USE FORMATMOD
        USE filehead
         
        contains

        subroutine massinchannel(WIDTH, depth, LAMBDA, SCALEHEIGHT)
        use maketopo
        IMPLICIT NONE
        double precision, intent(INOut):: width, depth, lambda, scaleheight
        double precision:: elumass, medmass, densemass, inchannel, SCALEMASS, scalemass1, scalemass2
        double precision::edge1, edge2, bottom, top, outsum, buoyant, current

        print*, 'mass in channel'
        filename='massinchannel.txt'

        routine="massdist/massinchannel"
        description="Calculate mass distribution in different parts of the channel"
        datatype=" t Total Mass (m^3) Elutriated % Med Dense InChannel WidthChannel 0ScaleH ScaleH `buoyant current.. "
        filename='massinchannel.txt'
        call headerf(4500, filename, simlabel, routine, DESCRIPTION, datatype)
        write(4500, formatmass) 1, 0, 0, 0, 1.0, 1.0, 1.0, 0, 0, 0, 0, 0

        print *, "Done writing 3D variables"

      DO t= 2,timesteps
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
            call edges(width, lambda, depth, XXX(I,1), edge1, edge2, bottom, top)

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
                        !print*, top
                        inchannel = inchannel + (1-EP_G1(I,t))*Volume_Unit*rho_p
                end if 

                ! MASS WITHIN THE WIDTH OF THE CHANNEL INCLUDING ABOVE IT
                IF (ZZZ(I,1) >edge1) THEN
                        IF (ZZZ(I,1) <edge2) THEN
                                chmass = chmass + (1-EP_G1(I,t))*Volume_Unit*rho_p
                        END IF
                END IF

                If (YYY(I,t) > top) then 
                        outsum = outsum + (1-EP_G1(I,t))*Volume_Unit*rho_p
                        rho_c=rho_p*(1-EP_G(I,t))+(P_const/(R_dryair*T_G(I,t)))*(EP_G(I,t))
                        if ( rho_c < rho_dry) then
                        buoyant = buoyant + (1-EP_G1(I,t))*Volume_Unit*rho_p

                        elseif (rho_c > rho_)
                        current = current + (1-EP_G1(I,t))*Volume_Unit*rho_p

                        end if 
                end if 

               END IF
              END IF
          END IF
         END DO
        
         WRITE(4500, formatmass) t, tmass, outsum, elumass/tmass, medmass/tmass, densemass/tmass, inchannel/tmass, chmass/tmass, scalemass/tmass, scalemass1/tmass, buoyant/outsum, current/outsum
        END DO
        !! done !!
        print*, 'mass in channel done'
        END SUBROUTINE massinchannel

end module 
