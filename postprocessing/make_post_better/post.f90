PROGRAM KUBO_POST

! updated 4/7/2019 by AK  
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

DOUBLE PRECISION:: tmass, chmass, chmassd, inchannelw, inchanneld
REAL:: M
INTEGER:: ind1, edge1, edge2, width, depth, bins, fid_shear
DOUBLE PRECISION:: D, U0, ROP_0, gstar, Hstar, stokest, stokesv
DOUBLE PRECISION:: avgt, avgt2, avgt3, avgu, avgu2, avgu3, avgv, avgv2, avgv3, avgw, avgw2, avgw3, avgus, avgus2, avgus3, sum_1, sum_2, sum_3
DOUBLE PRECISION:: avgdpu, avgdpu3, avgdpu2
DOUBLE PRECISION, ALLOCATABLE:: dpu(:,:), dpv(:,:)

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
OPEN(602,FILE='topo_sin_20_l400_w50')
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


!-----------:------------- OPEN Gradient Location Files --------------------------!
  ! NOTE: If timesteps are greater than 50 this format will be an issue
print *, "Warning if timesteps ", timesteps, " is greater than 49 will have errors"
str_c = '(I2.2)'
DO t=1,timesteps
  write(x1,str_c) t

  !binary conversion by timestep
   
  !num_open=3000+t
  !OPEN(num_open, FILE='SHUY_t'//trim(x1)//'.txt')

  !num_open=3050+t
  !OPEN(num_open, FILE='SHWY_t'//trim(x1)//'.txt')

  !num_open=3100+t 
  !OPEN(num_open, FILE='EPG_t'//trim(x1)//'.txt')

  ! ------------- DILUTE PORTION OF CURRENT-----------------!
  num_open = 750+t
  OPEN(num_open,FILE='GRAD_ISO6_t'//trim(x1)//'.txt')   !Used in *.general file for OPENDX Simluation

  num_open = 800+t
  OPEN(num_open,FILE='GRAD_4_point_t'//trim(x1)//'.txt')  
  !Used in *.general file for OPENDX Simluation

  !num_open = 850+t
  !OPEN(num_open,FILE='GRAD_4_point_size_t'//trim(x1)//'.txt')

  num_open = 900+t
  OPEN(num_open,FILE='GRAD_Velocity_t'//trim(x1)//'.txt')
  !Used in *.general file for OPENDX Simluation

  !num_open = 950+t
  !OPEN(num_open,FILE='ROP_S1_t'//trim(x1)//'.txt')

  !num_open = 950+t
  !OPEN(num_open,FILE='Local_Location_t'//trim(x1)//'.txt')

  !num_open = 1000+t
  !OPEN(num_open,FILE=''//trim(x1)//'.txt')
  
  num_open = 1050+t
  OPEN(num_open,FILE='Dilute_Richardson_t'//trim(x1)//'.txt')

  num_open = 1450+t
  OPEN(num_open,FILE='Dilute_Dot_t'//trim(x1)//'.txt')
  
  num_open = 950+t
  OPEN(num_open,FILE='Dilute_Dot_v2_t'//trim(x1)//'.txt')

  ! ------------- DILUTE PORTION OF CURRENT-----------------!

  num_open = 1100+t
  OPEN(num_open,FILE='EP_P_t'//trim(x1)//'.txt')

  num_open = 1200+t
  OPEN(num_open,FILE='U_G_t'//trim(x1)//'.txt')

  num_open = 1250+t
  OPEN(num_open,FILE='T_G_t'//trim(x1)//'.txt')

  !num_open = 1300+t
  !OPEN(num_open,FILE='Average_Vel_t'//trim(x1)//'.txt')

  num_open = 1350+t
  OPEN(num_open,FILE='dpv_t'//trim(x1)//'.txt')

  num_open = 1400+t
  OPEN(num_open,FILE='dpu_t'//trim(x1)//'.txt')

  num_open = 1500+t
  OPEN(num_open,FILE='Richardson_t'//trim(x1)//'.txt')
 
  ! ------------- DENSE PORTION OF CURRENT-----------------!
  num_open = 1750+t
  OPEN(num_open,FILE='GRAD_ISO3_t'//trim(x1)//'.txt')

  num_open = 1800+t
  OPEN(num_open,FILE='GRAD_ISO3_4_point_t'//trim(x1)//'.txt')

  !num_open = 1850+t
  !OPEN(num_open,FILE='GRAD_ISO3_4_point_size_t'//trim(x1)//'.txt')

  num_open = 1900+t
  OPEN(num_open,FILE='GRAD_ISO3_Velocity_t'//trim(x1)//'.txt')

  !num_open = 1950+t
  !OPEN(num_open,FILE='GRAD_ISO3_Avg_Velocity_t'//trim(x1)//'.txt')
  
  num_open = 2050+t
  OPEN(num_open,FILE='Dense_Richardson_t'//trim(x1)//'.txt')
  
  num_open = 2100+t
  OPEN(num_open,FILE='Dense_Dot_t'//trim(x1)//'.txt')
  
  num_open = 1950+t
  OPEN(num_open,FILE='Dense_Dot_v2_t'//trim(x1)//'.txt')


  ! ------------- DENSE PORTION OF CURRENT-----------------!
END DO

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

ALLOCATE(dpu(length1, 4))
ALLOCATE(dpv(length1, 4))
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

REWIND(110)
DO I =1,timesteps
    READ(110) ROP_S1(:,I)
END DO

!DO I =1,timesteps
!    READ(170) SHUY(:,I)
!END DO

!DO I =1,timesteps
!    READ(180) SHWY(:,I)
!END DO

DO I =1,timesteps
    READ(111) U_S1(:,I)
END DO

REWIND(109)
DO I =1,timesteps
    READ(109) V_S1(:,I)
END DO

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
print *, "Start writing 3D variables"
DO I = 1,RMAX*ZMAX*YMAX
        WRITE(600,400) topography(I),XXX(I,1),YYY(I,1),ZZZ(I,1)
        WRITE(601,400) topo2(I),XXX(I,1),YYY(I,1),ZZZ(I,1)
END DO

!commented out 11/17 by AK, no T_S1
!loop1:DO t=1,timesteps
!   sum_E1 = 0.0
  ! sum_E2 = 0.0
 !  sum_EG = 0.0
  ! K      = 1
!loop2: DO I = 1, RMAX*ZMAX*YMAX
 !     IF (T_G1(I,t)/=0.0 .AND. EP_G1(I,t)/=1.0 .AND. C_PS1(I,t)<1e10) THEN
  !       sum_E1 = ROP_S1(I,t)*Volume_Unit*C_PS1(I,t)*T_S1(I,t)+sum_E1
!         sum_E2 = ROP_S2(I,t)*Volume_Unit*C_PS2(I,t)*T_S2(I,t)+sum_E2
        
   !      sum_EG = EP_G1(I,t)*(P_const/(R_vapor*T_G1(I,t)))*Volume_Unit*C_PG(I,t)*T_G1(I,t) + sum_EG
    !     K = K + 1

     !      IF (T_G1(I,t) .LE. initial_temp .AND. EP_G1(I,t)<(initial_ep_g+0.01) .AND. EP_G1(I,t)>(initial_ep_g-0.01)) WRITE(38211,102) t,T_G1(I,t),C_PG(I,t),EP_G1(I,t),I
    !       IF (T_S1(I,t) .LE. initial_temp .AND. ROP_S1(I,t)<ROP1 .AND.ROP_S1(I,t)>(ROP1-2)) WRITE(38212,102) t,T_S1(I,t),C_PS1(I,t),ROP_S1(I,t),I
!           IF (T_S2(I,t) .LE. initial_temp .AND. ROP_S2(I,t)<ROP2 .AND. ROP_S2(I,t)>(ROP2-2)) WRITE(38213,102) t,T_S2(I,t),C_PS2(I,t),ROP_S2(I,t),I

  !    END IF
  !     IF (EP_G1(I,t) == initial_ep_g .OR. ROP_S1(I,t) == ROP1 ) WRITE(38215,103) t, EP_G1(I,t), C_PG(I,t), ROP_S1(I,t),C_PS1(I,t), C_PS2(I,t),I
   !   END IF  
 ! END DO loop2 
   ! Energy_In_G  = (P_const/(R_vapor*initial_temp))*initial_ep_g*Area_flux*initial_vel*(t-1)*5*CP_Go*initial_temp
   ! Energy_In_S1 = ROP1*Area_flux*initial_vel*(t-1)*5*CP_S1o*initial_temp
   ! Energy_In_S2 = ROP2*Area_flux*initial_vel*(t-1)*5*CP_S2o*initial_temp

  !  WRITE(38214,102) t, sum_E1, sum_EG,(K-1)
 !   WRITE(382141,102) t,Energy_In_S1, Energy_In_S2, Energy_In_G, (K-1)

!END DO loop1




DO K = 1,5
  fid_temp = 320+K
DO t=1,timesteps
sum_mass = 0.0
   DO I = 1, RMAX*ZMAX*YMAX
     ! IF (EP_G1(I,t) < Gas_Volume(1,K) .AND. C_PS1(I,t)<1e10) THEN
      IF (EP_G1(I,t) < Gas_Volume(1,K)) THEN
           temp_val = EP_G1(I,t)*(P_const/(R_vapor*T_G1(I,t)))*40.0*40.0*7.0
         sum_mass = sum_mass + temp_val
      END IF
   END DO
WRITE(fid_temp,100) (real(t-1))*5, sum_mass, Gas_flux*(real(t-1))*5,Solid_flux*(real(t-1))*5, sum_mass/((Gas_flux*(real(t-1))*5)+Solid_flux*(real(t-1))*5)
END DO
END DO



DO t=1,timesteps
        fid_EP_P  = 1100+t
        fid_U     = 1200+t
       ! fid_ROP1    = 1350+t
       ! fid_ROP2    = 1400+t
        fid_temp    = 1250+t
       DO I=1,RMAX*ZMAX*YMAX
          !------------------ Volume Fraction of Gas or Particles ------------------!
          !WRITE(fid_EP_G,400) EP_G1(I,t),XXX(I,1),YYY(I,1),ZZZ(I,1)
          if (T_G1(I,t)==0.0 .OR. EP_G1(I,t) > 0.9999999) THEN ! Try to make sure not to calculate infinity densities or 
                                                               ! density for concentration of gas outside of the current
          current_density = 0.0
          else
          current_density = rho_p*(1-EP_G1(I,t))+(EP_G1(I,t))*(P_const/(R_vapor*T_G1(I,t)))
          end if

          !WRITE(fid_EP_G_t,401) EP_G1(I,t),XXX(I,1),YYY(I,1),ZZZ(I,1)
        
      !    WRITE(fid_ROP1,803) EP_G1(I,t),C_PG(I,t),ROP_S1(I,t),C_PS1(I,t),T_S1(I,t),XXX(I,1),YYY(I,1),ZZZ(I,1)       
          !WRITE(fid_ROP2,803) EP_G1(I,t),C_PG(I,t),ROP_S2(I,t),C_PS2(I,t),T_S2(I,t),XXX(I,1),YYY(I,1),ZZZ(I,1)       
          EP_P(I,1,t) = -LOG10(1-EP_G1(I,t)+1e-14)
          EP_P(I,2,t) = XXX(I,1)
          EP_P(I,3,t) = YYY(I,1)
          EP_P(I,4,t) = ZZZ(I,1)
          WRITE(fid_EP_P,400) EP_P(I,1:4,t)
          !------------------------ Temperature of Gas -----------------------------!
          T_G(I,1,t) = T_G1(I,t)          
          T_G(I,2,t) = XXX(I,1)
          T_G(I,3,t) = YYY(I,1)
          T_G(I,4,t) = ZZZ(I,1)
          WRITE(fid_temp,400) T_G(I,1:4,t)
          !------------------------ Velocity of Gas --------------------------------!
          U_G(I,1,t) = U_G1(I,t)          
          U_G(I,2,t) = V_G1(I,t)          
          U_G(I,3,t) = W_G1(I,t)          
          U_G(I,4,t) = XXX(I,1)
          U_G(I,5,t) = YYY(I,1)
          U_G(I,6,t) = ZZZ(I,1)
          !WRITE(fid_U,300) U_G1(I,t), V_G1(I,t), W_G1(I,t), XXX(I,1),YYY(I,1),ZZZ(I,1)
          WRITE(fid_U,300) U_G(I,1:6,t)

       END DO
!------------------- Write Variable and set to 3D variable for gradient calculation ------------------!
print *, "Done writing 3D variables"

!------------------- CALCULATE RICHARDSON #  ------------------!
!DO t=1,timesteps
fid_temp     = 1500+t

     DO I=1,RMAX*ZMAX*YMAX
               Richardson(I,1,t) = 1.000e3
               Richardson(I,2,t) = XXX(I,1)
               Richardson(I,3,t) = YYY(I,1)
               Richardson(I,4,t) = ZZZ(I,1)
     END DO




! CORRECT THE LOCATION OF THE X AND Z DIRECTION VELOCITIES--------------------------!
  DO rc =4,RMAX-4           !X
   DO zc = 4,ZMAX-4         !Z
    DO yc = YMAX-4,4,-1     !Y
                ! FUNIJK_GL (LI, LJ, LK) = 1 + (LJ - jmin3) + (LI-imin3)*(jmax3-jmin3+1) &
                ! + (LK-kmin3)*(jmax3-jmin3+1)*(imax3-imin3+1)
             I       = 1 + (yc-1) +(rc-1)*(YMAX-1+1) + (zc-1)*(YMAX-1+1)*(RMAX-1+1) 
             
             I_xm1   = 1 + (yc-1) +(rc-1-1)*(YMAX-1+1) + (zc-1)*(YMAX-1+1)*(RMAX-1+1)
             I_zm1   = 1 + (yc-1) +(rc-1)*(YMAX-1+1) + (zc-1-1)*(YMAX-1+1)*(RMAX-1+1)
            
             U_G(I,1,t) = U_G1(I_xm1,t)
             U_G(I,2,t) = V_G1(I,t)
             U_G(I,3,t) = W_G1(I,t)

    END DO
   END DO
  END DO
! CORRECT THE LOCATION OF THE X AND Z DIRECTION VELOCITIES--------------------------!




! NOW THE VELOCITIES ARE CORRECT FOR THE CALCULATION OF GRADIENT RICHARDSON
  DO rc =4,RMAX-4           !X
   DO zc = 4,ZMAX-4         !Z
    DO yc = YMAX-4,4,-1     !Y
                ! FUNIJK_GL (LI, LJ, LK) = 1 + (LJ - jmin3) + (LI-imin3)*(jmax3-jmin3+1) &
                ! + (LK-kmin3)*(jmax3-jmin3+1)*(imax3-imin3+1)
             I       = 1 + (yc-1) +(rc-1)*(YMAX-1+1) + (zc-1)*(YMAX-1+1)*(RMAX-1+1) 
             I_yp1   = 1 + (yc+1-1) +(rc-1)*(YMAX-1+1) + (zc-1)*(YMAX-1+1)*(RMAX-1+1) !Cell above
             I_ym1   = 1 + (yc-1-1) +(rc-1)*(YMAX-1+1) + (zc-1)*(YMAX-1+1)*(RMAX-1+1) !Cell above
             
 
             IF(T_G(I_ym1,1,t)>272.0 .AND. EP_P(I,1,t)<8.0) THEN
                                !------Y-Richardson-------!
                                   ! Current density at each position
                                int_pos1           = I_yp1
                                int_min1           = I_ym1
                                bottom             = 2*((abs(EP_P(int_pos1,3,t)-EP_P(I,3,t))))
                                c_pos1             = rho_p*(10**-(EP_P(int_pos1,1,t)))+(1-(10**-(EP_P(int_pos1,1,t))))*(P_const/(R_vapor*T_G(int_pos1,1,t))) 
                                c_min1             = rho_p*(10**-(EP_P(int_min1,1,t)))+(1-(10**-(EP_P(int_min1,1,t))))*(P_const/(R_vapor*T_G(int_min1,1,t))) 
                                   ! Shear Velocity components, X & Z
                                delta_V1           = (U_G(int_pos1,1,t)-U_G(int_min1,1,t))/bottom
                                !delta_V3           = (U_G(int_pos1,3,t)-U_G(int_min1,3,t))/bottom
                                !shear_v            = sqrt(delta_V1**2+delta_V3**2)
                                shear_v            = delta_V1
                                delta_rho          =(c_pos1-c_min1)/bottom
                                Ri                 =((-gravity/rho_dry)*delta_rho)/(shear_v**2)
                               

                                ! This is done for easier colorbar in Opendx,
                                ! Therefore in the write out column 1 is the
                                ! adjusted Ri and column 5 is the original
                                if (Ri>5) THEN 
                                Richardson(I,1,t) = 5.0
                                !print *, "Ri", I, t, Ri
                                elseif (Ri<-5) THEN
                                Richardson(I,1,t) = -5.0
                                !print *, "Ri", I, t, Ri
                                else
                                Richardson(I,1,t) = Ri
                                end if

                                Richardson(I,2,t) = XXX(I,1)
                                Richardson(I,3,t) = YYY(I,1)
                                Richardson(I,4,t) = ZZZ(I,1)
                                Richardson(I,5,t) = Ri
                                !------Y-Richardson-------!
           END IF
    END DO
   END DO
  END DO 
  

  DO I=1,RMAX*ZMAX*YMAX
    WRITE(fid_temp,401) Richardson(I,1:5,t)
    WRITE(fid_U_t,300) U_G(I,1:6,t)
  END DO

END DO
!------------------- CALCULATE RICHARDSON #  ------------------!






!--------------------------------------- DILUTE GRADIENT CALCULATION ---------------------------------!
print *, "Start Gradient Calculation for dilute case"
!------------------------------- Calculate Characteristic Velocity --------------------------------!
DO t=1,timesteps
 VEL_DILUTE(1:7,t)=0.0
 VEL_DENSE(1:7,t)=0.0
END DO


Do t=1,timesteps
   sum1 = 1
   sum2 = 1
   DO I=1,RMAX*ZMAX*YMAX
     IF (EP_P(I,1,t)<min_dilute .AND. EP_P(I,1,t)>(max_dense)) THEN
          VEL_temp(sum1,1:6) = U_G(I,1:6,t)
                VEL_DILUTE(1,t) = VEL_DILUTE(1,t) + VEL_temp(sum1,1)
                VEL_DILUTE(2,t) = VEL_DILUTE(2,t) + VEL_temp(sum1,2)
                VEL_DILUTE(3,t) = VEL_DILUTE(3,t) + VEL_temp(sum1,3)
                VEL_DILUTE(4,t) = VEL_DILUTE(4,t) + VEL_temp(sum1,4)
                VEL_DILUTE(5,t) = VEL_DILUTE(5,t) + VEL_temp(sum1,5)
                VEL_DILUTE(6,t) = VEL_DILUTE(6,t) + VEL_temp(sum1,6) 

          sum1 = sum1 + 1
     END IF

     IF (EP_P(I,1,t)<min_dense .AND. EP_P(I,1,t)>0) THEN
          VEL_temp2(sum2,1:6) = U_G(I,1:6,t)
                VEL_DENSE(1,t) = VEL_DENSE(1,t) + VEL_temp2(sum2,1)
                VEL_DENSE(2,t) = VEL_DENSE(2,t) + VEL_temp2(sum2,2)
                VEL_DENSE(3,t) = VEL_DENSE(3,t) + VEL_temp2(sum2,3)
                VEL_DENSE(4,t) = VEL_DENSE(4,t) + VEL_temp2(sum2,4)
                VEL_DENSE(5,t) = VEL_DENSE(5,t) + VEL_temp2(sum2,5)
                VEL_DENSE(6,t) = VEL_DENSE(6,t) + VEL_temp2(sum2,6) 

          sum2 = sum2 + 1
     END IF

   END DO
     VEL_DILUTE(1,t) = VEL_DILUTE(1,t)/real(sum1-1)
     VEL_DILUTE(2,t) = VEL_DILUTE(2,t)/real(sum1-1)
     VEL_DILUTE(3,t) = VEL_DILUTE(3,t)/real(sum1-1)
     VEL_DILUTE(4,t) = VEL_DILUTE(4,t)/real(sum1-1)
     VEL_DILUTE(5,t) = VEL_DILUTE(5,t)/real(sum1-1)
     VEL_DILUTE(6,t) = VEL_DILUTE(6,t)/real(sum1-1)
     VEL_DILUTE(7,t) = sqrt(VEL_DILUTE(1,t)**2+VEL_DILUTE(2,t)**2+VEL_DILUTE(3,t)**2)

     VEL_DENSE(1,t) = VEL_DENSE(1,t)/real(sum2-1)
     VEL_DENSE(2,t) = VEL_DENSE(2,t)/real(sum2-1)
     VEL_DENSE(3,t) = VEL_DENSE(3,t)/real(sum2-1)
     VEL_DENSE(4,t) = VEL_DENSE(4,t)/real(sum2-1)
     VEL_DENSE(5,t) = VEL_DENSE(5,t)/real(sum2-1)
     VEL_DENSE(6,t) = VEL_DENSE(6,t)/real(sum2-1)
     VEL_DENSE(7,t) = sqrt(VEL_DENSE(1,t)**2+VEL_DENSE(2,t)**2+VEL_DENSE(3,t)**2)

END DO
!------------------------------- Calculate Characteristic Velocity --------------------------------!

!----------------Calculate Average Current Velocity Per X axis ---------------------------------------!
!VEL_ALL(:,:,:) = 0.0
DO t=1,timesteps
fid_temp = 1300 + t
     DO rc=5,RMAX-4 !Looping through the x axis.
       sum1=1
       VEL_ALL(rc,1:7,t)= 0.0
       DO zc=7,ZMAX-7
          DO yc=YMAX-4,4,-1
                        I = 1 + (yc-1) +(rc-1)*(YMAX-1+1) +(zc-1)*(YMAX-1+1)*(RMAX-1+1)
                        IF (EP_P(I,1,t) <max_dilute) THEN
                                VEL_temp(sum1,1:6) = U_G(I,1:6,t)
                                WRITE(83821,805) VEL_temp(sum1,1:6), rc, t, sum1
                                     VEL_ALL(rc,1,t) = VEL_ALL(rc,1,t) + VEL_temp(sum1,1)
                                     VEL_ALL(rc,2,t) = VEL_ALL(rc,2,t) + VEL_temp(sum1,2)
                                     VEL_ALL(rc,3,t) = VEL_ALL(rc,3,t) + VEL_temp(sum1,3)
                                     VEL_ALL(rc,4,t) = VEL_ALL(rc,4,t) + VEL_temp(sum1,4)
                                     VEL_ALL(rc,5,t) = VEL_ALL(rc,5,t) + VEL_temp(sum1,5)
                                     VEL_ALL(rc,6,t) = VEL_ALL(rc,6,t) + VEL_temp(sum1,6)
                               WRITE(83823,805) VEL_ALL(rc,1:6,t), rc, t, sum1
                                     sum1 = sum1 + 1
                        END IF
          END DO
       END DO
     IF (sum1==1) THEN
        !WRITE(fid_temp,407) VEL_ALL(rc,1:7,t),rc,t
     ELSE
     WRITE(83822,805) VEL_ALL(rc,1:6,t), rc, t, sum1
     VEL_ALL(rc,1,t) = VEL_ALL(rc,1,t)/real(sum1-1)
     VEL_ALL(rc,2,t) = VEL_ALL(rc,2,t)/real(sum1-1)
     VEL_ALL(rc,3,t) = VEL_ALL(rc,3,t)/real(sum1-1)
     VEL_ALL(rc,4,t) = VEL_ALL(rc,4,t)/real(sum1-1)
     VEL_ALL(rc,5,t) = VEL_ALL(rc,5,t)/real(sum1-1)
     VEL_ALL(rc,6,t) = VEL_ALL(rc,6,t)/real(sum1-1)
     VEL_ALL(rc,7,t) = sqrt(VEL_ALL(rc,1,t)**2+VEL_ALL(rc,2,t)**2+VEL_ALL(rc,3,t)**2)
     VEL_temp(:,:) = 0.0
     !WRITE(fid_temp,407) VEL_ALL(rc,1:7,t),rc,t
     END IF
   END DO
END DO 
!----------------Calculate Average Current Velocity Per X axis ---------------------------------------!
!VEL_6(:,:,:) = 0.0
VEL_temp(:,:) = 0.0
!----------- Search entire volume for crossing threshold of Volume Fraction of Particles  ------------!
DO t=1,timesteps
fid_ISO6     = 750+t
fid_GRAD4pt  = 800+t
fid_GRADsize = 850+t
fid_GradV    = 900+t
fid_GradE    = 1000+t
fid_Ri       = 1050+t
fid_temp     = 950+t
fid_Dot      = 1450+t

sum1=1
!--------------------- Searching entire volume but avoiding ghost cells and boundary cells -----------!
     DO rc=5,RMAX-4 !Looping through the x axis.
        VEL_6(rc,1:7,t) = 0.0
        sum2=1 
       DO zc=7,ZMAX-7
          DO yc=YMAX-4,4,-1
             I       = 1 + (yc-1) +(rc-1)*(YMAX-1+1) + (zc-1)*(YMAX-1+1)*(RMAX-1+1)
             I_yp1   = 1 + (yc+1-1) +(rc-1)*(YMAX-1+1) + (zc-1)*(YMAX-1+1)*(RMAX-1+1) !Cell above
             I_zp1   = 1 + (yc-1) +(rc-1)*(YMAX-1+1) + (zc+1-1)*(YMAX-1+1)*(RMAX-1+1) !Cell to the left in Z direction
             I_zm1   = 1 + (yc-1) +(rc-1)*(YMAX-1+1) + (zc-1-1)*(YMAX-1+1)*(RMAX-1+1) !Cell to the right in Z direction
             I_xm1   = 1 + (yc-1) +(rc-1-1)*(YMAX-1+1) + (zc-1)*(YMAX-1+1)*(RMAX-1+1) !Cell in front in the X direction
             current_density = rho_p*(10**-(EP_P(I,1,t)))+(1-(10**-(EP_P(I,1,t))))*(P_const/(R_vapor*T_G(I,1,t)))
             IF (current_density < rho_dry .AND. EP_P(I,1,t)<max_dilute .AND. EP_P(I,1,t)>min_dilute) THEN  
             ! Making sure this portion is buoyant, and within a small range of volume fraction of particles
               IF (EP_P(I_yp1,1,t)>max_dilute .or. EP_P(I_zp1,1,t)>max_dilute .or. EP_P(I_zm1,1,t)>max_dilute .or. EP_P(I_xm1,1,t)>max_dilute) THEN
                        !Reset local position
                        Z_minus  = 0;
                        Z_plus   = 0;
                        X_minus  = 0;
                        Y_plus   = 0; 
                        Z_total  = 0; 
                        if (EP_P(I_yp1,1,t)>max_dilute) Y_plus = -1
                        if (EP_P(I_zp1,1,t)>max_dilute) Z_plus = -1
                        if (EP_P(I_zm1,1,t)>max_dilute) Z_minus = 1
                        if (EP_P(I_xm1,1,t)>max_dilute) X_minus = 1
                        if (Z_plus ==-1 .AND. Z_minus ==1) print *, "Error Z plus and minus",I,t
                         Z_total = Z_plus + Z_minus 
                        !Make sure the cells below are not below topography for gradient calculation
                        I_local = 1 + (yc+Y_plus-1) +(rc+X_minus-1)*(YMAX-1+1) + (zc+Z_total-1)*(YMAX-1+1)*(RMAX-1+1)
                  IF(T_G(I-1,1,t)>272.0 .AND. T_G(I-2,1,t) >272.0 .AND. EP_P(I_local,1,t)<max_dilute) THEN
                       ! WRITE(fid_GradE,502) XXX(I,1),YYY(I,1),ZZZ(I,1),EP_P(I,1,t),sqrt(U_G(I,1,t)**2+U_G(I,2,t)**2+U_G(I,3,t)**2),XXX(I_local,1),YYY(I_local,1),ZZZ(I_local,1),EP_P(I_local,1,t),sqrt(U_G(I_local,1,t)**2+U_G(I_local,2,t)**2+U_G(I_local,3,t)**2)
                         
                 ! Making sure this is the point of change into the dilute region of interest
                        Iso_6(sum1,1:4,t) = EP_P(I,:,t)
                        Iso_6(sum1,5,t)   = DBLE(I)
                        Iso_6(sum1,6,t)   = T_G(I,1,t)
                        Iso_6(sum1,7,t)   = current_density
                        Iso_6(sum1,8,t)   = rho_dry
                        Iso_6(sum1,9,t)   = rc
                        !WRITE(fid_ISO6,308) Iso_6(sum1,:,t)
                        !WRITE(fid_GRADV,300) U_G(I,1:6,t)
                        VEL_6(rc,1,t) = VEL_6(rc,1,t) + U_G(I,1,t)
                        VEL_6(rc,2,t) = VEL_6(rc,2,t) + U_G(I,2,t)
                        VEL_6(rc,3,t) = VEL_6(rc,3,t) + U_G(I,3,t)
                        VEL_6(rc,4,t) = VEL_6(rc,4,t) + U_G(I,4,t)
                        VEL_6(rc,5,t) = VEL_6(rc,5,t) + U_G(I,5,t)
                        VEL_6(rc,6,t) = VEL_6(rc,6,t) + U_G(I,6,t)
                        WRITE(3821,805) VEL_6(rc,1:6,t), rc, t, sum2  
                       ! ----------------------- 4-point central difference stencil -----------------------!
                                int_temp = I
                                tc       = sum1
                                four_point(tc,1:5,t) = Iso_6(tc,1:5,t)
                                !------X-direction-------!
                                int_pos1           = int_temp+YMAX
                                int_pos2           = int_temp+2*YMAX
                                int_min1           = int_temp-YMAX
                                int_min2           = int_temp-2*YMAX
                                top                = (EP_P(int_min2,1,t))-8*(EP_P(int_min1,1,t))+8*(EP_P(int_pos1,1,t))-(EP_P(int_pos2,1,t))
                                bottom             = 12*((abs(EP_P(int_pos1,2,t)-EP_P(int_temp,2,t))))
                                four_point(tc,6,t) = top/bottom
                                !------X-direction-------!

                                !------Y-direction-------!
                                int_pos1           = int_temp+1
                                int_pos2           = int_temp+2*1
                                int_min1           = int_temp-1
                                int_min2           = int_temp-2*1
                                local_vel          = sqrt(U_G(I_local,1,t)**2+U_G(I_local,2,t)**2+U_G(I_local,3,t)**2)
                                IF(T_G(int_min1,1,t) < 272.00 .or. T_G(int_min2,1,t) <272.0) WRITE(382015,301) Iso_6(tc,1:4,t), EP_P(int_min1,1,t),EP_P(int_min2,1,t),T_G(int_min1,1,t),T_G(int_min2,1,t),YYY(I,1),YYY(int_min1,1),YYY(int_min2,1) 
                                top                = (EP_P(int_min2,1,t))-8*(EP_P(int_min1,1,t))+8*(EP_P(int_pos1,1,t))-(EP_P(int_pos2,1,t))
                                bottom             = 12*((abs(EP_P(int_pos1,3,t)-EP_P(int_temp,3,t))))
                                four_point(tc,7,t) = top/bottom
                                !------Y-direction-------!

                                !------Y-Richardson-------!
                                   ! Current density at each position
                                int_pos1           = int_temp+1
                                int_pos2           = int_temp+2
                                int_min1           = int_temp-1
                                int_min2           = int_temp-2
                                if (T_G(int_min1,1,t) > 0.0) then
                                bottom             = 2*((abs(EP_P(int_pos1,3,t)-EP_P(int_temp,3,t))))
                                c_pos1             = rho_p*(10**-(EP_P(int_pos1,1,t)))+(1-(10**-(EP_P(int_pos1,1,t))))*(P_const/(R_vapor*T_G(int_pos1,1,t))) 
                                c_min1             = rho_p*(10**-(EP_P(int_min1,1,t)))+(1-(10**-(EP_P(int_min1,1,t))))*(P_const/(R_vapor*T_G(int_min1,1,t))) 
                                   ! Shear Velocity components, X & Z
                                delta_V1           = (U_G(int_pos1,1,t)-U_G(int_min1,1,t))/bottom
                                !delta_V3           = (U_G(int_pos1,3,t)-U_G(int_min1,3,t))/bottom
                                !shear_v            = sqrt(delta_V1**2+delta_V3**2)
                                shear_v            = delta_V1
                                delta_rho          =(c_pos1-c_min1)/bottom
                                Ri                 =((-gravity/rho_dry)*delta_rho)/(shear_v**2)

                                if (Ri > 5.0) then
                                Ri = 5.0
                                elseif (Ri< -5.0) then
                                Ri = -5.0
                                end if

                                !WRITE(fid_Ri,301) Iso_6(tc,1:4,t),c_pos1,c_min1,Ri,delta_V1,delta_V3,T_G(int_pos1,1,t),T_G(int_min1,1,t)
                                end if
                                !------Y-Richardson-------!

                                !------Z-direction-------!
                                int_pos1           = int_temp-RMAX*YMAX
                                int_pos2           = int_temp-2*RMAX*YMAX
                                int_min1           = int_temp+RMAX*YMAX
                                int_min2           = int_temp+2*RMAX*YMAX
                                top                = (EP_P(int_min2,1,t))-8*(EP_P(int_min1,1,t))+8*(EP_P(int_pos1,1,t))-(EP_P(int_pos2,1,t))
                                bottom             = 12*((abs(EP_P(int_pos1,4,t)-EP_P(int_temp,4,t))))
                                four_point(tc,8,t) = top/bottom
                                !------Z-direction-------!
                                Location_I(sum1,t)= rc
                                four_point(tc,9,t) = DBLE(rc)
                        ! ----------------------- 4-point central difference stencil -----------------------!
                        sum1 = sum1+1
                        sum2 = sum2+1
                        mag_grad  = sqrt(four_point(tc,6,t)**2 + four_point(tc,7,t)**2 + four_point(tc,8,t)**2)
                        norm_grad(1,1) = four_point(tc,6,t)/mag_grad
                        norm_grad(1,2) = four_point(tc,7,t)/mag_grad
                        norm_grad(1,3) = four_point(tc,8,t)/mag_grad
                        temp_dot  = dot_product(U_G(I,1:3,t),norm_grad(1,1:3))
                       ! WRITE(fid_Dot,302)four_point(tc,1:8,t),initial_vel,norm_grad(1,1:3),U_G(I,1:3,t),temp_dot/initial_vel 
                       ! WRITE(fid_temp,302)four_point(tc,1:8,t),VEL_DILUTE(7,t),norm_grad(1,1:3),U_G(I,1:3,t),temp_dot/VEL_DILUTE(7,t)
                 END IF
                END IF
             END IF
          END DO
       END DO
         WRITE(3825,806) VEL_ALL(rc,1:7,t), rc, t, sum2
     IF (sum2==1) THEN
           !WRITE(fid_temp,407) VEL_6(rc,1:7,t),rc,t
     ELSE
           VEL_6(rc,1,t) = VEL_6(rc,1,t)/real(sum2-1)
           VEL_6(rc,2,t) = VEL_6(rc,2,t)/real(sum2-1)
           VEL_6(rc,3,t) = VEL_6(rc,3,t)/real(sum2-1)
           VEL_6(rc,4,t) = VEL_6(rc,4,t)/real(sum2-1)
           VEL_6(rc,5,t) = VEL_6(rc,5,t)/real(sum2-1)
           VEL_6(rc,6,t) = VEL_6(rc,6,t)/real(sum2-1)
           VEL_6(rc,7,t) = sqrt(VEL_6(rc,1,t)**2+VEL_6(rc,2,t)**2+VEL_6(rc,3,t)**2)
           !WRITE(fid_temp,407) VEL_6(rc,1:7,t),rc,t
     END IF
    END DO

 DO K=1,sum1-1
   temp_rc = int(four_point(K,9,t))
   !J = Location_I(K,t)
   !print *, K, temp_rc, t
   four_point(K,10,t) = VEL_ALL(temp_rc,7,t)
   !print *, "Vel ALL (temp_rc)", VEL_ALL(temp_rc,1:7,t)
   !print *, "Vel ALL (J)", VEL_ALL(J,1:7,t)
   four_point(K,11,t) = VEL_6(temp_rc,7,t)
   WRITE(fid_GRAD4pt,311) four_point(K,1:11,t)
 END DO 
!WRITE(fid_GRADsize,101) sum1-1
END DO ! End timesteps
print *, "End Gradient Calculation"
!--------------------- Searching entire volume but avoiding ghost cells and boundary cells -----------!
!--------------------------------------- DILUTE GRADIENT CALCULATION ---------------------------------!


!--------------------------------------- DENSE GRADIENT CALCULATION ---------------------------------!
print *, "Start Gradient Calculation for dense"
!----------- Search entire volume for crossing threshold of Volume Fraction of Particles  ------------!
DO t=1,timesteps
fid_ISO3     = 1750+t
fid_GRAD4pt  = 1800+t
fid_GRADsize = 1850+t
fid_GradV    = 1900+t
fid_temp     = 1950+t
fid_Ri       = 2050+t
fid_Dot      = 2100+t
sum1=1
!--------------------- Searching entire volume but avoiding ghost cells and boundary cells -----------!
    DO rc=5,RMAX-4
         VEL_3(rc,1:7,t) = 0.0
         sum2=1
        DO zc=7,ZMAX-7
          DO yc=YMAX-4,4,-1
             I       = 1 + (yc-1) +(rc-1)*(YMAX-1+1) + (zc-1)*(YMAX-1+1)*(RMAX-1+1)
             I_yp1   = 1 + (yc+1-1) +(rc-1)*(YMAX-1+1) + (zc-1)*(YMAX-1+1)*(RMAX-1+1) !Cell above
             I_zp1   = 1 + (yc-1) +(rc-1)*(YMAX-1+1) + (zc+1-1)*(YMAX-1+1)*(RMAX-1+1) !Cell to the left in Z direction
             I_zm1   = 1 + (yc-1) +(rc-1)*(YMAX-1+1) + (zc-1-1)*(YMAX-1+1)*(RMAX-1+1) !Cell to the right in Z direction
             I_xm1   = 1 + (yc-1) +(rc-1-1)*(YMAX-1+1) + (zc-1)*(YMAX-1+1)*(RMAX-1+1) !Cell in front in the X direction
             current_density = rho_p*(10**-(EP_P(I,1,t)))+(1-(10**-(EP_P(I,1,t))))*(P_const/(R_vapor*T_G(I,1,t))) 
             ! Making sure this portion is denser than ambient air, and within a small range of volume fraction of particles
             IF (current_density > rho_dry .AND. EP_P(I,1,t)<max_dense .AND. EP_P(I,1,t)>min_dense) THEN
                 ! Making sure this is the point of change into the dense region of interest
                 IF (EP_P(I_yp1,1,t)>max_dense .or. EP_P(I_zp1,1,t)>max_dense .or. EP_P(I_zm1,1,t)>max_dense .or. EP_P(I_xm1,1,t)>max_dense) THEN
                                           !Reset local position
                        Z_minus  = 0;
                        Z_plus   = 0;
                        X_minus  = 0;
                        Y_plus   = 0;
                        Z_total  = 0;
                        if (EP_P(I_yp1,1,t)>max_dense) Y_plus = -1
                        if (EP_P(I_zp1,1,t)>max_dense) Z_plus = -1
                        if (EP_P(I_zm1,1,t)>max_dense) Z_minus = 1
                        if (EP_P(I_xm1,1,t)>max_dense) X_minus = 1
                        if (Z_plus ==-1 .AND. Z_minus ==1) print *, "Error Z plus and minus",I,t
                         Z_total = Z_plus + Z_minus
                        I_local = 1 + (yc+Y_plus-1) +(rc+X_minus-1)*(YMAX-1+1) + (zc+Z_total-1)*(YMAX-1+1)*(RMAX-1+1)
                  IF(T_G(I-1,1,t)>272.0 .AND. T_G(I-2,1,t) >272.0 .AND. EP_P(I_local,1,t)<max_dense) THEN
                        !Make sure the cells below are not below topography for gradient calculation
                        Iso_3(sum1,1:4,t) = EP_P(I,:,t)
                        Iso_3(sum1,5,t)   = DBLE(I)
                        Iso_3(sum1,6,t)   = T_G(I,1,t)
                        Iso_3(sum1,7,t)   = current_density
                        Iso_3(sum1,8,t)   = rho_dry
                        Iso_3(sum1,9,t)   = rc
                        Location_I(sum1,t)= I
                        WRITE(fid_ISO3,308) Iso_3(sum1,:,t)
                        WRITE(fid_GRADV,300) U_G(I,1:6,t)
                        VEL_3(rc,1,t) = VEL_3(rc,1,t) + U_G(I,1,t)
                        VEL_3(rc,2,t) = VEL_3(rc,2,t) + U_G(I,2,t)
                        VEL_3(rc,3,t) = VEL_3(rc,3,t) + U_G(I,3,t)
                        VEL_3(rc,4,t) = VEL_3(rc,4,t) + U_G(I,4,t)
                        VEL_3(rc,5,t) = VEL_3(rc,5,t) + U_G(I,5,t)
                        VEL_3(rc,6,t) = VEL_3(rc,6,t) + U_G(I,6,t)
                        WRITE(3822,805) VEL_3(rc,1:6,t), rc, t, sum2
                        ! ----------------------- 4-point central difference stencil -----------------------!
                                int_temp = I
                                tc       = sum1
                                four_point_Iso3(tc,1:5,t) = Iso_3(tc,1:5,t)
                                !------X-direction-------!
                                int_pos1           = int_temp+YMAX
                                int_pos2           = int_temp+2*YMAX
                                int_min1           = int_temp-YMAX
                                int_min2           = int_temp-2*YMAX
                                top                = (EP_P(int_min2,1,t))-8*(EP_P(int_min1,1,t))+8*(EP_P(int_pos1,1,t))-(EP_P(int_pos2,1,t))
                                bottom             = 12*((abs(EP_P(int_pos1,2,t)-EP_P(int_temp,2,t))))
                                four_point_Iso3(tc,6,t) = top/bottom
                                !------X-direction-------!

                                !------Y-direction-------!
                                int_pos1           = int_temp+1
                                int_pos2           = int_temp+2*1
                                int_min1           = int_temp-1
                                int_min2           = int_temp-2*1
                                local_vel          = sqrt(U_G(I_local,1,t)**2+U_G(I_local,2,t)**2+U_G(I_local,3,t)**2)
                                IF(T_G(int_min1,1,t) < 272.00 .or. T_G(int_min2,1,t) <272.0) WRITE(392015,301) Iso_3(tc,1:4,t), EP_P(int_min1,1,t),EP_P(int_min2,1,t),T_G(int_min1,1,t),T_G(int_min2,1,t),YYY(I,1),YYY(int_min1,1),YYY(int_min2,1) 
                                top                = (EP_P(int_min2,1,t))-8*(EP_P(int_min1,1,t))+8*(EP_P(int_pos1,1,t))-(EP_P(int_pos2,1,t))
                                bottom             = 12*((abs(EP_P(int_pos1,3,t)-EP_P(int_temp,3,t))))
                                four_point_Iso3(tc,7,t) = top/bottom
                                !------Y-direction-------!

                                !------Y-Richardson-------!
                                   ! Current density at each position
                                int_pos1           = int_temp+1
                                int_pos2           = int_temp+2
                                int_min1           = int_temp-1
                                int_min2           = int_temp-2
                                if (T_G(int_min1,1,t) > 0.0) then
                                bottom             = 2*((abs(EP_P(int_pos1,3,t)-EP_P(int_temp,3,t))))
                                c_pos1             = rho_p*(10**-(EP_P(int_pos1,1,t)))+(1-(10**-(EP_P(int_pos1,1,t))))*(P_const/(R_vapor*T_G(int_pos1,1,t))) 
                                c_min1             = rho_p*(10**-(EP_P(int_min1,1,t)))+(1-(10**-(EP_P(int_min1,1,t))))*(P_const/(R_vapor*T_G(int_min1,1,t))) 
                                   ! Shear Velocity components, X & Z
                                delta_V1           = (U_G(int_pos1,1,t)-U_G(int_min1,1,t))/bottom
                                !delta_V3           = (U_G(int_pos1,3,t)-U_G(int_min1,3,t))/bottom
                                !shear_v            = sqrt(delta_V1**2+delta_V3**2)
                                shear_v            = delta_V1
                                delta_rho          =(c_pos1-c_min1)/bottom
                                Ri                 =((-gravity/rho_dry)*delta_rho)/(shear_v**2)

                                if (Ri > 5.0) then
                                Ri = 5.0
                                elseif (Ri< -5.0) then
                                Ri = -5.0
                                end if

                                !WRITE(fid_Ri,301) Iso_3(tc,1:4,t),c_pos1,c_min1,Ri,delta_V1,delta_V3,T_G(int_pos1,1,t),T_G(int_min1,1,t)
                                end if
                                !------Y-Richardson-------!

                                !------Z-direction-------!
                                int_pos1           = int_temp-RMAX*YMAX
                                int_pos2           = int_temp-2*RMAX*YMAX
                                int_min1           = int_temp+RMAX*YMAX
                                int_min2           = int_temp+2*RMAX*YMAX
                                top                = (EP_P(int_min2,1,t))-8*(EP_P(int_min1,1,t))+8*(EP_P(int_pos1,1,t))-(EP_P(int_pos2,1,t))
                                bottom             = 12*((abs(EP_P(int_pos1,4,t)-EP_P(int_temp,4,t))))
                                four_point_Iso3(tc,8,t) = top/bottom
                                !------Z-direction-------!
                                four_point_Iso3(tc,9,t) = DBLE(rc)
                                !WRITE(fid_GRAD4pt,308) four_point_Iso3(tc,1:9,t)
                        ! ----------------------- 4-point central difference stencil -----------------------!
                        sum1 = sum1+1
                        sum2 = sum2+1
                        mag_grad  = sqrt(four_point_Iso3(tc,6,t)**2 + four_point_Iso3(tc,7,t)**2 + four_point_Iso3(tc,8,t)**2)
                        norm_grad(1,1) = four_point_Iso3(tc,6,t)/mag_grad
                        norm_grad(1,2) = four_point_Iso3(tc,7,t)/mag_grad
                        norm_grad(1,3) = four_point_Iso3(tc,8,t)/mag_grad
                        temp_dot  = dot_product(U_G(I,1:3,t),norm_grad(1,1:3))
                        !WRITE(fid_Dot,302)four_point_Iso3(tc,1:8,t),initial_vel,norm_grad(1,1:3),U_G(I,1:3,t),temp_dot/initial_vel 
                        !WRITE(fid_temp,302)four_point_Iso3(tc,1:8,t),VEL_DENSE(7,t),norm_grad(1,1:3),U_G(I,1:3,t),temp_dot/VEL_DENSE(7,t) 
                  END IF
                END IF
             END IF
          END DO
       END DO
     IF (sum2==1) THEN
           !WRITE(fid_temp,407) VEL_3(rc,1:7,t),rc,t
     ELSE
           VEL_3(rc,1,t) = VEL_3(rc,1,t)/real(sum2-1)
           VEL_3(rc,2,t) = VEL_3(rc,2,t)/real(sum2-1)
           VEL_3(rc,3,t) = VEL_3(rc,3,t)/real(sum2-1)
           VEL_3(rc,4,t) = VEL_3(rc,4,t)/real(sum2-1)
           VEL_3(rc,5,t) = VEL_3(rc,5,t)/real(sum2-1)
           VEL_3(rc,6,t) = VEL_3(rc,6,t)/real(sum2-1)
           VEL_3(rc,7,t) = sqrt(VEL_3(rc,1,t)**2+VEL_3(rc,2,t)**2+VEL_3(rc,3,t)**2)
           !WRITE(fid_temp,407) VEL_3(rc,1:7,t),rc,t
     END IF
    END DO

 DO K=1,sum1-1
   temp_rc = int(four_point_Iso3(K,9,t))
   four_point_Iso3(K,10,t) = VEL_ALL(temp_rc,7,t)
   four_point_Iso3(K,11,t) = VEL_3(temp_rc,7,t)
   !WRITE(fid_GRAD4pt,311) four_point_Iso3(K,1:11,t)
 END DO 



!--------------------- Searching entire volume but avoiding ghost cells and boundary cells -----------!
!WRITE(fid_GRADsize,101) sum1-1
END DO ! End timesteps
print *, "End Dense Gradient Calculation"
!--------------------------------------- DENSE GRADIENT CALCULATION ---------------------------------!

!norm = sqrt(V1(1,1)**2+V1(1,2)**2+V1(1,3)**2)
!Vn1(1,1:3)= V1(1,1:3)/norm
!print *, norm
!print *, Vn1(1,1:3)

!print *, V1(1,1:3)
!print *, V2(1,1:3)
!print *, DOT_PRODUCT(V1(1,1:3), V2(1,1:3))

!-------------------------CALCULATE NUMBER OF GRIDS WITH SPECIFIC VOLUME FRACTION OF GAS -------------!
DO t=1,timesteps
sum_p1 = 0.0
  DO I=1,RMAX*ZMAX*YMAX
     IF (EP_G1(I,t) <0.99999) THEN
     sum_p1 = sum_p1 + 1.0
     END IF
  END DO
  WRITE(701,802) t, sum_p1
END DO

DO t=1,timesteps
sum_p2 = 0.0
  DO I=1,RMAX*ZMAX*YMAX
     IF (EP_G1(I,t) <0.999) THEN
     sum_p2 = sum_p2 + 1.0
     END IF
  END DO
  WRITE(702,802) t, sum_p2
END DO

DO t=1,timesteps
sum_p3 = 0.0
  DO I=1,RMAX*ZMAX*YMAX
     IF (EP_G1(I,t) <0.99) THEN
     sum_p3 = sum_p3 + 1.0
     END IF
  END DO
  WRITE(703,802) t, sum_p3
END DO
!-------------------------CALCULATE NUMBER OF GRIDS WITH SPECIFIC VOLUME FRACTION OF GAS -------------!
DO t = 1,timesteps
write(x1,str_c) t
num_open = 1400+t
  OPEN(num_open,FILE='dpu_t'//trim(x1)//'.txt')
END DO
! ---- dynamic pressure calculation ----! 
DO t = 1,timesteps
        fid_dpu = 1400+t
        fid_dpv = 1500+t
        !print*, fid_dpu
        DO I =1,ZMAX*RMAX*YMAX

                dpu(I,t) = 0.5*ROP_S1(I,t)*U_S1(I,t)*U_S1(I,t)
                dpv(I,t) = 0.5*ROP_S1(I,t)*((V_S1(I,t))**2)
         !       write(*,*) dpu
         !       IF (dpu .GT. 0) THEN
                !print*, dpu
                !END IF
                WRITE(fid_dpu, 400) dpu(I,t), XXX(I,1),YYY(I,1),ZZZ(I,1)
                WRITE(fid_dpv, 400) dpv(I,t), XXX(I,1),YYY(I,1),ZZZ(I,1)
        end do
end do

! mass in channel 

OPEN(666, file='massinchannel.txt')
print *, "Done writing 3D variables"
DO t= 1,timesteps
chmass = 0
tmass = 0
chmassd = 0

DO I = 1,length1
    J = EP_P(I,2,t)/2
    bottom = tand(M)*2*(400-J)+20-depth
    top = tand(M)*2*(400-J)+20

    IF (EP_P(I,3,t)>bottom) THEN
    IF (EP_P(I,1,t)<max_dilute) THEN
        IF (EP_P(I,1,t) >0.000) THEN
         tmass = tmass + ((EP_P(I,1,t))*Volume_Unit*rho_p)

        IF (EP_P(I,4,t) >edge1) THEN
         IF (EP_P(I,4,t) <edge2) THEN
         chmass = chmass + ((EP_P(I,1,t))*Volume_Unit*rho_p)
!         print*, "Mass in channel width", chmass

        IF (EP_P(I,3,t)>bottom) THEN
        IF (EP_P(I,3,t)<top) THEN
         chmassd = chmassd + ((EP_P(I,1,t))*Volume_Unit*rho_p)

!         print*, "Mass in channel depth", chmassd
        END IF
        END IF
       END IF
      END IF
    END IF
   END IF
  END IF
 END DO

 WRITE(666, 403) chmass/tmass, chmassd/tmass
END DO
!! done !!


!OPEN(231, FILE='slice.txt')

!DO t= 1,timesteps
!DO I= 1, length1
!  J = 200/2
!  bottom = tand(M)*2*(400-J)+20-depth

!  IF (EP_P(I,4,t) .EQ. 150) THEN
!        IF (EP_P(I,2,t) .EQ. 200) THEN
!               IF (EP_P(I,3,t) .GT. bottom) THEN

 !               WRITE(231,405) EP_P(I,3,t), EP_P(I,1,t), U_G(I,1,t), T_G(I,1,t)

!                END IF
!             END IF
!        END IF
!   END IF
!END DO
!END DO 

! avg u,t

!max_dense   = 2.5
!min_dense   = 1.5
!max_dilute  = 6.5
!min_dilute  = 5.5

open(888, file ='average_all.txt')
open(887, file= 'average_medium.txt')
open(889, file ='average_dense.txt')

WRITE(888,405) 800.0, 10.0, 0.0, 0.0, 10.0
WRITE(887,405) 800.0, 10.0, 0.0, 0.0, 10.0
WRITE(889,405) 800.0, 10.0, 0.0, 0.0, 10.0


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
        IF (EP_P(I,1,t) .Gt. min_dense .and. EP_P(I,1,t) .lt. max_dilute ) THEN
               sum_1 = sum_1 +1
               avgt = T_G(I,1,t) + avgt
               avgu = U_G(I,1,t) + avgu
               avgv = U_G(I,2,t) + avgv
               avgw = U_G(I,3,t) + avgw
               avgus = U_S1(I,t) + avgus
               avgdpu = dpu(I,t) + avgdpu
        END IF

        IF (EP_P(I,1,t) .Gt. min_dense .and. EP_P(I,1,t) .lt. max_dense ) THEN
               sum_2 = sum_2 +1
               avgt2 = T_G(I,1,t) + avgt2
               avgu2 = U_G(I,1,t) + avgu2
               avgv2 = U_G(I,2,t) + avgv2
               avgw2 = U_G(I,3,t) + avgw2
               avgus2 = U_S1(I,t) + avgus2
               avgdpu2 = dpu(I,t) + avgdpu2

        END IF

        IF (EP_P(I,1,t) .Gt. max_dense .and. EP_P(I,1,t) .lt. min_dilute ) THEN
               sum_3 = sum_3 +1
               avgt3 = T_G(I,1,t) + avgt3
               avgu3 = U_G(I,1,t) + avgu3
               avgv3 = U_G(I,2,t) + avgv3
               avgw3 = U_G(I,3,t) + avgw3
               avgus3 = U_S1(I,t) + avgus3
               avgdpu3 = dpu(I,t) + avgdpu3
        END IF
END DO
     
     WRITE( 888, 405) avgt/sum_1, avgu/sum_1, avgv/sum_1, avgw/sum_1,  avgus/sum_1,  avgdpu/sum_1
     Write (887, 405) avgt3/sum_3, avgu3/sum_3, avgv3/sum_3, avgw3/sum_3, avgus3/sum_3, avgdpu2/sum_2
     write(889, 405) avgt2/sum_2, avgu2/sum_2, avgv2/sum_2, avgw2/sum_2, avgus2/sum_2, avgdpu3/sum_3

END DO

!DO t=1,timesteps
!fid_shear = 3000+t
!--------------------- Searching entire volume but avoiding ghost cells and
!boundary cells -----------!
   !! DO rc=2,RMAX-2
     !    VEL_3(rc,1:7,t) = 0.0
      !   sum2=1
       ! DO zc=2,ZMAX-1
   !       DO yc=YMAX-2,2,-1
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

END PROGRAM


