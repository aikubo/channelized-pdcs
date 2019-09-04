module viewchannel 

        contains 
        
        subroutine cutaway(numunit, wave)
        use parampost
        use constants
        use formatmod
        implicit none 
        INTEGER, INTENT(IN):: numunit, wave
        INTEGER:: fid
        REAL:: sinuous, center 
        REAL:: amprat, amp, deltz, loc
        DOUBLE PRECISION, ALLOCATABLE:: EP_Pcut(:,:)

        ALLOCATE(EP_Pcut(length1,timesteps))
       

        amprat= .15
        deltz=3
        amp=real(wave)*amprat
        center=450
       
        do t=tstart,tstop        
        I=1
        do rc=1,RMAX
                do yc=1,YMAX
                        do zc=1,ZMAX
                               loc=(360*(real(rc)/real(wave)))
                               sinuous=amp*sind(loc)+center
                               print*, sinuous 
                               !I  = 1 + (yc-1) +(rc-1)*(YMAX-1+1) +(zc-1)*(YMAX-1+1)*(RMAX-1+1)
                                
                                IF (EP_P(I,4,t) > sinuous) THEN
                                        EP_Pcut(I,t) = 0

                                else 
                                        EP_Pcut(I,t) = EP_P(I,1,t)
                                end if 
               
!                                print*, EP_Pcut(I,t) 

                                I=I+1
                        end do 
                end do 
        end do 
        end do 

        print*, "finished cutting"

        do t=1,timesteps
                fid=numunit+t
                do  I=1,length1
                        
                        write(fid ,format4var) EP_Pcut(I,t), XXX(I,1), YYY(I,1), ZZZ(I,1) 
                end do
        end do 

        end subroutine 
end module
