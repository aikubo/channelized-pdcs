module massdist
        USE maketopo
        USE CONSTANTS
        USE PARAMPOST
        USE FORMATMOD
        USE filehead

        contains

        subroutine massinchannel(WIDTH, depth, LAMBDA, SCALEHEIGHT,area)
        use maketopo
        IMPLICIT NONE
        double precision, intent(INOut):: area, width, depth, lambda,scaleheight
        double precision:: slopel, atest, cellarea,  elumass, medmass,densemass, inchannel, SCALEMASS, scalemass1, scalemass2
        double precision:: carea,  areaout, outsum, buoyant, current, topo, areatot
        real, allocatable:: areamat(:,:,:)
        logical::channeltrue, plain
        integer:: Iold, icount
        print*, 'mass in channel'
        filename='massinchannel.txt'

        routine="massdist/massinchannel"
        description="Calculate mass distribution in different parts of the channel. Total area is 1115705"
        datatype=" t Total Mass (m^3) TotalOutOfChannel Dense InChannel GT1ScaleH BuoyantOut DenseOut Areat AreaC Area Aout"
        filename='massinchannel.txt'
        call headerf(4500, filename, simlabel, routine, DESCRIPTION, datatype)
     !   write(4500, formatmass) 1, 0, 0, 0, 1.0, 1.0, 1.0, 0, 0, 0, 0,
     !   0
        print *, "Done writing 3D variables"
        areatot=DX(1)*ZMAX*(RMAX*DZ(1))!*sqrt(slope**2+1))! cos(slope) !
      !906 * 1212/dcos(10.2)
     !   allocate(areamat( RMAX,ZMAX))
        cellarea=DX(3)*DX(3) !*sqrt(slope**2+1))
        write(*,*) cellarea
        carea=0
        icount=0
        !allocate(areamat(RMAX, YMAX, ZMAX))
        do zc=4,ZMAX-4
                do rc=4,RMAX-4
                        do yc=4,YMAX-4
                        !write(*,*) I
                        call funijk(rc, yc, zc, I)
                        call edgesdose(width, lambda, depth,  XXX(I,1), YYY(I,1),ZZZ(I,1), slope, topo, channeltrue, plain)

                       ! write(*,*) XXX(I,1), YYY(I,1),ZZZ(I,1), top
                        if ( channeltrue .and. YYY(I,1) .eq. topo) then
!.and. abs(YYY(I,1)-topo) .lt. DX(1) )then
                                carea=carea+cellarea
                        !        write(*,*) I, topo, YYY(I,1), EPP(I,3)
                        end if

                        !if (I .eq. Iold) then
                        !        write(*,*) "what I repeats", icount,
                        !        "at", I
                        !        icount=icount+1
                        !end if
                        !Iold=I
                        end do
                end do
        end do
        write(*,*) "done with carea", carea
        !write(*,*) "what I repeats", icount, "at", I
     DO t= 2, 8  !timesteps
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
        area=0
        areaout=0
        atest=0

        do zc=3,ZMAX-2
                do rc=3,RMAX-2
                        do yc=3,YMAX-2
                        call funijk(rc, yc, zc, I)

                        call edgesdose(width, lambda, depth, XXX(I,1), YYY(I,1), ZZZ(I,1),  slope, topo, channeltrue,plain)
                       if ( YYY(I,1) .eq. topo) then

                                atest=atest+cellarea

                       end if

                IF (EPP(I,t) < 6.5 .and. EPP(I,t) >0.00001 ) THEN
                        tmass = tmass + (1-EP_G1(I,t))*Volume_Unit*rho_p
                      !  if (ZZZ(I,1) .lt. edge1  .or. ZZZ(I,1) .gt.
                      !  edge2) then
                      !          if (YYY(I,1) .ge. top-3 .and. YYY(I,1)
                      !          .lt. top+3) then
                      !                   areaout=areaout+cellarea
                      !          end if
                      !  end if

                      !  if ( ZZZ(I,1) .gt. edge1  .and. ZZZ(I,1) .lt.
                      !  edge2) then
                      !         if (YYY(I,1) .ge. bottom-3 .and.
                      !         YYY(I,1) .lt. bottom+3) then
                      !                   area=area+cellarea
                      !          end if

                      !  end if

                     !! test



                        if (  YYY(I,1) .eq. topo) then
                                area = area+cellarea

                                IF ( .NOT. CHANNELtrue) THEN
                                        areaout=areaout+cellarea
                                end if
                               ! write(*,*) "inside flow", I
                                !if ( areamat(int(XXX(I,1) * 0.98),
                                !int(ZZZ(I,1)/3.)) .ne. 9) then
                                !        areamat(int(XXX(I,1)/3.),
                                !        int(ZZZ(I,1)/3.))=cellarea
                                !end if

                       end if
                    !end if

                IF (YYY(I,1) .ge. topo) THEN
                ! total mass

                                ! MASS ABOVE CERTAIN SCALE HEIGHTS
                                if ( YYY(I,1) .LT. topo+depth ) then
                                  SCALEMASS= SCALEMASS +(1-EP_G1(I,t))*Volume_Unit*rho_p
                                end if

                                !  if ( YYY(I,1) .GT. SCALEHEIGHT+bottom
                                !  ) then
                                !         SCALEMASS1= SCALEMASS1 +
                                !         (1-EP_G1(I,t))*Volume_Unit*rho_p
                                ! end if

                                ! ! elutriated masss
                                !  IF (EPP(I,t) > 5.0) THEN
                                !         elumass=
                                !         elumass+(1-EP_G1(I,t))*Volume_Unit*rho_p
                                !  END if

                                !  ! medium mass
                                !  if (EPP(I,t) .gt. min_dense .and.
                                !  EPP(I,t) .lt. min_dilute) then
                                !         medmass= medmass +
                                !         (1-EP_G1(I,t))*Volume_Unit*rho_p
                                !  end if

                                !dense mass
                                if (EPP(I,t) .lt. 0.51) then
                                        densemass = densemass +(1-EP_G1(I,t))*Volume_Unit*rho_p
                                end if


                                ! MASS IN THE CHANNEL
                                IF (channeltrue) THEN

                                        !print*, top
                                        inchannel = inchannel +(1-EP_G1(I,t))*Volume_Unit*rho_p
                                end if

                                ! MASS WITHIN THE WIDTH OF THE CHANNEL
                                ! INCLUDING ABOVE IT
                                IF (channeltrue) THEN

                                                chmass = chmass +(1-EP_G1(I,t))*Volume_Unit*rho_p
                                END IF

                                If ( plain ) then
                                                        outsum= outsum+(1-EP_G1(I,t))*Volume_Unit*rho_p
                                                        rho_c=rho_p*(1-EP_G1(I,t))+(P_const/(R_dryair*T_G1(I,t)))*(EP_G1(I,t))

                                                        if ( rho_c <rho_dry) then
                                                                buoyant= buoyant + (1-EP_G1(I,t))*Volume_Unit*rho_p

                                                        elseif (rho_c >rho_dry) then
                                                                current= current + (1-EP_G1(I,t))*Volume_Unit*rho_p
                                                        end if


                               end if

                        END IF
                END IF



                I=I+1
                end do
             end do

        END DO
        !  elumass=elumass/tmass
        !  medmass= medmass/tmass
         densemass= densemass/tmass
         inchannel= inchannel/tmass
         chmass=chmass/tmass
         scalemass= scalemass/tmass
         scalemass1= scalemass1/tmass
         buoyant= buoyant/tmass
         current=current/tmass

         write(*,*) carea, "true: ", (width)*DX(1)*RMAX
!*(sqrt(slope**2+1))
         !write(*,*) area
         write(*,*) tmass, .4*15*1950*width*18*10,tmass/(.4*15*10*1950*width*18)
         WRITE(4500, formatmass) t, tmass, outsum, densemass, inchannel, scalemass1, buoyant, current, areatot, carea, (area)/areatot,areaout/(areatot-carea)
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
                                        mass =(1-EP_G1(I,t))*Volume_Unit*rho_p
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

                        write(4510, format7col) t, Umass, Uepp, Vmass,Vepp, Wmass, Wepp
               end do

        end subroutine

        subroutine edgevelocity
                implicit none
                double precision:: perpvel2, perpvel1, outsum,  perpvel
                logical, dimension(length1):: maskshapeout
                double precision, allocatable:: curtains1(:,:),curtains2(:,:)
                double precision, allocatable:: edgevel1(:),edgevel2(:)
                double precision, allocatable:: minvel1(:), minvel2(:)
                double precision :: XLOC, sum1, sum2
                double precision, dimension(2)::N1, N2, U
                double precision:: dy, dx, mag, ux, uy, vel1, vel2
                integer:: y1, y2
                allocate(curtains1(RMAX, YMAX))
                allocate(curtains2(RMAX, YMAX))
                allocate(edgevel1(RMAX))
                allocate(edgevel2(RMAX))
                allocate(minvel1(RMAX))
                allocate(minvel2(RMAX))

                print*, 'edge velocity'
                filename='edge_vel.txt'

                routine="massdist/edgevelocity"
                description="Velocity pointing out of curve edge1 depthaverage summed over time"
                datatype="XXX perpvel1 perpvel2 minvel1 minvel2 "
                call headerf(7888, filename, simlabel, routine,DESCRIPTION, datatype)

                !filename='edge_vel2.txt'

                !routine="massdist/edgevelocity"
                !description="Velocity pointing out of curve edge2 depth
                !average summed over time"
                !datatype=" t XXX perpvel V_G EPP"
                !call headerf(7889, filename, simlabel, routine,
                !DESCRIPTION,datatype)

                filename='edge_vel_y.txt'

                routine="massdist/edgevelocity"
                description="Calculate dot product of velocity and curve over y, summed over timesteps"
                datatype=" 2D matrix of rmax by ymax"
                call headerf(7088, filename, simlabel, routine,DESCRIPTION, datatype)

                do yc =1,YMAX
                        curtains1(:,yc) = 0
                        curtains2(:,yc) = 0
                end do
                print*, "timeloop"
                do t= 1,timesteps

                        do I=1,length1

                                call edges(width, lambda, depth,XXX(I,1), slope, edge1, edge2, bottom, top)
                                edge1= FLOOR(edge1/3.)*3. + 6.
                                edge2= FLOOR(edge2/3.)*3. - 6.
                                bottom= FLOOR(bottom/3.)*3. !- 6
                                ux= U_G1(I,t)
                                uy= W_G1(I,t)

                                U = (/ ux, uy /)
                                dx = 1.0
                                dy =2*pi*amprat*cos(2*pi*(XXX(I,1)/lambda))
                                mag = sqrt(dy**2 + dx**2)
                                N1=(/ dy/mag, -dx/mag /)
                                N2=(/ -dy/mag, dx/mag /)

                                vel1= dot_product(U,N1)
                                vel2 = dot_product(U,N2)
                                !perpvel = max(vel1,vel2)


                                if (YYY(I,1) .gt. bottom .and. ZZZ(I,1).eq. edge1) then
                                        perpvel = vel1
                                        rc = int(XXX(I,1)/3.0)
                                        yc= int(YYY(I,1)/3.0)
                                        curtains1(rc,yc)=curtains1(rc,yc)+perpvel
                                end if
                                if (YYY(I,1) .gt. bottom .and. ZZZ(I,1).eq. edge2) then
                                        perpvel = vel2
                                        rc = int(XXX(I,1)/3.0)
                                        yc= int(YYY(I,1)/3.0)
                                        curtains2(rc,yc)=curtains2(rc,yc)+perpvel
                                end if
                        end do
                end do
                print*, "sum over depth"
                do rc=1,RMAX
                        sum1=0
                        sum2=0

                        XLOC= dble(rc*3.)
                        ! call edges(width, lambda, depth, XLOC, edge1,
                        ! edge2, bottom, top)
                        ! y1= FLOOR(bottom/3.)
                        ! y2= FLOOR(top/3.)
                        ! print*, y1, y2
                        ! do yc= y1,y2
                        !         sum1=sum1+curtains1(rc,yc)
                        !         sum2=sum2+curtains2(rc,yc)
                        ! end do

                        !print*, maxval(curtains2(rc,:))

                        edgevel1(rc)=maxval(curtains1(rc,:))
                        edgevel2(rc)= maxval(curtains2(rc,:))
                        minvel2(rc)= minval(curtains2(rc,:))
                        minvel1(rc)=minval(curtains1(rc,:))
                        ! depth averaged, summed over time
                        print*, edgevel1(rc), edgevel2(rc)

                end do

                do rc =1,RMAX
                        write(7088, formatcurtain) curtains1(rc,:)
                        write(7888, format5var) rc*3.,  edgevel1(rc),edgevel2(rc), minvel1(rc), minvel2(rc)

                end do

        end subroutine

        subroutine massbyxxx
                implicit none
                double precision:: topo, centerline
                logical:: channeltrue, plain
                double precision, allocatable:: out1(:), out2(:)
                allocate(out1(RMAX))
                allocate(out2(RMAX))

                filename='massbyxxx.txt'

                routine="massdist/massbyxxx"
                description="Calculate mass total outside the channel on leftand right by XXX"
                datatype=" t, XXX, mass on right, mass on left,totalmass"
                call headerf(6789, filename, simlabel, routine,DESCRIPTION,datatype)


                t=8
                        do K=1,RMAX
                                out1(K) =0
                                out2(K) =0
                        end do

                        do rc=4,RMAX-4
                                do yc=4,YMAX-4
                                   do zc=4,ZMAX-4
                                        call funijk(rc, yc, zc, I)
                                call edgesdose(width, lambda, depth,  XXX(I,1), YYY(I,1),ZZZ(I,1), slope, topo, channeltrue, plain)
                                centerline= lambda*amprat*sind((360*(rc-4)*3/lambda))+450

                                if (EPP(I,t) .gt. 0) then
                                if (plain) then
                                   if ( dble(3*zc) .lt. centerline) then
                                        out1(rc)= out1(rc) +(1-EP_G1(I,t))*Volume_Unit*rho_p
                                else
                                        out2(rc)= out2(rc) +(1-EP_G1(I,t))*Volume_Unit*rho_p
                                end if
                                end if
                                end if

                        end do
                        end do
                        end do

                          do rc=4,RMAX-4
                                write(6789,formatmassxxx) t, (rc-3)*3, out1(rc), out2(rc), out1(rc)+out2(rc)
                        end do

                        write(*,*) "check"
                        write(*,*), sum(out1), sum(out2), sum(out1)+sum(out2)

        end subroutine

        subroutine density(loc,tim,rhc, mass)
        implicit none
        integer, intent(IN):: loc, tim
        double precision, intent(Out):: mass, rhc
                rhc=rho_p*(1-EP_G1(loc,tim))+(P_G(I,t)/(R_vapor*(T_G1(loc,tim))))*(EP_G1(loc,tim))
                mass=3.*3.*3.*rhc
        end subroutine

        subroutine integratemass
        implicit none
        double precision, allocatable:: intmass(:,:,:),currentcells(:,:)
        double precision:: mass
         filename='intmass.txt'

        routine="massdist/energypotential"
        description="Calculate mass integral from EPP 0.5 to 8"
        datatype=" RMAX by ZMAX by time array of g"
        call headerf(90999, filename, simlabel,routine,DESCRIPTION,datatype)
        allocate(intmass(RMAX, ZMAX, timesteps))
        allocate(currentcells(RMAX, ZMAX))

        t=8
        do rc=1,RMAX
                do zc =1,ZMAX
                        currentcells(rc,zc) = 0
                end do
        end do

        do I=1,length1
        !        call edges(width, lambda, depth, XXX(I,1), edge1,
        !        edge2, bottom, top)
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
                        intmass(rc,zc,t)=intmass(rc,zc,t)/currentcells(rc,zc)

                        if ( isnan(intmass(rc, zc, t)) .eq. .FALSE.) then
                                !print*, intmass(rc,zc,t)
                        end if

                        write(90999, format1var) intmass(rc,zc,t)
                end do
        end do




        end subroutine

        subroutine energypotential
        implicit none
        double precision, dimension(2)::N1, N2, U
        double precision:: dy, dx, mag, ux, uy, vel1, vel2
        double precision:: D, W, mass, KP1,PE, KP2, perpvel, totvel, h,outvel
        double precision, allocatable:: KPsum1(:,:,:), KPsum2(:,:,:),PEsum(:,:,:)
        double precision, allocatable::perpx(:,:), pex(:,:), kex(:,:)

        filename='KE.txt'
        routine="massdist/energypotential"
        description="KE pointing out of channel"
        datatype=" RMAX by ZMAX by t  array of kinetic energy in channel(J)"
        call headerf(90909, filename, simlabel,routine,DESCRIPTION,datatype)

        filename= 'perpvel.txt'
        description=" RMAX by ZMAX by t perpvel (m/s)"
        datatype=" RMAX by ZMAX array of kinetic energy in channel"
        call headerf(90910, filename, simlabel,routine,DESCRIPTION,datatype)

        filename= 'PE.txt'
        description=" Calculates potential energy necessary to overflowat each height"
        datatype=" RMAX by ZMAX by t potential energy (J)"
        call headerf(90911, filename, simlabel,routine,DESCRIPTION,datatype)

         filename= 'perpvelbyx.txt'
        description="integrates perpvel over width "
        datatype=" RMAX by t array of perpvel in channel"
        call headerf(90912, filename, simlabel,routine,DESCRIPTION,datatype)

        filename= 'PEbyx.txt'
        description="Integrates by width potential energy necessary to overflow at each height"
        datatype=" RMAX by t potential energy (J)"
        call headerf(90913, filename, simlabel,routine,DESCRIPTION,datatype)

        filename= 'KEbyx.txt'
        description=" Integrates by width K energy necessary height"
        datatype=" RMAX by t kinetic energy (J)"
        call headerf(90914, filename, simlabel,routine,DESCRIPTION,datatype)


        allocate(KPsum1(RMAX, ZMAX, timesteps))
        allocate(KPsum2(RMAX, ZMAX, timesteps))
        allocate(PEsum(RMAX, ZMAX, timesteps))
        allocate(pex(RMAX,timesteps))
        allocate(kex(RMAX,timesteps))
        allocate(perpx(RMAX,timesteps))

        do t=1,timesteps
                KPsum1(:,:,t)=0
                KPsum2(:,:,t)=0
                PEsum(:,:,t)=0
                pex(:,t)=0
                kex(:,t)=0
                perpx(:,t)=0
        end do


        do t =1,timesteps

        do I=1,length1

                call edges(width, lambda, depth, XXX(I,1), slope, edge1,edge2, bottom, top)
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

                       vel1= dot_product(U,N1)
                       vel2 = dot_product(U,N2)
                       perpvel = max(vel1,vel2)
                       call density(I,t, rho_c, mass)
                       KP1 =  (0.5)*mass*perpvel**2
                       !print*, N1, N2
                       !print*, U
                       h = depth-(YYY(I,1) - bottom)
                       PE = mass*gravity*h

                      !    if ( isnan(KP1) .eq. .FALSE. ) then
                      !     print*, perpvel, N1, N2, U
                      !  end if
                       ! if ( perpvel .gt. 30.0000) then
                       !        print*, "greater than 30"
                       !        print*, perpvel, U
                       !        print*, "loc at "
                       !        print*, XXX(I,1), ZZZ(I,1)
                       !  end if

                        rc=int(XXX(I,1)/3.0)
                        zc=int(ZZZ(I,1)/3.0)
                        PEsum(rc,zc,t) = PEsum(rc,zc,t) + PE
                        KPsum1(rc,zc,t)=KPsum1(rc,zc,t) + KP1
                        KPsum2(rc,zc,t)=KPsum2(rc,zc,t) + perpvel

                  end if
                end if
            end do
            !print*, "testing dim =2"
            !print*, KPsum1(404, :, t)
            D = (depth/3.0)
            W = width/3.0
            do rc=1,RMAX
                pex(rc,t) = SUM(PEsum(rc,:,t))/(W*D)
                kex(rc,t) = SUM(KPsum1(rc,:,t))/(W*D)
                perpx(rc,t)=SUM(KPsum2(rc,:,t))/(W*D)

                do zc=1,ZMAX
                   PEsum(rc,zc,t)= PEsum(rc,zc,t)/D
                   KPsum1(rc,zc,t) = KPsum1(rc,zc,t)/D
                   KPsum2(rc,zc,t) = KPsum2(rc,zc,t)/D

                end do
            end do


            !print*, KPsum1(:,:,t)
            print*, maxval(KPsum1(:,:,t))
            print*, maxval(KPsum2(:,:,t))



            do rc=1,RMAX
                write(90913, format1var) pex(rc,t) !
                write(90914, format1var) kex(rc,t) !
                write(90912, format1var) perpx(rc,t) !
                do zc=1,ZMAX
                        write(90909,format1var) KPsum1(rc,zc,t)
                        write(90910,format1var) KPsum2(rc,zc,t)
                        write(90911, format1var) PEsum(rc,zc,t)
            end do
            end do

        end do
        end subroutine

        subroutine transectsfromchannel
        implicit none
        integer:: zc1, zc2, IJK, I,J,K
        double precision:: XLOC
        integer:: ZLOC
        double precision, allocatable:: transect(:,:,:,:),max_trans(:,:,:)
        allocate(max_trans(3,ZMAX, 6))
        allocate(transect(3,ZMAX, timesteps, 6))

        filename= 'transect.txt'
        description="Transects from channel sides to edges"
        routine= "massdist/trnsectsfromchannel"
        datatype="300 EPP, 600 EPP, 900 EPP, 300 TG, 600 TG, 900 TG, 300 DPU, 600 DPU, 900 DPu"
        call headerf(90915, filename, simlabel,routine,DESCRIPTION,datatype)

            do t=1,timesteps
               do I=1,3
                  do  zc=1,ZMAX

                                transect(I,zc,t,1)=14.0
                                transect(I, zc, t,2)=273.0
                                transect(I,zc,t,3)=0
                                transect(I,zc,t,4)=14.0
                                transect(I, zc, t,5)=273.0
                                transect(I,zc,t,6)=0


                  end do
                end do
             end do


        do I=1,3
                rc = floor(lambda*(I+1)*0.25/3)
                XLOC= dble( rc*3)

                call edges(width, lambda, depth, XLOC, slope, edge1,edge2, bottom, top)
                ! edge 1
                zc1= 2
                zc2= int( (ceiling(edge1/3.0)))
                yc = int( (ceiling(top/3.0) ))+6



                        do zc= zc1, zc2 !zc2, zc1, -1
                                call FUNIJK(rc,yc,zc,IJK)
                                ZLOC= zc2-zc+1
                                print*, "side1", zc, ZLOC
                                do t=2,timesteps
                                transect(I,ZLOC,t,1)=EP_G1(IJK,t)
                                transect(I,ZLOC,t,2)= T_G1(IJK,t)
                                transect(I,ZLOC,t,3)= DPU(IJK,t)
                                end do
                        end do


                zc2= int( ceiling(edge2/3.0))
                       do zc= zc2, ZMAX
                                call FUNIJK(rc,yc,zc,IJK)
                                ZLOC= zc-zc2+1
                                print*, "side2",zc,  zloc

                                do t=2,timesteps
                                transect(I,ZLOC,t,4)= EP_G1(IJK,t)
                                transect(I,ZLOC,t,5)= T_G1(IJK,t)
                                transect(I,ZLOC,t,6)= DPU(IJK,t)
                                end do
                        end do


        end do
         print*, "finished loops"
       !print*, transect(:,:,:,:)

               do I=1,3
                  do  zc=1,ZMAX

                             do t=2,timesteps
                                max_trans(I,zc,2)=min(transect(I,zc,t,1), max_trans(I,zc,1))
                                max_trans(I,zc,2)=max(transect(I,zc,t,2), max_trans(I,zc,2))
                                max_trans(I,zc,3)=max(transect(I,zc,t,3), max_trans(I,zc,3))


                                       ! if ( transect(I,zc,t,4) .lt.
                                       ! max_trans(I,zc,4) .and.
                                       ! transect(I,zc,t,4) .gt.
                                       ! dble(0.0) ) then
                                       !         max_trans(I,zc,1)=transect(I,zc,t,1)
                                       ! end if

                                max_trans(I,zc,4)=max(transect(I,zc,t,4),max_trans(I,zc,4))
                                max_trans(I,zc,5)=max(transect(I,zc,t,5),max_trans(I,zc,5))
                                max_trans(I,zc,6)=max(transect(I,zc,t,6),max_trans(I,zc,6))

                        eND DO
                END DO
        end do
        print*, "finished maxx loops"
        do zc=1,ZMAX
                write(90915, formattrans) max_trans(1,zc,1),max_trans(2,zc,1), max_trans(3,zc,1),&
                 max_trans(1,zc,2),  max_trans(2,zc,2),max_trans(3,zc,2),&
                 max_trans(1,zc,3),  max_trans(2,zc,3),max_trans(3,zc,3),&
                 max_trans(1,zc,4),  max_trans(2,zc,4),max_trans(3,zc,4),&
                 max_trans(1,zc,5),  max_trans(2,zc,5),max_trans(3,zc,5),&
                 max_trans(1,zc,6),  max_trans(2,zc,6),max_trans(3,zc,6)
       !  WRITE(*,FORMATTRANS) max_trans(1,zc,1), max_trans(2,zc,1),
       !  max_trans(3,zc,1), max_trans(1,zc,2),  max_trans(2,zc,2),
       !  max_trans(3,zc,2),max_trans(1,zc,3),  max_trans(2,zc,3),
       !  max_trans(3,zc,3), max_trans(1,zc,4),  max_trans(2,zc,4),
       !  max_trans(3,zc,4), max_trans(1,zc,5),max_trans(2,zc,5),
       !  max_trans(3,zc,5),max_trans(1,zc,6),  max_trans(2,zc,6),
       !  max_trans(3,zc,6)


        end do

        print*, "finished write"


        end subroutine


        subroutine buoyantplumes
                integer:: ytop
                double precision, allocatable:: buoyantsum(:)
                double precision:: mass, XLOC

                filename= 'sideplume.txt'
                description="Time averaged amount of buoyant materialfrom 1 to zmax"
                routine= "massdist/trnsectsfromchannel"
                datatype="buoyant "
                call headerf(90919, filename, simlabel,routine,DESCRIPTION,datatype)



                allocate(buoyantsum(ZMAX))

                do t=1,timesteps
                        do rc=1,RMAX
                                XLOC=dble(rc*3)
                                call edges(width, lambda, depth, XLOC,slope, edge1, edge2, bottom, top)

                                ytop = int(ceiling(top/3)) + 6
                                print*, "ytop", ytop
                                do zc=1,ZMAX
                                       do yc=ytop,YMAX
                                          call FUNIJK(rc, yc, zc, IJK)
                                          call density(IJK,t, rho_c,mass)
                                          !if ( EP_G1(IJK,t) .gt. 0.0
                                          !.and. EP_G1(IJK,t) .lt.
                                          !0.99999999) then
                                          if( rho_c < rho_dry) then
                                                  buoyantsum(zc)=buoyantsum(zc) + Volume_Unit*(1-EP_G1(IJK,t))*rho_p
                                                  !print*, rho_c,
                                                  !rho_dry
                                          end if
                                          !end if
                                       end do
                                end do
                        end do
                end do

                do rc=1,ZMAX
                        buoyantsum(rc)=buoyantsum(rc)/timesteps
                end do

                do rc=1,ZMAX
                       ! write(*,*) buoyantsum(rc)
                       write(90919,format1var) buoyantsum(rc)
                end do
                end subroutine



       subroutine overspill
        double precision:: mass

          filename= 'overspill_avg.txt'
          description="Average values in overspilled current"
          routine= "massdist/ovespill"
          datatype=" t   T_G   U_G   V_G   W_G   U_S1   DPU "
          call headerf(7487, filename, simlabel,routine,DESCRIPTION,datatype)




        do t=1,timesteps
                sum_1 = 0
                sum_2 = 0
                sum_3 = 0
                avgt = 0
                avgt2 = 0
                avgt3 = 0
                avgu = 0
                avgu2 = 0
                avgu3 = 0
                avgv = 0
                avgv2 = 0
                avgv3 = 0
                avgus = 0
                avgus2 = 0
                avgus3 = 0
                avgw = 0
                avgw2 = 0
                avgw3 = 0
                avgdpu =0
                avgdpu3=0
                avgdpu2=0


            DO I=1,length1
               call edges(width, lambda, depth, XXX(I,1), slope, edge1,edge2, bottom, top)
                if (YYY(I,1) .gt. top) then

                 call density(I,t, rho_c, mass)
                        if( rho_c < rho_dry) then

                                IF (EPP(I,t) .Gt. min_dense .and.EPP(I,t) .lt. max_dilute) THEN
                               sum_1 = sum_1 +1
                               avgt = T_G1(I,t) + avgt
                               avgu = U_G1(I,t) + avgu
                               avgv = U_G1(I,t) + avgv
                               avgw = V_G1(I,t) + avgw
                               avgus = U_S1(I,t) + avgus
                               avgdpu = DPU(I,t) + avgdpu
                        END IF

                        IF (EPP(I,t) .Gt. min_dense .and. EPP(I,t) .lt.min_dilute) THEN
                               sum_2 = sum_2 +1
                               avgt2 = T_G1(I,t) + avgt2
                               avgu2 = U_G1(I,t) + avgu2
                               avgv2 = V_G1(I,t) + avgv2
                               avgw2 = W_G1(I,t) + avgw2
                               avgus2 = U_S1(I,t) + avgus2
                               avgdpu2 = dpu(I,t) + avgdpu2

                        END IF

                        IF (EPP(I,t) .Gt. max_dense .and. EPP(I,t) .lt.min_dilute) THEN
                               sum_3 = sum_3 +1
                               avgt3 = T_G1(I,t) + avgt3
                               avgu3 = U_G1(I,t) + avgu3
                               avgv3 = V_G1(I,t) + avgv3
                               avgw3 = W_G1(I,t) + avgw3
                               avgus3 = U_S1(I,t) + avgus3
                               avgdpu3 = dpu(I,t) + avgdpu3
                               write(*,*) sum_3
                        END IF

                        end if
                    end if
                END DO

                     print*, "writing average"
                     WRITE(7487, formatavgx2) t, avgt/sum_1, avgu/sum_1,avgv/sum_1, avgw/sum_1, avgdpu/sum_1, avgt2/sum_2, avgu2/sum_2,avgv2/sum_2, avgw2/sum_2, avgdpu2/sum_2
                end do
        end subroutine


subroutine e1vse2

        double precision:: ve1, ve2, ri1, ri2, dpu1, dpu2,  massout1,massout2
        double precision:: sume1, sume2
        logical:: channeltrue, plain
        double precision:: topo, centerline

          filename= 'e2vse1.txt'
          description="Depth averages values on eitherside ofcenterline"
          routine= "massdist/e1vse2"
          datatype=" t   U_G_e1 UG_e2 Ri_1 Ri_2  DPU_1 DPU_2 Massout1 Massout2 "
          call headerf(1951, filename, simlabel,routine,DESCRIPTION,datatype)



        do t=1,timesteps
        sume1=0
        sume2=0
        ve1=0
        ve2=0
        massout1=0
        massout2=0
        ri1=0
        ri2=0
        dpu2=0
        dpu1=0

          do zc=4,ZMAX-4
                do rc=4,RMAX-4
                        do yc=4,YMAX-4
                        call funijk(rc, yc, zc, I)

                        call edgesdose(width, lambda, depth,XXX(I,1),YYY(I,1),ZZZ(I,1),  slope, topo, channeltrue, plain)
                            if (EPP(I,t) .ge. 0.1 .and. EPP(I,t).lt.min_dilute)then
                                centerline=lamba*amprat*sind(360*dble(rc*3)/lambda)+dble(ZMAX*3/2)
                                        if (channeltrue) then
                                                  if ( ZZZ(I,1) .lt. centerline)then
                                                        ve1=ve1+U_G1(I,t)
                                                        sume1=sume1+1
                                                        ri1=Ri(I,t)+ri1+1


                                                        DPU1=DPU(i,t)+dpu1
                                                  else
                                                        ve2=ve1+U_G1(I,t)
                                                        sume2=sume2+1
                                                        ri2=Ri(i,t)+ri2
                                                        DPU2=DPU(i,t)+dpu2
                                                  end if

                                          end if
                           end if
                           if ( EPP(I,t) .ge. 0.1 .and. EPP(I,t) .lt.max_dense)then
                                 if ( plain .and. ZZZ(I,1).gt.centerline+width/2) then
                                        massout1=massout1+(1-EP_G1(I,1))*1950*3.*3.!Volume_Unit*rho_p
                                end if

                                if ( plain .and. ZZZ(I,1).lt. centerline-width/2) then
                                        massout2=massout2+(1-EP_G1(I,1))*Volume_Unit*rho_p
                                end if
                          end if
                        end do
                end do
           end do
                write(1951,format9col) t, ve1/sume1, ve2/sume2, ri1/sume1, ri2/sume2, dpu1/sume1, dpu2/sume2, massout1, massout2
        end do
end subroutine


end module
