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

                If (YYY(I,1) > top) then 
                        outsum= outsum +(1-EP_G1(I,t))*Volume_Unit*rho_p
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

        subroutine edgevelocity 
                implicit none 
                double precision:: perpvel2, perpvel1, outsum
                logical, dimension(length1):: maskshapeout
      
                print*, 'edge velocity'
                filename='edge_vel1.txt'

                routine="massdist/edgevelocity"
                description="Calculate dot product of velocity and curve of the channel on edge1"
                datatype=" t XXX perpvel W_G EPP"
                call headerf(7888, filename, simlabel, routine, DESCRIPTION, datatype)

                filename='edge_vel2.txt'

                routine="massdist/edgevelocity"
                description="Calculate dot product of velocity and curve of the channel on edge2"
                datatype=" t XXX perpvel W_G EPP"
                call headerf(7889, filename, simlabel, routine, DESCRIPTION,datatype)

                do t= 1,timesteps
                do I=1,length1
                        call edges(width, lambda, depth, XXX(I,1), edge1, edge2, bottom, top)
                        edge1= FLOOR(edge1/3.)*3. + 3.
                        edge2= FLOOR(edge2/3.)*3. - 3.
                        top= FLOOR(top/3.)*3. - 3  
                       
                        !do J= 1,length1 
                              !  if (ZZZ(J,1) .gt. edge2) then 
                         !               if ( XXX(I,1) .eq. XXX(J,1)) then 
                         !                       maskshapeout(J) = .TRUE.
                         !               else 
                         !                       maskshapeout(J) = .FALSE.
                         !               end if 
                               ! end if 
                        !end do 
                        
                        if (YYY(I,1) .eq. top .and. ZZZ(I,1) .eq. edge1) then
                                perpvel1 = U_G1(I,t) + V_G1(I,t)*amprat*cosd(XXX(I,t)/lambda)
                                write(7888,formatent) t, XXX(I,1), perpvel1, W_G1(I,t)
                        elseif (YYY(I,1) .eq. top .and. ZZZ(I,1) .eq. edge2) then
                                perpvel2 = U_G1(I,t) +V_G1(I,t)*amprat*cosd(XXX(I,t)/lambda)
                                !outsum= rho_p*SUM(EP_G1(:,t), mask= maskshapeout)  
                                write(7889,formatent) t, XXX(I,1), perpvel2, W_G1(I,t) !, perpvel2, W_G1(I,t) !, outsum 
                                
                        end if 
                end do 
                end do 

        end subroutine

        subroutine massbyxxx
                implicit none 
                double precision, allocatable:: out1(:), out2(:)
                allocate(out1(3*RMAX))
                allocate(out2(3*RMAX))

                filename='massbyxxx.txt'

                routine="massdist/massbyxxx"
                description="Calculate mass outside the channel on left and right by XXX"
                datatype=" t, XXX, mass on right, mass on left"
                call headerf(6789, filename, simlabel, routine, DESCRIPTION,datatype)


                do K=1, RMAX 
                        out1(K) =0 
                        out2(K) =0 
                end do 

                do t=1,timesteps
                        do K=1,RMAX 
                                out1(K) =0 
                                out2(K) =0 
                        end do 

                        do I=1,length1
                                call edges(width, lambda, depth, XXX(I,1), edge1, edge2, bottom, top)
                                J= int(XXX(I,1))/3
                                edge1= FLOOR(edge1/3.)*3. + 3.
                                edge2= FLOOR(edge2/3.)*3. - 3.
                                top= FLOOR(top/3.)*3. - 3 

                                if (EPP(I,t) .gt. 1 .and. EPP(I,t) .lt. 8) then 
                                if (YYY(I,1) .eq. top .and. ZZZ(I,1) .lt. edge1) then
                                        out1(J)= out1(J) + (1-EP_G1(I,t))*Volume_Unit*rho_p
                                elseif (YYY(I,1) .eq. top .and. ZZZ(I,1) .gt. edge2) then
                                        out2(J)= out2(J) + (1-EP_G1(I,t))*Volume_Unit*rho_p
                                end if 
                                end if 

                        end do
                        
                        do K=1,RMAX
                                write(6789,formatent) t, dble(K*3.), out1(K), out2(K)
                        end do  
                end do 
        end subroutine
        
        subroutine density(loc,tim,rhc, mass)
        implicit none
        integer, intent(IN):: loc, tim
        double precision, intent(Out):: mass, rhc
                rhc=rho_p*(1-EP_G1(loc,tim))+(P_const/(R_dryair*(T_G1(loc,tim))))*(EP_G1(loc,tim))
                mass=3.*3.*3.*rhc
        end subroutine

        subroutine integratemass 
        implicit none 
        double precision, allocatable:: intmass(:,:,:), currentcells(:,:)
        double precision:: mass
         filename='intmass.txt'

        routine="massdist/energypotential"
        description="Calculate mass integral from EPP 0.5 to 8"
        datatype=" RMAX by ZMAX array of kinetic energy in channel"
        !call headerf(90990, filename, simlabel, routine,DESCRIPTION,datatype)     
        allocate(intmass(RMAX, ZMAX, timesteps))
        allocate(currentcells(RMAX, ZMAX))

        t=8 
        do rc=1,RMAX
                do zc =1,ZMAX
                        currentcells(rc,zc) = 0 
                end do 
        end do 
        
        do I=1,length1
        !        call edges(width, lambda, depth, XXX(I,1), edge1, edge2, bottom, top)
                if (EPP(I,t) .gt. 0.5 .and. EPP(I,t) .lt.  8) then 
                        rc = int(XXX(I,t)/3.)
                        zc = int(ZZZ(I,t)/3.)
                        call density(I,t, rho_c, mass)
                        intmass(rc,zc,t)= intmass(rc,zc,t) +mass
                        currentcells(rc,zc) = currentcells(rc,zc) +1

                end if 
        end do 

        do rc=1,RMAX
                do zc =1,ZMAX 
                        intmass(rc,zc,t)= intmass(rc,zc,t)/currentcells(rc,zc)

                        if ( isnan(intmass(rc, zc, t)) .eq. .FALSE.) then
                                print*, intmass(rc,zc,t)
                        end if 
                end do 
        end do 

        
                

        end subroutine 

        subroutine energypotential
        implicit none
        double precision, dimension(2)::N1, N2, U
        double precision:: dy, dx, mag, ux, uy, vel1, vel2
        double precision:: D, mass, KP1,PE, KP2, perpvel, totvel, h, outvel
        double precision, allocatable:: KPsum1(:,:,:), KPsum2(:,:,:)
        filename='potential.txt'

        routine="massdist/energypotential"
        description="Calculate mass outside the channel on left and right by XXX"
        datatype=" RMAX by ZMAX array of kinetic energy in channel"
        !call headerf(90909, filename, simlabel, routine,DESCRIPTION,datatype)        
        open(90909, file=filename)

        filename= 'perpvel.txt'
        open(90901, filename)
        allocate(KPsum1(RMAX, ZMAX, timesteps))
        allocate(KPsum2(RMAX, ZMAX, timesteps))
       ! allocate(intmass(RMAX, ZMAX, timesteps))


        do t=1,timesteps
                KPsum1(:,:,t)=0 
                KPsum2(:,:,t)=0
        end do 


        do t =1,timesteps 

        do I=1,length1

                call edges(width, lambda, depth, XXX(I,1), edge1, edge2, bottom, top)
                if ( EP_G1(I,t) .gt. 0.00) then
                if( YYY(I,1) .gt. bottom .and. YYY(I,1) .lt. top) then 
                       ux= U_G1(I,t)
                       uy= W_G1(I,t)

                       U = (/ ux, uy /)
                       dx = 1.0 
                       dy = 2*pi*amprat*cos(2*pi*(XXX(I,1)/lambda))
                       mag = sqrt(dy**2 + dx**2)
                       N1=(/ dy/mag, -dx/mag /)
                       N2=(/ -dy/mag, dx/mag /) 

                       vel1= dot_product(U, N1)
                       vel2 = dot_product(U,N2)
                       perpvel = max(vel1,vel2)
                       call density(I,t, rho_c, mass)
                       KP1 =  (0.5)*mass*perpvel**2

                       h = depth-(YYY(I,1) - bottom)
                       PE = mass*gravity*h

                          if ( isnan(KP1) .eq. .FALSE. ) then 
                           print*, perpvel, N1, N2, U
                        end if 


                        rc=int(XXX(I,1)/3.0)
                        zc=int(ZZZ(I,1)/3.0)

                        KPsum1(rc,zc,t)=KPsum1(rc,zc,t) + KP1/PE
                        KPsum2(rc,zc,t)=KPsum2(rc,zc,t) + perpvel

                  end if 
                end if
            end do 

            D = (depth/3.0)
            do rc=1,RMAX
                do zc=1,ZMAX

                   KPsum1(rc,zc,t) = KPsum1(rc,zc,t)/D
                   KPsum2(rc,zc,t) = KPsum2(rc,zc,t)/D
                        
                end do 
            end do 


            !print*, KPsum1(:,:,t)
            print*, maxval(KPsum1(:,:,t))
            print*, maxval(KPsum2(:,:,t))
                       
            
             
            do rc=1,RMAX
                do zc=1,ZMAX
!                write(90909,format1var) KPsum1(rc,zc,t)
!                write(90901,format1var) KPsum2(rc,zc,t)

            end do 
            end do

        end do 


        end subroutine 
end module 
