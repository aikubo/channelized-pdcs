module entrainment 
        use parampost 
        use constants
        use formatmod
        use filehead
        use var_3d
        use maketopo

        contains 
                subroutine bulkent(EP_G1)

                implicit none 
                double precision, allocatable, intent(IN):: EP_G1(:,:)
                routine="=entrainment/bulkent"
                description=" CALCULATE NUMBER OF GRIDS WITH SPECIFIC VOLUME FRACTION OF GAS"
                datatype=" t  Whole current  Medium  Dense  (m^3)"
                filename='entrainment.txt'
                call headerf(701, filename, simlabel, routine, DESCRIPTION, datatype)


                !--CALCULATE NUMBER OF GRIDS WITH
                        !SPECIFIC VOLUME FRACTION OF GAS -------------!
                DO t=1,timesteps
                sum_p1 = 0.0
                sum_p2 = 0.0
                sum_p3 = 0.0
                  DO I=1,RMAX*ZMAX*YMAX
                     IF (EP_G1(I,t) < 0.9999999 .AND. EP_G1(I,t) .GT. 0.0000) THEN
                     sum_p1 = sum_p1 + 1.0
                     END IF

                     IF (EP_G1(I,t) <0.999 .AND. EP_G1(I,t) .GT. 0.0000) THEN
                     sum_p2 = sum_p2 + 1.0
                     END IF

                     IF (EP_G1(I,t) <0.99 .AND. EP_G1(I,t) .GT. 0.0000) THEN
                     sum_p3 = sum_p3 + 1.0
                     END IF
                  END DO

                  WRITE(701, formatent) t, sum_p1, sum_p2, sum_p3
                END DO
                !-CALCULATE NUMBER OF GRIDS WITH SPECIFIC VOLUME
                !FRACTION OF GAS -------------!
                end subroutine bulkent



                subroutine entcoef
                double precision:: d1, d2, d3, p0
                integer:: IJK1, IJK2
                double precision:: sumav
                double precision:: ue1, ue2, ue3, ueav
                double precision:: dj, mag
                double precision, dimension(2):: U, diso
                double precision, allocatable:: q_iso(:)
                ! --- find zslices --!
                write(*,*) "entering entcoef"
                allocate(q_iso(RMAX))
                p0=6.5
                
                do t=2,8
                   sumav=0
                
                !do zc=1,ZMAX
                zc=150   
                do i=3,RMAX-2
                        do j=3,YMAX-2
                            IJK1= 1 + (j-1) +(i-1)*(YMAX-1+1) +  (zc-1)*(YMAX-1+1)*(RMAX-1+1) 
                            IJK2= 1 + (j+1-1) +(i-1)*(YMAX-1+1) +  (zc-1)*(YMAX-1+1)*(RMAX-1+1) 
                            
                            if ( (EPP(IJK1,t) .lt. p0.and. EPP(IJK2,t) .gt. p0) .or. (EPP(IJK1,t).gt. p0 .and. EPP(IJK2,t).lt.p0) ) then
                                  q_iso(i) = j
                                  !  find velocity pointing in to q_iso 
                                  ! v=(ug, vg)
                                  sumav=sumav+1
                                 else
                                  q_iso(i)= 1000
                            end if
                              
                            
                            
                        end do 
                    END DO
                    
                    do i=3,RMAX-2
                
                       if (q_iso(i) .le. YMAX ) then  
                       dj=(q_iso(i+1)-q_iso(i-1))*3.
                       IJK1= 1 + (q_iso(i)-1) +(i-1)*(YMAX-1+1) +  (zc-1)*(YMAX-1+1)*(RMAX-1+1) 
                       mag=sqrt(6**2 + dj**2)
                       U = (/ U_G1(IJK1,t), V_G1(IJK1,t) /)
                       diso=(/  -dj/mag, 6.0/mag /)
                       Ue1=dot_product(U,diso)
                       !write(*,*) "velocity perp to isosurf", Ue1
                       ueav=ue1+ueav
                       end if                 

                     end do 
                     !print*, ueav/sumav
                !end do 
                     write(*,*) "entrainment over", p0, "isosurface:", ueav/sumav
                end do 
                
            end subroutine entcoef 

            subroutine superelevation 

                implicit none 
                double precision:: setop, sefromcenter, flow, superel, centerh, height, truetop, XLOC, YLOC, ZLOC
                double precision:: se_t, top, dense_superel, superel10, sum1, sum2, avgdense, avg10 
                logical:: inchannel, plain
                integer:: l1, l2, r1, r2, yi, centerline, I3, spillcount

                routine="=entrainment/superelevation"
                description=" CALCULATE superelevation over time in the .25l to .75l region"
                datatype=" t  max denseiso max.10iso avgdenseiso avg.10iso"
                filename='super.txt'
                call headerf(437, filename, simlabel, routine, DESCRIPTION,datatype)


                l1= int( lambda*.25/3.0)
                l2=int(lambda*.75/3.0)
                r1=int((450-width/2-amprat*lambda)/3)
                r2=int((450+width/2+amprat*lambda)/3)

                if (lambda .lt. 1) then 
                        l1=100
                        l2=150
                        r1=int((450-width/2-15)/3)
                        r2=int((450+width/2+15)/3)
                end if

                write(*,*) l1, l2, r1, r2
                do t=2,timesteps 
                spillcount=0
                        dense_superel=0
                        superel10=0
                        sum1=0
                        sum2=0  
                        avg10=0
                        avgdense=0
                         do rc=l1,l2
                           do zc=r1,r2
                                do yc= 20,YMAX-4
                                 call funijk( rc, yc, zc, I)
                                 !write(*,*) "Istart", I  
                             call edgesdose(width, lambda, depth, XXX(I,1), YYY(I,1), ZZZ(I,1),slope,top,inchannel, plain)

                                if ( EPP(I,t) .lt. 1 .and. EPP(I,t) .gt. 0.01) then
                                        if (inchannel) then 
                                                avg10=avg10+YYY(I,1)-top+3 
                                                sum1=sum1+1 
                                  !      write(*,*) "Y", YYY(I,1) !-top+3
                                  !      write(*,*) "top", top
                                  !      write(*,*), "I", I 
                                        end if  
                                   if ( (YYY(I,1)-top+3) .gt. superel10) then
                                        XLOC=rc
                                        YLOC=yc
                                        ZLOC=zc
                                        superel10 =YYY(I,1)-top+3
                                   end if 
                                        
                               

                                   if ( EPP(I,t) .lt. 0.51 .and. EPP(I,t) .gt. 0.01) then
                                                avgdense=avgdense+YYY(I,1)-top+3
                                                sum2=sum2+1
                                  !      write(*,*) "Y", YYY(I,1) !-top+3
                                  !      write(*,*) "top", top
                                  !      write(*,*), "I", I  
                                   if ( (YYY(I,1)-top+3) .gt. dense_superel)  then 
                                        XLOC=rc
                                        YLOC=yc
                                        ZLOC=zc
                                        dense_superel=YYY(I,1)-top+3
                                        setop=truetop
                                        !write(*,*) I, YYY(I,1), superel, truetop 
                                  ! find the centerline value 
                                       ! yi=int(truetop/3)
                                       ! centerline=int( (edge1+width/2)/3)
                                       ! flow=0.38
                                       ! do while ( flow .lt. .51 .and. yi .lt. YMAX) 
                                       !         call funijk(rc,yi,centerline,I3)
                                       !         centerh=(YYY(I3,1) -truetop)
                                       !         flow=EPP(I3,t)
                                       !         yi=yi+1
                                       ! end do 
                                       ! sefromcenter=superel-centerh                                                    
                                        
                                    
                                   end if 
                                  end if 
                                end if 


                                end do 
                           end do 
                        end do 
                        call funijk(int(XLOC), int(YLOC), int(ZLOC), I)
                        print*, "superelevation at ",t, dense_superel, superel10  
                       write(437,format5var) t, dense_superel, superel10, avgdense/sum2, avg10/sum1                                        
                end do
                
                
                

            end subroutine 

           subroutine exposure

           !calculates time over different temperatures!

           ! over 500
           ! over 200
           ! over 100 
           logical:: toploc, plainloc 

           ! area over TEMP for X seconds
           double precision:: Ao5005, Ao2005, Ao1005
           double precision:: Ao50015, Ao20015, Ao10015
           double precision:: Ao50030, Ao20030, Ao100300

            ! area over TEMPT for X seconds outside channel
           double precision:: oAo5005, oAo2005, oAo1005
           double precision:: oAo50015, oAo20015, oAo10015
           double precision:: oAo50030, oAo20030, oAo100300

           !whole domain record of time over temp (for all timesteps) 

           double precision, allocatable:: To500(:), To200(:), To100(:)

           routine="=entrainment/exposure"
           description="Area over 100, 200, 500 C for 5, 15, 30s "
           datatype="rows are exposure times, columns are temperatures(100,200,500)"
           filename='exposure.txt'
           call headerf(467, filename, simlabel, routine, DESCRIPTION,datatype)

           routine="=entrainment/exposure"
           description="Area over 100, 200, 500 C for 5, 15, 30s OUTSIDE CHANNEL"
           datatype="rows are exposure times, columns are temperatures(100,200,500)"
           filename='exposure_outside.txt'
           call headerf(468, filename, simlabel, routine, DESCRIPTION,datatype)

           allocate(To500(length1))
           allocate(To200(length1))
           allocate(To100(length1)) 
           !open(7989, file="To100.txt")
          do t=2,timesteps
                DO i=1,length1 
                        if (T_G1(I,t) .ge. 100+273 .and. T_G1(I,t-1) .ge. 100+273) then 
                                To100(i)=To100(i)+5
                        end if  
                        if (T_G1(I,t) .ge. 200+273 .and. T_G1(I,t-1) .ge. 200+273) then 
                                      To200(i)=To200(i)+5
                        end if

                       if (T_G1(I,t) .ge. 500+273 .and. T_G1(I,t-1) .ge. 500+273) then
                                To500(i)=To500(i)+5
                       end if   
                        
                end do
         end do 

         do rc=3,RMAX-2
         do yc=3,YMAX-2
         do zc=3,ZMAX-2 
                call funijk(rc,yc,zc,I)
                call iftop(I, toploc, plainloc)

                if (toploc) then  
                if (To100(I) .ge. 5) then 
                        Ao1005=Ao1005+9
                        if (To100(I) .ge. 15) Ao10015=Ao10015+9
                        if (To100(I) .ge. 30) Ao10030=Ao10030+9
                end if 
        
                if (To200(I) .ge. 5) then 
                                Ao2005=Ao2005+9
                                if (To200(I) .ge. 15) Ao20015=Ao20015+9
                                if (To200(I) .ge. 30) Ao20030=Ao20030+9
                end if 
                 
               if (To500(I) .ge. 5) then 
                                        Ao5005=Ao5005+9
                                        if (To500(I) .ge. 15) Ao50015=Ao50015+9
                                        if (To500(I) .ge. 30) Ao50030=Ao50030+9
                end if 
                end if 

          end do 
          end do 
          end do 

        write(*,*) sum(To200)/length1
           
        !do I=1,length1 
        !       write(7989, format4var) To500(I), XXX(I,1), YYY(I,1), ZZZ(I,1) 
        !end do         
        write(*,*) "writing area" 
        write(467, formatexp) Ao1005, Ao2005, Ao5005 
        write(467, formatexp) Ao10015, Ao20015, Ao50015 
        write(467, formatexp) Ao10030, Ao20030, Ao50030
        
       do rc=3,RMAX-2
         do yc=3,YMAX-2
         do zc=3,ZMAX-2
                call funijk(rc,yc,zc,I)
                call iftop(I, toploc, plainloc)
               
                if (plainloc) then

                if (To100(I) .ge. 5) then
                        oAo1005=oAo1005+9
                        if (To100(I) .ge. 15) oAo10015=oAo10015+9
                        if (To100(I) .ge. 30) oAo10030=oAo10030+9
                end if

                if (To200(I) .ge. 5) then        
                                oAo2005=oAo2005+9
                                if (To200(I) .ge. 15) oAo20015=oAo20015+9
                                if (To200(I) .ge. 30) oAo20030=oAo20030+9
                end if

               if (To500(I) .ge. 5) then
                                        oAo5005=oAo5005+9
                                        if (To500(I) .ge. 15) oAo50015=oAo50015+9
                                        if (To500(I) .ge. 30) oAo50030=oAo50030+9
                end if                

               end if

          end do
          end do
          end do
        write(*,*) "writing outside area"
        write(468, formatexp) oAo1005, oAo2005, oAo5005
        write(468, formatexp) oAo10015, oAo20015,oAo50015
        write(468, formatexp) oAo10030, oAo20030, oAo50030



        end subroutine         
end module entrainment
