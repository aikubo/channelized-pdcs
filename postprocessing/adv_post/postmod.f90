!!
!! parampost 
!! declares all variables for use in post processing 
!! written by A Kubo starting 7/2019

module parampost

INTEGER :: t1,t2, clock_rate, clock_max
CHARACTER(LEN=1) :: junk
INTEGER:: MAX_REC = 1e9
INTEGER:: count1,num_open,sum1,sum2
INTEGER:: ios, int_temp,int_check,int_pos1,int_min1,int_pos2,int_min2

INTEGER::yc,I,J,K,THMAX,rc,zc,tc,t,I_yp1,I_ym1,I_zp1,I_zm1,I_xp1,I_xm1,temp_rc
INTEGER::write_end,loop_open,fid_temp,fid_EP_P,fid_EP_G,fid_U,fid_ISO6,fid_GRAD4pt, fid_GRADsize,fid_GradV,fid_GradE
INTEGER::fid_EP_G_t,fid_U_t,fid_ISO3,fid_Ri,fid_ROP1,fid_Dot,fid_dpu,fid_dpv
INTEGER:: fide, fidy, fidw
INTEGER::Z_minus,Z_plus,X_minus,Y_plus,Z_total,I_local

DOUBLE PRECISION,ALLOCATABLE::EP_P(:,:,:),Iso_6(:,:,:), dpu(:,:,:), dpv(:,:,:)
DOUBLE PRECISION,ALLOCATABLE::Iso_3(:,:,:),four_point_Iso3(:,:,:),four_point(:,:,:)
DOUBLE PRECISION, ALLOCATABLE :: T_G(:,:,:),U_G(:,:,:),VEL_6(:,:,:),VEL_3(:,:,:),VEL_ALL(:,:,:), VEL_temp(:,:), VEL_temp2(:,:),Richardson(:,:,:)
DOUBLE PRECISION, ALLOCATABLE :: Ri_Dilute(:,:,:),Ri_Dense(:,:,:),char_dense(:), char_dilute(:),VEL_DENSE(:,:),VEL_DILUTE(:,:)


DOUBLE PRECISION, ALLOCATABLE::topo2(:),topography(:),EP_G1(:,:),XXX(:,:),YYY(:,:),ZZZ(:,:)
DOUBLE PRECISION, ALLOCATABLE :: T_G1(:,:),V_G1(:,:),U_G1(:,:),W_G1(:,:),T_S1(:,:),C_PG(:,:),C_PS1(:,:),C_PS2(:,:)
DOUBLE PRECISION, ALLOCATABLE :: ROP_S1(:,:), U_S1(:,:), SHUY(:,:),SHWY(:,:), V_S1(:,:)

INTEGER, ALLOCATABLE::Location_I(:,:)

DOUBLE PRECISION, ALLOCATABLE ::XX(:,:,:),YY(:,:,:),ZZ(:,:,:),channel_topo(:,:)
DOUBLE PRECISION, ALLOCATABLE ::DY(:),y(:),x(:),theta(:),z(:),DX(:),DTH(:),DZ(:),GZ(:)
DOUBLE PRECISION:: y_boundary,sum_p1, sum_p2, sum_p3,sum_p4,sum_mass,sum_E1,sum_E2,sum_EG
!DOUBLE PRECISION:: P_const, R_vapor, R_dryair,char_length,Reynolds_N,rho_g,mu_g,rho_dry, rho_p,T_amb
DOUBLE PRECISION:: max_mag, current_density,top,bottom !, max_dilute,min_dilute, max_dense, min_dense
!DOUBLE PRECISION::initial_ep_g,ROP1,ROP2,initial_vel,initial_temp,Area_flux,Gas_flux,Solid_flux,gravity,temp_val,local_vel
DOUBLE PRECISION::c_pos1, c_pos2, c_min1, c_min2, delta_V1, delta_V3,shear_v,delta_rho, Ri
!DOUBLE PRECISION::Gas_Volume(1,5),Volume_Unit,Energy_In_G, CP_Go,Energy_In_S1,CP_S1o, Energy_In_S2, CP_S2o
DOUBLE PRECISION::mag_grad,norm_grad(1,3),temp_dot

!DOUBLE PRECISION:: tmass, chmass, chmassd, inchannelw, inchanneld
!REAL:: M
!INTEGER:: ind1, edge1, edge2, width, depth, bins, fid_shea
!DOUBLE PRECISION:: D, U0, ROP_0, gstar, Hstar, stokest, stokesv
DOUBLE PRECISION:: avgt, avgt2, avgt3, avgu, avgu2, avgu3, avgv, avgv2,avgv3, avgw, avgw2, avgw3, avgus, avgus2, avgus3, sum_1, sum_2, sum_3
DOUBLE PRECISION:: avgdpu, avgdpu3, avgdpu2

end module parampost
