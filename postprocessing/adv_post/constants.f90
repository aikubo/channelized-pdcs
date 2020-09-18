module constants 

DOUBLE PRECISION:: infinity = 1e30
character(5):: simlabel
character(150) :: datatype, filename, routine, description
! Values are LOG Volume Fraction of Particles EP_P
!-------- Boundaries for Gradient Calculations -----------!
DOUBLE PRECISION:: max_dense   = 0.5
DOUBLE PRECISION:: min_dense   = 0.01
DOUBLE PRECISION:: max_dilute  = 2
DOUBLE PRECISION:: min_dilute  = 3.5
!-------- Boundaries for Gradient Calculations -----------!

!--------------------------- Constants
!------------------------------------------!
DOUBLE PRECISION:: dxi
DOUBLE PRECISION:: Volume_Unit  !From your 3D grid dx, dy, dz
DOUBLE PRECISION, PARAMETER:: gravity = 9.81 !m^2/s
DOUBLE PRECISION, PARAMETER:: P_const = 1.0e5 !Pa
DOUBLE PRECISION, PARAMETER::R_vapor = 461.5 !J/kg K
DOUBLE PRECISION, PARAMETER::R_dryair = 287.058 !J kg/K
DOUBLE PRECISION, PARAMETER::T_amb    = 273.0 !K
DOUBLE PRECISION, PARAMETER::rho_dry  = P_const/(R_dryair*T_amb)  !kg/m**3RAMETER
DOUBLE PRECISION, PARAMETER::char_length = 20.0
DOUBLE PRECISION, PARAMETER::mu_g        = 2.0e-5 !Pa s
double precision, parameter:: pi = 3.14159265359
!--------------------------- Constants
!------------------------------------------!

!Gas_Volume(1,1)=1.0 - 1.0e-7
!Gas_Volume(1,2)=1.0 - 1.0e-6
!Gas_Volume(1,3)=1.0 - 1.0e-5
!Gas_Volume(1,4)=1.0 - 1.0e-4
!Gas_Volume(1,5)=1.0 - 1.0e-3

!print *, Gas_Volume(1,1:5)
! --------- Initial Conditions of Mass Flux --------------!
! Get from mfix.dat and input according to run
!updated by AK 11/17
DOUBLE PRECISION, PARAMETER::initial_ep_g  = 0.9
DOUBLE PRECISION, PARAMETER::initial_temp  = 800.0
DOUBLE PRECISION, PARAMETER::ROP1          = 195.0                            !ep_p1*rho_p -->kg/m**3
!ROP2          = 300.0                            !ep_p2*rho_p -->
!kg/m**3
DOUBLE PRECISION, PARAMETER::initial_vel   = sqrt(10.0**2+0.0**2+0.0**2)      !m/s
DOUBLE PRECISION, PARAMETER::Area_flux     = abs((85-75)*(305-295))  !m**2

DOUBLE PRECISION, PARAMETER::CP_Go         = 2294.11                        ! J/(kg K)
DOUBLE PRECISION, PARAMETER::CP_S1o        = 2972.68                        ! J/(kg K)
DOUBLE PRECISION, PARAMETER::CP_S2o        = 2548.01                        ! J/(kg K)

!print *,"Initial Velocity", initial_vel

DOUBLE PRECISION, PARAMETER:: Gas_flux    = initial_ep_g*(P_const/(R_vapor*initial_temp))*Area_flux*initial_vel
!kg/s
DOUBLE PRECISION, PARAMETER:: Solid_flux   = (ROP1)*Area_flux*initial_vel   !kg/s

!WRITE(603,*) "initial vel ", initial_vel
!WRITE(603,*) "area flux ", Area_flux
!WRITE(603,*) "Gas Flux ", Gas_flux, "kg/s"
!WRITE(603,*) "Solid Flux ", Solid_flux, "kg/s"
DOUBLE PRECISION, PARAMETER:: rho_p = 1950
DOUBLE PRECISION, PARAMETER:: D = 5e-5
!stokesv = (2/9)*(rho_p-rho_dry)*gravity*(D**2)/mu_g
!INTEGER, PARAMETER::width = 24
!INTEGER::edge1 = (300/2)-(width/2)
                                                                                 
!INTEGER::depth = 18
!DOUBLE PRECISION, PARAMETER:: u0 = 10.0
!DOUBLE PRECISION, PARAMETER::ROP_0 = 0.10
!DOUBLE PRECISION, PARAMETER::gstar = gravity !ROP_0*gravity*(rho_p/rho_dry)
!DOUBLE PRECISION, PARAMETER::Hstar = (u0*u0)/gstar
!DOUBLE PRECISION, PARAMETER::stokesv =(2/9)*(rho_p-rho_dry)*gravity*D*D/mu_g
!DOUBLE PRECISION, PARAMETER::stokest = Hstar/stokesv

!print*, stokesv
!print*, Hstar
!print*, stokest
DOUBLE PRECISION::tmass = 0
DOUBLE PRECISION::chmass= 0
DOUBLE PRECISION::chmassd = 0
REAL::M  = 20.0

! --------- Initial Conditions of Mass Flux --------------!
INTEGER:: timesteps, RMAX, ZMAX, YMAX, length1

end module constants
