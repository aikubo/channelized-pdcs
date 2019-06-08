PROGRAM additional

!updated as of 4/8/2019 by AK 

IMPLICIT NONE

INTEGER :: t1,t2, clock_rate, clock_max
CHARACTER(LEN=1) :: junk
CHARACTER(LEN=10) :: str_c
character(LEN=10) :: x1
INTEGER:: MAX_REC = 1e9
INTEGER:: length1,count1,num_open,sum1,sum2
INTEGER:: ios, int_temp,int_check,int_pos1,int_min1,int_pos2,int_min2
DOUBLE PRECISION:: infinity = 1e30
INTEGER::yc,YMAX,I,J,K,IMAX,JMAX,KMAX,timesteps,RMAX,THMAX,ZMAX,rc,zc,tc,t,I_yp1,I_ym1,I_zp1,I_zm1,I_xp1,I_xm1,temp_rc
INTEGER::write_size,write_end,loop_open,fid_temp,fid_EP_P,fid_EP_G,fid_U, fid_ISO6,fid_GRAD4pt, fid_GRADsize,fid_GradV,fid_GradE  
INTEGER::fid_EP_G_t,fid_U_t,fid_ISO3,fid_Ri,fid_ROP1,fid_Dot, fid_dpu,fid_dpv
INTEGER:: fide, fidy, fidw
INTEGER::Z_minus,Z_plus,X_minus,Y_plus,Z_total,I_local

DOUBLE PRECISION,ALLOCATABLE::EP_P(:,:,:),Iso_6(:,:,:)
DOUBLE PRECISION,ALLOCATABLE::Iso_3(:,:,:),four_point_Iso3(:,:,:),four_point(:,:,:)
DOUBLE PRECISION, ALLOCATABLE :: T_G(:,:,:),U_G(:,:,:), VEL_6(:,:,:),VEL_3(:,:,:),VEL_ALL(:,:,:), VEL_temp(:,:), VEL_temp2(:,:), Richardson(:,:,:)
DOUBLE PRECISION, ALLOCATABLE :: Ri_Dilute(:,:,:), Ri_Dense(:,:,:),char_dense(:), char_dilute(:),VEL_DENSE(:,:), VEL_DILUTE(:,:)


DOUBLE PRECISION, ALLOCATABLE ::topo2(:),topography(:),EP_G1(:,:),XXX(:,:),YYY(:,:),ZZZ(:,:)
DOUBLE PRECISION, ALLOCATABLE :: T_G1(:,:), V_G1(:,:),U_G1(:,:),W_G1(:,:),T_S1(:,:),C_PG(:,:),C_PS1(:,:),C_PS2(:,:)
DOUBLE PRECISION, ALLOCATABLE :: ROP_S1(:,:), U_S1(:,:), SHUY(:,:), SHWY(:,:), V_S1(:,:)

INTEGER, ALLOCATABLE::Location_I(:,:)

DOUBLE PRECISION, ALLOCATABLE :: XX(:,:,:),YY(:,:,:),ZZ(:,:,:),channel_topo(:,:)
DOUBLE PRECISION, ALLOCATABLE :: DY(:),y(:),x(:),theta(:),z(:),DX(:),DTH(:),DZ(:),GZ(:)
DOUBLE PRECISION:: y_boundary,sum_p1, sum_p2, sum_p3, sum_p4,sum_mass,sum_E1,sum_E2,sum_EG
DOUBLE PRECISION:: P_const, R_vapor, R_dryair,char_length, Reynolds_N,rho_g,mu_g,rho_dry, rho_p,T_amb
DOUBLE PRECISION:: max_mag, current_density,top,bottom, max_dilute, min_dilute, max_dense, min_dense
DOUBLE PRECISION:: initial_ep_g,ROP1,ROP2,initial_vel,initial_temp,Area_flux,Gas_flux,Solid_flux,gravity,temp_val,local_vel
DOUBLE PRECISION::c_pos1, c_pos2, c_min1, c_min2, delta_V1, delta_V3, shear_v,delta_rho, Ri
DOUBLE PRECISION::Gas_Volume(1,5),Volume_Unit,Energy_In_G, CP_Go, Energy_In_S1,CP_S1o, Energy_In_S2, CP_S2o
DOUBLE PRECISION::mag_grad,norm_grad(1,3),temp_dot

DOUBLE PRECISION:: tmass, chmass, chmassd, inchannelw, inchanneld, dpu, dpv
REAL:: M
INTEGER:: ind1, edge1, edge2, width, depth, bins, fid_shear
DOUBLE PRECISION:: D, U0, ROP_0, gstar, Hstar, stokest, stokesv
DOUBLE PRECISION:: avgt, avgt2, avgt3, avgu, avgu2, avgu3, avgv, avgv2, avgv3, avgw, avgw2, avgw3, avgus, avgus2, avgus3, sum_1, sum_2, sum_3
DOUBLE PRECISION:: avgdpu, avgdpu3, avgdpu2


CALL SYSTEM_CLOCK(t1, clock_rate, clock_max )
print *, t1, clock_rate, clock_max

!------------OPEN the binary files-----------!
OPEN(100,FILE='EP_G',form='unformatted')
OPEN(101,FILE='T_G',form='unformatted')
OPEN(102,FILE='U_G',form='unformatted')
OPEN(103,FILE='V_G',form='unformatted')
OPEN(104,FILE='W_G',form='unformatted')

!OPEN(120, FILE='EPG.txt', FORM='FORMATTED')
!OPEN(121, FILE='TG.txt', FORM='FORMATTED')

!OPEN(170, FILE = 'SH_U_Y', form = 'unformatted')
!OPEN(180, FILE = 'SH_W_Y', form = 'unformatted')
!OPEN(270, FILE = 'SHUY', form = 'formatted')
!OPEN(280, FILE = 'SHWY', form = 'formatted')

OPEN(108,FILE='T_S1',form='unformatted')
OPEN(109,FILE='V_S1',form='unformatted')
OPEN(110,FILE='ROP_S1',form='unformatted')
OPEN(111,FILE='U_S1',form='unformatted')
!------------OPEN the binary files-----------!

!------------OPEN the topography files-------!
OPEN(600,FILE='topography',form='formatted')
OPEN(601,FILE='topo2',form='formatted')
OPEN(602, FILE='topo_sin_20_l400_w50')
!------------OPEN the topography files-------!

! Values are LOG Volume Fraction of Particles EP_P
!-------- Boundaries for Gradient Calculations -----------!
max_dense   = 2.5
min_dense   = 1.5
max_dilute  = 6.5
min_dilute  = 5.5
!-------- Boundaries for Gradient Calculations -----------!

!--------------------------- Constants ------------------------------------------!
Volume_Unit = 2.*2.*2.  !From your 3D grid dx, dy, dz
gravity = 9.81 !m^2/s
P_const = 1.0e5 !Pa
R_vapor = 461.5 !J/kg K
R_dryair = 287.058 !J kg/K
T_amb    = 273.0 !K
rho_dry  = P_const/(R_dryair*T_amb)  !kg/m**3
char_length = 20.0
mu_g        = 2.0e-5 !Pa s
rho_p       = 2500.0 !kg/m**3
!--------------------------- Constants ------------------------------------------!



OPEN(38214,FILE = 'Current_Thermal_E')
OPEN(382141,FILE = 'Inflow_Thermal_E')

OPEN(603,FILE='Initial_Fluxes.txt')
OPEN(321,FILE='Gas_Mass_1e-7')
OPEN(322,FILE='Gas_Mass_1e-6')
OPEN(323,FILE='Gas_Mass_1e-5')
OPEN(324,FILE='Gas_Mass_1e-4')
OPEN(325,FILE='Gas_Mass_1e-3')
Gas_Volume(1,1)=1.0 - 1.0e-7
Gas_Volume(1,2)=1.0 - 1.0e-6
Gas_Volume(1,3)=1.0 - 1.0e-5
Gas_Volume(1,4)=1.0 - 1.0e-4
Gas_Volume(1,5)=1.0 - 1.0e-3

!print *, Gas_Volume(1,1:5)
! --------- Initial Conditions of Mass Flux --------------!
! Get from mfix.dat and input according to run
!updated by AK 11/17
initial_ep_g  = 0.9
initial_temp  = 800.0
ROP1          = 195.0                            !ep_p1*rho_p --> kg/m**3
!ROP2          = 300.0                            !ep_p2*rho_p --> kg/m**3
initial_vel   = sqrt(10.0**2+0.0**2+0.0**2)      !m/s
Area_flux     = abs((85-75)*(305-295))  !m**2

CP_Go         = 2294.11                        ! J/(kg K)
CP_S1o        = 2972.68                        ! J/(kg K)
CP_S2o        = 2548.01                        ! J/(kg K)

print *,"Initial Velocity", initial_vel

Gas_flux     = initial_ep_g*(P_const/(R_vapor*initial_temp))*Area_flux*initial_vel !kg/s
Solid_flux   = (ROP1)*Area_flux*initial_vel   !kg/s

WRITE(603,*) "initial vel ", initial_vel
WRITE(603,*) "area flux ", Area_flux
WRITE(603,*) "Gas Flux ", Gas_flux, "kg/s"
WRITE(603,*) "Solid Flux ", Solid_flux, "kg/s"
rho_p = 1950
D = 5e-5
!stokesv = (2/9)*(rho_p-rho_dry)*gravity*(D**2)/mu_g
width = 24
edge1 = (300/2)-(width/2)
edge2 = ((300/2)+(width/2))
depth = 18
u0 = 10.0
ROP_0 = 0.10
gstar = gravity !ROP_0*gravity*(rho_p/rho_dry)
Hstar = (u0*u0)/gstar
stokesv =(2/9)*(rho_p-rho_dry)*gravity*D*D/mu_g
stokest = Hstar/stokesv

print*, stokesv
print*, Hstar
print*, stokest
tmass = 0
chmass= 0
chmassd = 0
M  = 20.0

! --------- Initial Conditions of Mass Flux --------------!

!-------- Set Size, Timesteps, and write size ------------!
timesteps=9
RMAX=404
ZMAX=152
YMAX=204
length1 = RMAX*ZMAX*YMAX
write_size = 4  !Number of timesteps to write out for loc files used in OPENDX
loop_open = ceiling(real(timesteps)/real(write_size)) !Round up to create number of loc files
print *, loop_open
!-------- Set Size, Timesteps, and write size ------------!

!------------------------------ OPEN Location Files -----------------------------!
!str_c = '(I1)' ! Make string format of integer with size 1
!DO t=1,loop_open ! Loop through to create to correct number of files
 ! write(x1,str_c) t  ! Convert the loop variable (counter) to string

  !Open T_G files (200)
  !num_open = 200+t
  !OPEN(num_open,FILE='T_G_loc'//trim(x1)//'.txt',form = 'formatted')

  !Open EP_G files (300)
 ! num_open = 300+t
  !OPEN(num_open,FILE='EP_G_loc'//trim(x1)//'.txt',form = 'formatted')

  !Open EP_P files (400)
 ! num_open = 400+t
  !OPEN(num_open,FILE='EP_P_loc'//trim(x1)//'.txt',form = 'formatted')

  !Open U_G files (500)
  !num_open = 500+t
  !OPEN(num_open,FILE='U_G_loc'//trim(x1)//'.txt',form = 'formatted')

!end do
!------------------------------ OPEN Location Files -----------------------------!




!------------------------ OPEN Gradient Location Files --------------------------!

OPEN(701,FILE='EP_G_sum1', form='formatted')
OPEN(702,FILE='EP_G_sum2', form='formatted')
OPEN(703,FILE='EP_G_sum3', form='formatted')

sum_p1 = 0.0 
sum_p2 = 0.0 
sum_p3 = 0.0 
sum_p4 = 0.0 
 
!----------------------Allocate the conversion variables-------------------------!
ALLOCATE( channel_topo(RMAX-4,ZMAX-2))
ALLOCATE( EP_G1(length1,timesteps))
ALLOCATE( T_G1(length1,timesteps))
ALLOCATE( V_G1(length1,timesteps))
ALLOCATE( U_G1(length1,timesteps))
ALLOCATE( W_G1(length1,timesteps))
ALLOCATE( U_S1(length1, timesteps))

!ALLOCATE(SHWY(length1,timesteps))
!ALLOCATE(SHUY(length1,timesteps))
ALLOCATE( ROP_S1(length1,timesteps))
ALLOCATE(V_S1(length1, timesteps))

ALLOCATE( XXX(length1,1))
ALLOCATE( topography(length1))
ALLOCATE( topo2(length1))
ALLOCATE( ZZZ(length1,1))
ALLOCATE( YYY(length1,1))
ALLOCATE( XX(RMAX,YMAX,ZMAX))
ALLOCATE( YY(RMAX,YMAX,ZMAX))
ALLOCATE( ZZ(RMAX,YMAX,ZMAX))
ALLOCATE( x(RMAX))
ALLOCATE( y(YMAX))
ALLOCATE( z(ZMAX))
ALLOCATE( DX(RMAX))
ALLOCATE( DY(YMAX))
ALLOCATE( DZ(ZMAX))
!----------------------Allocate the conversion variables-------------------------!

!----------------------Allocate the Gradient variables-------------------------!
ALLOCATE(EP_P(length1,4,timesteps))
ALLOCATE(T_G(length1,4,timesteps))
ALLOCATE(U_G(length1,6,timesteps))
ALLOCATE(Richardson(length1,5,timesteps))

ALLOCATE(Location_I(length1,timesteps))

ALLOCATE(Iso_6(length1,9,timesteps))
ALLOCATE(Iso_3(length1,9,timesteps))

ALLOCATE(four_point_Iso3(length1,11,timesteps))
ALLOCATE(four_point(length1,11,timesteps))

ALLOCATE(VEL_temp(length1,6))
ALLOCATE(VEL_temp2(length1,6))

ALLOCATE(VEL_6(RMAX,7,timesteps))
ALLOCATE(VEL_3(RMAX,7,timesteps))
ALLOCATE(VEL_ALL(RMAX,7,timesteps))

ALLOCATE(VEL_DILUTE(7,timesteps))
ALLOCATE(VEL_DENSE(7,timesteps))


ALLOCATE(char_dense(timesteps))
ALLOCATE(char_dilute(timesteps))

!ALLOCATE(dpu(length1, timesteps))
!ALLOCATE(dpv(length1, timesteps))
!----------------------Allocate the Gradient variables-------------------------!

!-------------------------------READ TOPOGRAPHY----------------------------------!
REWIND(602)
READ(602,*) channel_topo
!-------------------------------READ TOPOGRAPHY----------------------------------!

!------------------------ Create spatial deltas and distances -------------------!
DX(1)=2.0
x(1)=DX(1)
DO rc=2,RMAX
  DX(rc)=DX(rc-1)
  x(rc)=DX(rc)+x(rc-1)
END DO

DY(1)=2.0!0.375
y(1)=DY(1)
DO zc=2,YMAX
  DY(zc)=DY(zc-1)
  y(zc)=DY(zc)+y(zc-1)
END DO

DZ(1)=2.0
!z(1)=2240. !Z is in reverse compared to X & Y
DO zc=2,ZMAX
 DZ(zc)=DZ(zc-1)
 z(zc)=DY(zc)+x(zc-1)
END DO
!------------------------ Create spatial deltas and distances -------------------!

!------------------------------ Create grid matrices of length RMAX*ZMAX*YMAX ----------------------------!
I=1
DO zc=1,ZMAX
     DO rc=1,RMAX
          DO yc=1,YMAX
                XX(rc,yc,zc)=x(rc)
                XXX(I,1)=XX(rc,yc,zc)
                YY(rc,yc,zc)=y(yc)
                YYY(I,1)=YY(rc,yc,zc)
                ZZ(rc,yc,zc)=z(zc)
                ZZZ(I,1)=ZZ(rc,yc,zc)
                y_boundary= -0.0022*(x(rc)**3)+0.1082*(x(rc)**2)-1.8888*x(rc)+12.817
                y_boundary=0.0
                     IF (rc>2 .and. rc<RMAX-2) THEN
                         IF (zc>1 .and. zc<ZMAX-1) THEN
                                y_boundary=channel_topo(rc-2,zc-1)-2.*DY(1)
                         END IF
                     END IF
                topography(I)=y_boundary-y(yc)
                topo2(I)=y(yc)
                I=I+1
          END DO
     END DO
END DO
!------------------------------ Create grid matrices of length RMAX*ZMAX*YMAX ----------------------------!

!------------------------------ Read Binary and Set to Variable ----------------------------!
REWIND(100)
DO I=1,timesteps
     READ(100) EP_G1(:,I) ! Format is RMAX*YMAX*ZMAX by timesteps, so loop                         ! through timesteps
END DO

REWIND(101)
DO I=1,timesteps
     READ(101) T_G1(:,I)
END DO

REWIND(102)
DO I=1,timesteps
     READ(102) U_G1(:,I)
END DO

REWIND(103)
DO I=1,timesteps
     READ(103) V_G1(:,I)
END DO

REWIND(104)
DO I=1,timesteps
     READ(104) W_G1(:,I)
END DO

!REWIND(110)
!DO I =1,timesteps
!    READ(110) ROP_S1(:,I)
!END DO

!DO I =1,timesteps
!    READ(170) SHUY(:,I)
!END DO

!DO I =1,timesteps
!    READ(180) SHWY(:,I)
!END DO

!DO I =1,timesteps
!    READ(111) U_S1(:,I)
!END DO

!REWIND(109)
!DO I =1,timesteps
!    READ(109) V_S1(:,I)
!END DO

!REWIND 

!DO I = 1, timesteps 
!    READ(110) ROP_S1(:,I)
!END DO 
!------------------------------ Read Binary and Set to Variable ----------------------------!

!DO  t=1,timesteps
! fidy=3000+t
! fidw=3050+t
! fide=3100+t

!  DO I=1,RMAX*ZMAX*YMAX
        !WRITE(fidy, 400) SHUY(I,t),XXX(I,1),YYY(I,1),ZZZ(I,1)
        !WRITE(fidw, 400) SHWY(I,t),XXX(I,1),YYY(I,1),ZZZ(I,1)
!        WRITE(fide, 400) EP_G1(I,t),XXX(I,1),YYY(I,1),ZZZ(I,1)
!  end do 
!end do


!------------------- Write Variable and set to 3D variable for gradient calculation ------------------!
!print *, "Start writing 3D variables"
!DO I = 1,RMAX*ZMAX*YMAX
!        WRITE(600,400) topography(I),XXX(I,1),YYY(I,1),ZZZ(I,1)
!        WRITE(601,400) topo2(I),XXX(I,1),YYY(I,1),ZZZ(I,1)
!END DO
!END DO loop1




OPEN(443, file='dpuinchannel400.txt')
OPEN(444, file='dpuinchannel200.txt')
open(445, file='dpuinchannel600.txt')

DO t=1,timesteps
 DO I=1,length1
        dpu=rho_p*(1-EP_G1(I,t))*U_G1(I,t)*U_G1(I,t)
        !if (dpu .gt. 0.0) THEN 
        !print*, dpu
        !end if 
        IF ( XXX(I,1) .Eq. 400) THEN
           !print*, dpu
           bottom=(0.39)*2*(400-(XXX(I,1)/2))+4
           IF( YYY(I,1) .eq. 160) THEN
                  print*, dpu
                  write(443, 333) t, ZZZ(I,1), EP_G1(I,t), dpu
                 END IF
        END IF
        


 
        IF ( XXX(I,1) .Eq. 600) THEN
           !print*, dpu
           bottom=(0.39)*2*(400-(XXX(I,1)/2))+20-18
           IF( YYY(I,1) .eq. 82) THEN 
                  print*, dpu
                  write(445, 333) t, ZZZ(I,1), EP_G1(I,t), dpu
                 END IF
        END IF



        IF ( XXX(I,1) .Eq. 200) THEN
           !print*, dpu
           bottom=(0.36)*2*(400-(XXX(I,1)/2))+20-18 
           IF( YYY(I,1) .eq. 228) THEN !bottom .and. YYY(I,1) .lt. bottom+2) THEN
                  print*, dpu     
                  write(444, 333) t, ZZZ(I,1), EP_G1(I,t), dpu
                 END IF
        END IF
 END DO 

END DO 


!DO t=1,timesteps
!fid_shear = 3000+t
!--------------------- Searching entire volume but avoiding ghost cells and
!boundary cells -----------!
   !! DO rc=5,RMAX-4
     !    VEL_3(rc,1:7,t) = 0.0
      !   sum2=1
       ! DO zc=7,ZMAX-7
   !       DO yc=YMAX-4,4,-1
  !           I       = 1 + (yc-1) +(rc-1)*(YMAX-1+1) +(zc-1)*(YMAX-1+1)*(RMAX-1+1)
 !            I_yp1   = 1 + (yc+1-1) +(rc-1)*(YMAX-1+1) +(zc-1)*(YMAX-1+1)*(RMAX-1+1) !Cell above
!
    !         SHUY= (mu_g)*(U_G(I_yp1,1,t) - U_G(I,1,t))
     !        WRITE(fid_shear, 400) SHUY, XXX(I,1), YYY(I,1), ZZZ(I,1) 
     !     end do 
     !   end do 
    !end do 
!end do 


print *, "Program Complete"
CALL SYSTEM_CLOCK(t2, clock_rate, clock_max )
            print *, t2, clock_rate, clock_max
            print *, "Elapsed Timei = ", real(t2-t1)/real(clock_rate)/60.0, "minutes"

100 FORMAT(F22.12,3ES22.5,F22.12)
101 FORMAT(i7)
102 FORMAT(i7,1X(3ES22.5),1X,i7)
103 FORMAT(i7,1X(6ES22.5),1X,i7)
400 FORMAT(4F22.12)
401 FORMAT(4F22.12,1x,ES22.5)
300 FORMAT(6F22.12)
301 FORMAT(11F22.10)
302 FORMAT(8F22.10,ES22.7,7F22.10)
502 FORMAT(10F22.10)
308 FORMAT(9F22.12)
311 FORMAT(11F22.12)
802 FORMAT(i7,F22.5)
805 FORMAT(6F22.5,3i7)
806 FORMAT(7F22.5,3i7)
803 FORMAT(1X(5ES22.5),1X(3F22.12))
407 FORMAT(7F22.12,2i7)
405 FORMAT(6F22.12)
403 FORMAT(2F22.12)
333 format(I2,4F22.12)
END PROGRAM


