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
        datatype=" t Total Mass (m^3) Elutriated % Med Dense InChannel WidthChannel 0ScaleH ScaleH buoyant current "
        filename='massinchannel.txt'
        call headerf(4500, filename, simlabel, routine, DESCRIPTION, datatype)
     !   write(4500, formatmass) 1, 0, 0, 0, 1.0, 1.0, 1.0, 0, 0, 0, 0, 0

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
        buoyant=0 
        current=0 
        outsum=0
       
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
                        rho_c=rho_p*(1-EP_G1(I,t))+(P_const/(R_dryair*T_G1(I,t)))*(EP_G1(I,t))
                        if ( rho_c < rho_dry) then
                        buoyant = buoyant + (1-EP_G1(I,t))*Volume_Unit*rho_p

                        elseif (rho_c > rho_dry) then
                        current = current + (1-EP_G1(I,t))*Volume_Unit*rho_p

                        end if 
                end if 

               END IF
              END IF
          END IF
         END DO
         elumass=elumass/tmass
         medmass= medmass/tmass
         densemass= densemass/tmass
         inchannel= inchannel/tmass
         chmass=chmass/tmass
         scalemass= scalemass/tmass
         scalemass1= scalemass1/tmass
         buoyant= buoyant/tmass
         current=current/tmass     
        
         WRITE(4500, formatmass) t, tmass, outsum, elumass, medmass, densemass, inchannel, chmass, scalemass, scalemass1, buoyant, current
        END DO
        !! done !!
        print*, 'mass in channel done'
        END SUBROUTINE massinchannel


        subroutine crossstream
                implicit none 
                double precision:: dominantvel, tmass, mass, Umass, Vmass, Wmass
                double precision:: Uepp, Vepp, Wepp, sum1, sum3, sum2
                print*, 'cross stream'
                filename='cross_stream.txt'
        
                routine="massdist/cross_stream"
                description="Calculate mass distribution moving cross vs downstream"
                datatype=" t Total Mass (Higest velocity) U W V"
                call headerf(4510, filename, simlabel, routine, DESCRIPTION, datatype)

                do t= 1,timesteps
                        tmass=0
                        Umass=0
                        Vmass=0
                        Wmass=0
                        Uepp=0
                        Vepp=0
                        Wepp=0
                        sum1=0
                        sum2=0
                        sum3=0

                        do I=1,length1 
                                if (EPP(I,t) .gt. 0 .and. EPP(I,t) .lt. 8) then 
                                        mass = (1-EP_G1(I,t))*Volume_Unit*rho_p
                                        tmass=tmass+ mass
                                        dominantvel= max(U_G1(I,t), V_G1(I,t), W_G1(I,t))

                                        if (dominantvel .eq. U_G1(I,t)) then 
                                                Umass= Umass +mass
                                                sum1= 1 + sum1
                                                Uepp = Uepp + EPP(I,t)
                                        elseif (dominantvel .eq. V_G1(I,t)) then
                                                Vmass= Vmass +mass 
                                                sum2= 1 + sum2
                                                Vepp = Vepp + EPP(I,t)
                                        elseif (dominantvel .eq. W_G1(I,t)) then 
                                                Wmass= Wmass +mass
                                                sum3= 1 + sum3
                                                Wepp = Wepp + EPP(I,t)
                                        end if 
                                end if
                        end do 

                        Umass=Umass/tmass
                        Vmass=Vmass/tmass
                        Wmass=Wmass/tmass
                        Vepp=Vepp/sum2
                        Uepp= Uepp/sum1
                        Wepp=Wepp/sum3

                        write(4510, format7col) t, Umass, Uepp, Vmass, Vepp, Wmass, Wepp
               end do                                  

        end subroutine
end module 
