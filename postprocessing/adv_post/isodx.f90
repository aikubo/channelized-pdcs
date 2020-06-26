module isodx
    use parampost 
    use constants
    use var_3d
    use handletopo
    use formatmod

    contains 
        subroutine makeisogreatagain
            double precision:: isoden, isodil
            double precision, allocatable:: iso1, iso2 
            allocate(iso1(length1,timesteps))
            allocate(iso2(length1,timesteps))
            isoden=2
            isodil=8 
            open(345, file="iso1.txt", form='formatted')
            do t=1,timesteps
                do i=1,length1

                    if (EP_P(i,t) .gt. isodil .or. EP_P(i,t) .lt. dble(0.1)) then 
                        iso1(i,t)=0
                        iso2(i,t)=0
                    elseif (EP_P(i,t) .gt. isoden)
                        iso2(i,t)=0
                    else 
                        iso1(i,t)=EP_P(i,t)
                        iso2(i,t)=EP_P(i,t)
                    end if
                end do 
            end do 

            do i=1,length1
                write(345,format4var) iso1(i,8), XXX(I,1), YYY(I,1), ZZZ(I,1)
            end do 

        end subroutine
end module