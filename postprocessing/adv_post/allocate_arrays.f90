       SUBROUTINE ALLOCATE_ARRAYS 

                use parampost 
                use constants 

                IMPLICIT NONE

!----------------------Allocate the conversion
!variables-------------------------!
        ALLOCATE( channel_topo(RMAX-4,ZMAX-2))
        ALLOCATE( EP_G1(length1,timesteps))
        ALLOCATE( T_G1(length1,timesteps))
        ALLOCATE( V_G1(length1,timesteps))
        ALLOCATE( U_G1(length1,timesteps))
        ALLOCATE( W_G1(length1,timesteps))
        ALLOCATE( U_S1(length1, timesteps))

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

        


!----------------------Allocate the Gradient
!variables-------------------------!
        ALLOCATE(EP_P(length1,4,timesteps))
        ALLOCATE(T_G(length1,4,timesteps))
        ALLOCATE(U_G(length1,6,timesteps))
        ALLOCATE(Richardson(length1,5,timesteps))
        ALLOCATE(SHUY(length1,4,timesteps))

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

        ALLOCATE(dpu(length1, 4, timesteps))
        ALLOCATE(dpv(length1, 4, timesteps))
!----------------------Allocate the Gradient
!variables-------------------------!
END SUBROUTINE ALLOCATE_ARRAYS


