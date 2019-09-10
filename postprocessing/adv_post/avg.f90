module avg 

use parampost
use constants 
use formatmod

contains 
        subroutine averageall
        implicit none 

        routine="avg/averageall"
        description="Calculate average U_G, T_G, U_S1, DPU"
        datatype=" t AvgT AvgU AvgW AvgV AvgU_S1 DPU"
        filename='average_all.txt'
     call headerf(888, filename, simlabel, routine, DESCRIPTION, datatype)

        filename='average_med.txt'
     call headerf(887, filename, simlabel, routine, DESCRIPTION, datatype)

        filename='average_dense.txt'
     call headerf(889, filename, simlabel, routine, DESCRIPTION, datatype)

        WRITE(888,formatavg) 1, 800.0, 10.0, 0.0, 0.0, 10.0
        WRITE(887,formatavg) 1, 800.0, 10.0, 0.0, 0.0, 10.0
        WRITE(889,formatavg) 1, 800.0, 10.0, 0.0, 0.0, 10.0


        do t= 2,timesteps
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

                do I= 1, length1
                        IF (EP_P(I,1,t) .Gt. min_dense .and. EP_P(I,1,t) .lt. max_dilute
                ) THEN
                               sum_1 = sum_1 +1
                               avgt = T_G(I,1,t) + avgt
                               avgu = U_G(I,1,t) + avgu
                               avgv = U_G(I,2,t) + avgv
                               avgw = U_G(I,3,t) + avgw
                               avgus = U_S1(I,t) + avgus
                               avgdpu = dpu(I,t) + avgdpu
                        END IF

                        IF (EP_P(I,1,t) .Gt. min_dense .and. EP_P(I,1,t) .lt. max_dense
                ) THEN
                               sum_2 = sum_2 +1
                               avgt2 = T_G(I,1,t) + avgt2
                               avgu2 = U_G(I,1,t) + avgu2
                               avgv2 = U_G(I,2,t) + avgv2
                               avgw2 = U_G(I,3,t) + avgw2
                               avgus2 = U_S1(I,t) + avgus2
                               avgdpu2 = dpu(I,t) + avgdpu2

                        END IF

                        IF (EP_P(I,1,t) .Gt. max_dense .and. EP_P(I,1,t) .lt. min_dilute
                ) THEN
                               sum_3 = sum_3 +1
                               avgt3 = T_G(I,1,t) + avgt3
                               avgu3 = U_G(I,1,t) + avgu3
                               avgv3 = U_G(I,2,t) + avgv3
                               avgw3 = U_G(I,3,t) + avgw3
                               avgus3 = U_S1(I,t) + avgus3
                               avgdpu3 = dpu(I,t) + avgdpu3
                        END IF
                END DO

                     WRITE( 888, formatavg) t, avgt/sum_1, avgu/sum_1, avgv/sum_1, avgw/sum_1, avgus/sum_1, avgdpu/sum_1
                     Write (887, formatavg) t, avgt3/sum_3, avgu3/sum_3, avgv3/sum_3,avgw3/sum_3, avgus3/sum_3, avgdpu2/sum_2
                     write(889, formatavg) t, avgt2/sum_2, avgu2/sum_2, avgv2/sum_2, avgw2/sum_2, avgus2/sum_2, avgdpu3/sum_3

                END DO
        end subroutine averageall 
end module avg
