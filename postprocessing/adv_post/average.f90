module averageit
USE parampost
USE constants
use formatmod
use filehead
use massdist
contains
SUBROUTINE AVERAGE_ALL

IMPLICIT NONE
double precision:: avgr, avgr2, avgr3, rc, mt, avgEP, avgEP2, avgEP3
routine="averageit.mod/average_all"
description=" Average of EPP 0 to 6.5"
datatype=" t EP_G Rho  T_G   U_G   V_G   W_G   U_S1   DPU"
filename='average_all.txt'
call headerf(887, filename, simlabel, routine, DESCRIPTION, datatype)


filename='average_medium.txt'
description='Average of densities between .5 and 2'

call headerf(888, filename, simlabel, routine, DESCRIPTION, datatype)


filename='average_dense.txt'
description='Average of densities between 0 and .5'

call headerf(889, filename, simlabel, routine, DESCRIPTION, datatype)


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
avgr=0
avgr2=0
avgr3=0
avgEP=0
avgEP2=0
avgEP3=0

do I= 2, length1

        ! whole current, 0.001 to 6.5
        IF (EPP(I,t) .Gt. min_dense .and. EPP(I,t) .lt. max_dilute) THEN
               sum_1 = sum_1 +1
               avgt = T_G1(I,t) + avgt
               avgu = U_G1(I,t) + avgu
               avgv = V_G1(I,t) + avgv
               avgw = W_G1(I,t) + avgw
               avgus = U_S1(I,t) + avgus
               avgdpu = DPU(I,t) + avgdpu
               avgEP= EPP(I,t) + avgEP
                call density(I,t,rc,mt)
                avgr=rc+avgr


        END IF

        ! Dense, 0.001 to 0.51
        IF (EPP(I,t) .Gt. min_dense .and. EPP(I,t) .lt. max_dense) THEN
               sum_2 = sum_2 +1
               avgt2 = T_G1(I,t) + avgt2
               avgu2 = U_G1(I,t) + avgu2
               avgv2 = V_G1(I,t) + avgv2
               avgw2 = W_G1(I,t) + avgw2
               avgus2 = U_S1(I,t) + avgus2
               avgdpu2 = dpu(I,t) + avgdpu2
               avgEP2= EPP(I,t) + avgEP2
                call density(I,t,rc,mt)
                avgr2=rc+avgr2



        END IF

        ! medium, 0.51 to 2
        IF (EPP(I,t) .Gt. max_dense .and. EPP(I,t) .lt. min_dilute)  THEN
               sum_3 = sum_3 +1
               avgt3 = T_G1(I,t) + avgt3
               avgu3 = U_G1(I,t) + avgu3
               avgv3 = V_G1(I,t) + avgv3
               avgw3 = W_G1(I,t) + avgw3
               avgus3 = U_S1(I,t) + avgus3
               avgdpu3 = dpu(I,t) + avgdpu3
               avgEP3= EPP(I,t) + avgEP3
                call density(I,t,rc,mt)
                avgr3=rc+avgr3


        END IF
END DO

     print*, "writing average"

     ! bulk 
     WRITE(887, formatavg) t, avgEP/sum_1, avgr/sum_1, avgt/sum_1, avgu/sum_1, avgv/sum_1, avgw/sum_1, avgus/sum_1,  avgdpu/sum_1
     
     ! med 
      Write (888, formatavg) t, avgEP3/sum_3, avgr3/sum_3, avgt3/sum_3, avgu3/sum_3, avgv3/sum_3,avgw3/sum_3, avgus3/sum_3, avgdpu2/sum_2
     
     ! dense
       write(889, formatavg) t, avgEP2/sum_2, avgr2/sum_2, avgt2/sum_2, avgu2/sum_2, avgv2/sum_2, avgw2/sum_2, avgus2/sum_2, avgdpu3/sum_3

END DO
RETURN

END SUBROUTINE AVERAGE_ALL


end module
