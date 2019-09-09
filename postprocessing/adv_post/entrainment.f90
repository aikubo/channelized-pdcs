module entrainment 
        use parampost 
        use constants
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

                  WRITE(701,formatent) t, sum_p1, sum_p2, sum_p3
                END DO
                !-CALCULATE NUMBER OF GRIDS WITH SPECIFIC VOLUME
                !FRACTION OF GAS -------------!
                end subroutine bulkent

end module entrainment
