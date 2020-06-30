module entrainment 
        use parampost 
        use constants
        use formatmod
        use filehead

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
                     IF (EP_G1(I,t) < 0.99999 .AND. EP_G1(I,t) .GT. 0.0000) THEN
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
                double precision:: ue1, ue2, ue3
                double precision:: dj, mag
                double precision, dimension(2):: U, diso
                double precision, allocatable:: q_iso(:)
                ! --- find zslices --!
                allocate(q_iso(IMAX))
                zc=KMAX/2 
                p0=max_dense
                
                do t=1,8
                    do i=1,IMAX
                        do j=1,JMAX
                            q_iso(i,j)=dble(0.0)
                            IJK1= 1 + (j-1) +(i-1)*(YMAX-1+1) +  (zc-1)*(YMAX-1+1)*(RMAX-1+1) 
                            IJK2= 1 + (j+1-1) +(i-1)*(YMAX-1+1) +  (zc-1)*(YMAX-1+1)*(RMAX-1+1) 
                            
                            if ( (EPP(IJK1,t) .lt. p0.and. EPP(IJK2,t) .gt. p0).or.
                             &           (EPP(IJK1,t).gt. p0 .and. EPP(IJK2,t).lt.p0) ) then
                                  q_iso(i) = j
                                  !  find velocity pointing in to q_iso 
                                  ! v=(ug, vg)
                            end if 
                            
                            
                        end do 
                    END DO
                    
                    do i=2,IMAX-1 
                       dj=q_iso(i-1)-q_iso(i+1)
                       IJK1= 1 + (q_iso(i)-1) +(i-1)*(YMAX-1+1) +  (zc-1)*(YMAX-1+1)*(RMAX-1+1) 
                       mag=sqrt(6**2 + dj**2)
                       U = (/ U_G1(IJK1,t), V_G(IJK1,t) /)
                       diso=(/  -dj/mag, 6.0/mag /)
                       Ue1=dot_product(U,diso)
                       write(*,*) Ue1
                     end do 
                end do 
                
            end subroutine 
end module entrainment
