PROGRAM GRAPHS 

IMPLICIT NONE

DOUBLE PRECISION, ALLOCATABLE :: ROP_S1(:,:),U_S1(:,:), SHUY(:,:),SHWY(:,:),dpu(:,:), dpv(:,:), V_S1(:,:)
INTEGER:: t
DOUBLE PRECISION:: H, stokesv, stokest, D, gravity, gstar, Hstar, ROP_0, u0 

INTEGER, ALLOCATABLE::Location_I(:,:), topoind(:,:)
INTEGER:: N, I, J, K, timesteps, RMAX, YMAX, ZMAX, Volume_Unit, length1
DOUBLE PRECISION, ALLOCATABLE ::XX(:,:,:),YY(:,:,:),ZZ(:,:,:),channel_topo(:,:)
DOUBLE PRECISION, ALLOCATABLE ::DY(:),y(:),x(:),z(:),DX(:),DTH(:),DZ(:),GZ(:)
DOUBLE PRECISION:: y_boundary,sum_p1, sum_p2, sum_p3,sum_p4,sum_mass,sum_E1,sum_E2,sum_EG
DOUBLE PRECISION:: P_const, R_vapor, R_dryair,char_length, Reynolds_N,rho_g,mu_g,rho_dry,rho_p,T_amb 
DOUBLE PRECISION, ALLOCATABLE ::topo2(:),topography(:),EP_G1(:,:),XXX(:,:),YYY(:,:),ZZZ(:,:)
DOUBLE PRECISION, ALLOCATABLE :: T_G1(:,:),V_G1(:,:),U_G1(:,:),W_G1(:,:),T_S1(:,:),T_S2(:,:),C_PG(:,:),C_PS1(:,:),C_PS2(:,:)
DOUBLE PRECISION:: max_mag, current_density,top,bottom, max_dilute,min_dilute, max_dense, min_dense

DOUBLE PRECISION:: tmass, chmass, chmassd, inchannelw, inchanneld, theta
INTEGER:: ind1, edge1, edge2, width, depth, bins, M
DOUBLE PRECISION:: sum1, sum2, sum3, sum4, sum5, sum6, sum7, sum8, lower5, middle, upper
DOUBLE PRECISION, allocatable:: shear(:,:), head(:)
DOUBLE PRECISION:: tau, shearv, rouse 

!------------OPEN the binary files-----------!
OPEN(106, FILE='EP_G_t02.txt', form='formatted')
OPEN(100,FILE='EP_G',form='unformatted')
OPEN(101,FILE='T_G',form='unformatted')
OPEN(102,FILE='U_G',form='unformatted')
OPEN(103,FILE='V_G',form='unformatted')
OPEN(104,FILE='W_G',form='unformatted')

!OPEN(108, FILE = 'U_G_t04.txt', form = 'formatted')

!OPEN(120, FILE='EPG.txt', FORM='FORMATTED')
!OPEN(121, FILE='TG.txt', FORM='FORMATTED')

!OPEN(170, FILE = 'SH_U_Y', form = 'unformatted')
!OPEN(180, FILE = 'SH_W_Y', form = 'unformatted')
!OPEN(270, FILE = 'SHUY', form = 'formatted')
!OPEN(280, FILE = 'SHWY', form = 'formatted')

!OPEN(108,FILE='T_S1',form='unformatted')
!OPEN(109,FILE='V_S1',form='unformatted')
!OPEN(110,FILE='ROP_S1',form='unformatted')
!OPEN(111,FILE='U_S1',form='unformatted')
!------------OPEN the topography files-------!
OPEN(600,FILE='topography',form='formatted')
OPEN(601,FILE='topo2',form='formatted')
OPEN(602,FILE='topo_20_18C')
! Values are LOG Volume Fraction of Particles EP_P
!-------- Boundaries for Gradient Calculations -----------!
max_dense   = 2.5
min_dense   = 1.5
max_dilute  = 6.5
min_dilute  = 5.5
!-------- Boundaries for Gradient Calculations -----------!

!--------------------------- Constants
!------------------------------------------!
Volume_Unit = 2.*2.*2.  !From your 3D grid dx, dy, dz
gravity = 9.81 !m^2/s
P_const = 1.0e5 !Pa
R_vapor = 461.5 !J/kg K
R_dryair = 287.058 !J kg/K
T_amb    = 273.0 !K
rho_dry  = P_const/(R_dryair*T_amb)  !kg/m**3
char_length = 20.0
mu_g        = 2.0e-5 !Pa s

rho_p = 1950 !kg/m^3
D = 5.0e-5 
stokesv = (2)*(rho_p-rho_dry)*gravity*(D*D)/(9*mu_g)


!-------- Set Size, Timesteps, and write size ------------!
timesteps=4
RMAX=404
ZMAX=152
YMAX=204
length1 = RMAX*ZMAX*YMAX

ALLOCATE( channel_topo(RMAX-4,ZMAX-2))
ALLOCATE( EP_G1(length1, 4))

ALLOCATE( topography(length1))
ALLOCATE( topo2(length1))
ALLOCATE( ZZZ(length1,1))
ALLOCATE( YYY(length1,1))
ALLOCATE( U_G1(length1,timesteps))
ALLOCATE( T_G1(length1, timesteps))
ALLOCATE( SHUY(length1, timesteps))
ALLOCATE( shear(length1, 4))

REWIND(602) 
READ(602,*) channel_topo


REWIND(106)
DO I = 1, length1
   READ(106,*) EP_G1(I,:)
END DO
 ! Format is RMAX*YMAX*ZMAX by timesteps, so loop
! through timesteps


REWIND(101)
DO I=1,timesteps
     READ(101) T_G1(:,I)
END DO

REWIND(102)
DO I=1,timesteps
     READ(102) U_G1(:,I)
END DO

!REWIND(103)
!DO I=1,timesteps
!     READ(103) V_G1(:,I)
!END DO

!REWIND(104)
!DO I=1,timesteps
!    READ(104) W_G1(:,I)
!END DO

!REWIND(110)
!DO I =1,timesteps
!    READ(110) ROP_S1(:,I)
!END DO

!REWIND(170)
!DO I =1,timesteps
!    READ(170) SHUY(:,I)
!END DO

!DO I =1,timesteps
!    READ(180) SHWY(:,I)
!END DO

!DO I =1,timesteps
!    READ(111) U_S1(:,I)
!END DO


!NEW!!! 
DO I = 1, length1
   EP_G1(I,4) = abs(EP_G1(I,4))
END DO


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

stokest = Hstar/stokesv

print*, stokesv
print*, Hstar
print*, stokest
OPEN(610, FILE="Locations.txt", form='formatted')
t=4
tmass = 0 
chmass= 0
chmassd = 0 
theta = 20.0 



! EP_G1( EP_G, XX, YY, ZZ)
! XX length YY height ZZ width

!DO I = 1,length1
!    J = EP_G1(I,2)/2
!    bottom = tand(theta)*2*(400-J)+20-depth
!    top = tand(theta)*2*(400-J)+20
    
        
    !IF (EP_G1(I,3)>bottom) THEN 
        


    !IF (EP_G1(I,1) <0.9999999) THEN
    !    IF (EP_G1(I,1) >0.000) THEN
    !     tmass = tmass + ((1-EP_G1(I,1))*Volume_Unit*rho_p)
         !print*, "Total mass", tmass
         
!              
    !     IF (EP_G1(I,4) >edge1) THEN 
    !     IF (EP_G1(I,4) <edge2) THEN
    !     chmass = chmass + ((1-EP_G1(I,1))*Volume_Unit*rho_p)   
!         print*, "Mass in channel width", chmass
        
    !    IF (EP_G1(I,3)>bottom) THEN
    !    IF (EP_G1(I,3)<top) THEN
    !     chmassd = chmassd + ((1-EP_G1(I,1))*Volume_Unit*rho_p)
        
!         print*, "Mass in channel depth", chmassd




     !   END IF           
     !   END IF
     !   END IF
     !   END IF
     !   END IF
     !   END IF
!END DO

!J = 150

!sum1 = SUM(EP_G1(:,:), DIM=1, MASK= EP_G1(:,4) .EQ. 150)
!print*, sum1

!OPEN(231, FILE='TESTING.txt') 
!ALLOCATE(head(4))

!head(1) = 1
!head(2) = 0 
!head(3) = 0 
!head(4) = 0  


!body = 1
 
!DO I= 1, length1 
! J = 200/2
! bottom = tand(theta)*2*(400-J)+20-depth 
 
!  IF (EP_G1(I,4) .EQ. 150) THEN 
!        IF (EP_G1(I,1) .LT. 1.0 .AND. EP_G1(I,1) .GT. 0.0) THEN
!           IF (EP_G1(I,1)<head(1)) THEN
!                head = EP_G1(I,:)
!END IF 
!END IF 
  
                


!        IF (EP_G1(I,2) .EQ. 200) THEN 
!               IF (EP_G1(I,3) .GT. bottom) THEN
!                IF(EP_G1(I,1) .GT. 0.0 .AND. EP_G1(I,1) .LT. 1.00) THEN
!                WRITE(231,405) EP_G1(I,3), EP_G1(I,1), U_G1(I,t), T_G1(I,t)         
                 
!                END IF
!             END IF
!        END IF 
!   END IF 
!END IF
!END DO 


print*, head

405 FORMAT(5F22.12)

END PROGRAM
