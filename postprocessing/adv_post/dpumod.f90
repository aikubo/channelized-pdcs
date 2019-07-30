module dpumod 
        use parampost 
        use constants
        use makeascii
        
        contains  
        
        subroutine dpu

        call openascii(1400, 'dpu_t')
        

        ! ---- dynamic pressure calculation ----! 
        DO t = 1,timesteps
                fid_dpu = 1400+t
                !fid_dpv = 1500+t
                DO I =1,ZMAX*RMAX*YMAX

                        dpu(I,t) = 0.5*ROP_S1(I,t)*U_S1(I,t)*U_S1(I,t)
                 !       dpv(I,t) = 0.5*ROP_S1(I,t)*((V_S1(I,t))**2)
                        WRITE(fid_dpu, 400) dpu(I,t), XXX(I,1),YYY(I,1),ZZZ(I,1)
                 !       WRITE(fid_dpv, 400) dpv(I,t), XXX(I,1),YYY(I,1),ZZZ(I,1)
                end do
        end do
        400 FORMAT(4F22.12)

        end subroutine dpu


end module dpumod 

