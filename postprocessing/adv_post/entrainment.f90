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
                logical:: inchannel, plain
                integer:: l1, l2, r1, r2, yi, centerline, I3

                routine="=entrainment/superelevation"
                description=" CALCULATE superelevation over time in the .25l to .75l region"
                datatype=" t  height from bottom height from top"
                filename='super.txt'
                call headerf(437, filename, simlabel, routine, DESCRIPTION,datatype)


                l1= int( lambda*.25/3.0)
                l2=int(lambda*.75/3.0)
                r1=450-width/2-amprat*lambda
                r2=450+width/2+amprat*lambda

                if (lambda .lt. 1) then 
                        l1=100
                        l2=150
                        r1=int((450-width/2+15)/3)
                        r2=int((450+width/2-15)/3)
                end if

                do t=2,timesteps 
                        superel=0
                         do rc=l1,l2
                           do zc=r1,r2
                                do yc= 20,YMAX-4
                                 call funijk( rc, yc, zc, I) 
                                  call where_edges(width, lambda, depth, XXX(I,1), YYY(I,1), ZZZ(I,1),slope,truetop,inchannel, plain, edge1, edge2)
                                 
                                   if ( EPP(I,t) .lt. 0.51 .and. EPP(I,t) .gt. 0.01) then 
                                   if ( (YYY(I,1)-truetop+3) .gt. superel)  then 
                                        XLOC=rc
                                        YLOC=yc
                                        ZLOC=zc
                                        superel=YYY(I,1)-truetop+3
                                        setop=truetop
                                        write(*,*) I, YYY(I,1), superel, truetop 
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

                                end do 
                           end do 
                        end do 
                        call funijk(int(XLOC), int(YLOC), int(ZLOC), I)
                        print*, "superelevation at ",t, superel, XLOC, YLOC, ZLOC, setop, EPP(I,t)
                       write(437,format5var) t, superel, superel-depth, sefromcenter, centerh                                        
                end do
                
                
                

            end subroutine 

end module entrainment
