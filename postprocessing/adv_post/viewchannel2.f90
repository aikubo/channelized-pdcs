module viewchannel 

        contains 
        
        subroutine cutaway(numunit, wave)
        use parampost
        use constants
        use formatmod
        implicit none 
        INTEGER, INTENT(IN):: numunit, wave
        INTEGER:: fid
        DOUBLE PRECISION:: sinuous, center 
        DOUBLE PRECISION:: amprat, amp, deltz
        REAL:: loc
        DOUBLE PRECISION, ALLOCATABLE:: EP_Pcut(:,:)

        ALLOCATE(EP_Pcut(length1,timesteps))
       

        amprat= .15
        deltz=3.
        amp=dble(wave)*amprat
        center=450.
       
        do t=tstart,tstop 
        I=1
        do rc=1,RMAX
                do yc=1,YMAX
                        do zc=1,ZMAX
                               loc=(360*(real(rc)/real(wave)))
                               sinuous=amp*dble(sind(loc))
                               !print*, sinuous
                               
                                EP_Pcut(I,t)=ZZZ(I,t)+sinuous
                                                                

 
                               I=I+1
                        end do 
                end do 
        end do 
        end do 

        print*, "finished cutting"

        do t=tstart,tstop
                fid=numunit+t
                do  I=1,length1
                        
                        write(fid ,format4var) EP_P(I,1,t), XXX(I,1), YYY(I,1), EP_Pcut(I,t) 
                end do
        end do 

        end subroutine 
end module
