module findhead
use parampost
use formatmod
use constants
use maketopo
use filehead
        contains 

        subroutine isosurf(width, lambda, averagehead)
!-----------------------------------------------------------------------!
! Written by AKubo September 2019 
! 
!  isosurf writes out 3 files currenthead.txt, nose.txt, and froude.txt
! it takes width, and lambda in form double precision 
! and sintrue which is a logical as its inputs 
! 
! it finds the isosurface of 6-7 -log(vol fraction) for all the width
! in the channel 
!
! then it finds the head by looking for the last slope change in the    
!   isosurface which it selects as the top of the head
!       
! then it calculates the average velocity, temperature, and volume frac
! within the head of thecurrent 
!
! The Froude Number is calculated as Fr = U/sqrt(gstar*H)
! where gstar is min( gravity*delta_rho/rho_dry, gravity*delta_rho/rho_c)
!
! Currenthead.txt::  t, endofhead, head(1), head(2)
! Nose.txt :: t, location in width, endofhead xxx
! Froude.txt :: t, avgU, avgEP, avgT, Fr, End of head, width of head, height of
! head
!
!
!-----------------------------------------------------------------------!
                implicit none 
                double precision, intent(IN):: width, lambda 
                double precision, intent(Out):: averagehead
               ! local variables ! 
                integer:: countslope
                double precision:: whatsign, currentsign
                double precision, allocatable:: isosurface(:,:,:)
                integer :: NUMSLOPE
                double precision, dimension(:):: head(2)
                double precision:: endofhead, nose
                double precision:: VOLFR, iso1, iso5, iso3, iso7, iso6, height
                double precision:: hill, slope, dx, clearance, pastyyy, pastxxx
                integer:: Q, K, nloc
                integer, allocatable:: noseloc(:)
                integer::traces
                integer:: X
                double precision:: ztrace, dh, widthofhead 
                double precision:: Usum, tsum, avgt, EPsum, sum1, avgEP, avgU

                traces= int(width/3)+1

                allocate(isosurface(1200, 4, 304))
                allocate(noseloc(304))
                
                !width=201
                slope=0.18
                dx=3.0
                clearance=50.0

               
               
                !print*, traces

                iso1=1.0
                iso6=6.0
                iso5=5.0
                iso3=3.0
                iso7=7.0
                !open(900, file='head.txt')
                routine="=findhead/isosurf"
                description="Calculate head height, width, and average U_G, T_G, EP_G"
                datatype=" t   AvgU - AvgEP - AvgT - Froude - Nose X - Width - Height"
                filename='froude.txt'
                call headerf(9001, filename, simlabel, routine, DESCRIPTION, datatype)

                description="Calculate head height, width, and average U_G, T_G, EP_G"
                datatype=" t  Q  Nose of Current X Loc"
                filename='nose.txt'
                call headerf(9002, filename, simlabel, routine, DESCRIPTION, datatype)



                averagehead = 0.0
                !write(900, *) "volfr    ", "xxx ", "yyy ", "hill        ", "yyy-hill    "
                !t=timefind
                print*, 'entering first do'
                
                
                do t=2,timesteps
                !do Q=1,traces
                pastXXX=0.0
                pastYYY=0.0

                
                DO I=1,length1 
                    IF (lambda .ne. 0.0) then
                    ztrace= lambda*.15*(sind(360*(XXX(I,1)/lambda)))+450
                    else
                    ztrace=450 
                    end if 


                    !print*, ztrace
                    IF( ZZZ(I,1) .GT. ztrace-width/2 & 
                        .and. ZZZ(I,1) .lt.ztrace+width/2 ) THEN
                    VOLFR=-(LOG10(1-EP_G1(I,t)+1e-14))
                    Q= int(ZZZ(I,1)/3.)-115
                   
                    IF( VOLFR .lT. iso7 .and. VOLFR .gt. iso6) THEN
                 !       print*, 'writing'
                        hill=slope*dx*(RMAX-(XXX(I,1)/dx)) +clearance -depth
                        height=YYY(I,1)-hill
                        dh=(pastYYY-height)/(pastXXX-XXX(I,1))
                        K=INT(XXX(I,1))
                        if (pastXXX .eq. XXX(I,1)) then 
                                if (pastYYY .lt. YYY(I,1)) then 
               !                 print*, VOLFRi
                               ! print*, Q, K 
                                isosurface(K,1,Q)= VOLFR
                                isosurface(K,2,Q)= XXX(I,1)
                                isosurface(K,3,Q)= height
                                isosurface(K,4,Q)= dh
                         !       write(900, format6var) ZZZ(I,1), VOLFR, XXX(I,1), YYY(I,1),  height, (pastYYY-height)/(pastXXX-XXX(I,1))
                                pastXXX=XXX(I,1)
                                pastYYY=YYY(I,1)-hill
                                end if 
                        else
                                !print*, Q, K
                                isosurface(K,1,Q)= VOLFR
                                isosurface(K,2,Q)= XXX(I,1)
                                isosurface(K,3,Q)= height
                                isosurface(K,4,Q)= dh
                         !       write(900, format6var) ZZZ(I,1), VOLFR, XXX(I,1), YYY(I,1), height, (pastYYY-height)/(pastXXX-XXX(I,1))
                                pastXXX=XXX(I,1)
                                pastYYY=YYY(I,1)-hill

                        end if 

                    end if 
                    end if 

              !  end do
              end do 

              !---------------------- find dip in isosurface--------------!

               ! count number of times the slope changes 
        
                
                NUMSLOPE=1
               
                head(1)=0
                head(2)=0
                endofhead=0

                do Q=1,traces
                   countslope=0 
                   do I=1,1200
                        currentsign= isosurface(I,4,Q)
                        whatsign = dsign(isosurface(I,4,Q), isosurface(I-1,4,Q))
                        if ( currentsign .NE. whatsign) then 
                                countslope= countslope +1 
                        end if 
                   end do
 
                    do I=1,1200
                        currentsign= isosurface(I,4,Q)
                        whatsign = dsign(isosurface(I,4,Q), isosurface(I-1,4,Q))
                        if ( currentsign .NE. whatsign) then
                                countslope= countslope -1
                  !              print*, countslope
                        if (countslope .EQ. NUMSLOPE) then 
                  !              print*, isosurface(I,2,Q), isosurface(I,3,Q)
                                head(1)= head(1)+isosurface(I,2,Q)
                                head(2)= head(2)+ isosurface(I,3,Q)       
                        end if
                        end if
                     end do
     
                      !print*, maxloc(isosurface(:,2,Q)) 
                      !print*, Q
                      noseloc=maxloc(isosurface(1:K,2,Q))
                      ! X=real(isosurface(1:1200,2,Q))
                      !print*,noseloc                      
                      ! noseloc= maxloc(X)
                      !nloc=INT(noseloc(Q))
                      ! nose=nose+isosurface(nloc,3,Q)
                       endofhead=endofhead+(maxval(isosurface(:,2,Q)))  
                       
                       write(9002,*) t, Q, maxval(isosurface(:,2,Q))

                end do 
                       endofhead=endofhead/traces
                       head(1)=head(1)/traces
                       head(2)=head(2)/traces 
                       !nose=nose/traces
                       
                       widthofhead= (endofhead-head(1))*(2.0) 
                      ! write(9000,*) t, endofhead, head(1), head(2)                         
                       print*, "End//Width /height of head"
                       print*, endofhead, widthofhead, head(2)
                        averagehead=averagehead+head(2)

                ! find average density and velocity in the head! 
                sum1=0
                Usum=0
                EPsum=0 
                Tsum=0 
                
                do I=1,length1

                  if ( XXX(I,1) .gt. endofhead-2*widthofhead .and. XXX(I,1) .lt. endofhead) then 
                         VOLFR=-(LOG10(1-EP_G1(I,t)+1e-14))
                        ! print*, VOLFR
                    IF ( VOLFR .gt. iso1 .and. VOLFR .lt. iso7) then      
                         sum1=sum1+1
                       !  print*, sum1
                         Usum= Usum+ U_G1(I,t)
                         Tsum=tsum+T_G1(I,t)
                         EPsum=EPsum+EP_G1(I,t)
                       !  print*, usum, epsum
                     end if 
                  end if 

                end do 
 
                avgU= Usum/sum1
                avgEP= EPsum/sum1
                avgT= Tsum/sum1
                print*, "average velocity and volume fraction"
                print*, avgU, avgEP, avgT
                rho_c=rho_p*(1-avgEP)+(P_const/(R_dryair*avgT))*(avgEP) 
                delta_rho= abs(rho_c - rho_dry)  
                !print*, delta_rho       
                gstar1=gravity*delta_rho/rho_dry
                gstar2=(gravity*delta_rho/rho_c) 
                
                gstar=min(gstar1, gstar2)


                froude= avgU/(sqrt(gstar*head(2)))
                print*, "Froude number"
                print*, froude
                
                write(9001,format8col) t, avgU, avgEP, avgT, froude, endofhead, widthofhead, head(2)
                K=1
                end do 

                averagehead= averagehead/(timesteps-1)
               
        end subroutine

end module 
