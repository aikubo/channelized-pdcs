module filehead

        contains 

        subroutine headerf(numunit, filename, simlabel, routine, DESCRIPTION, datatype)

        implicit none 
        integer, intent(in) :: numunit 
        character(len=*), intent(in) :: routine, simlabel, filename
        character(len=*), intent(IN):: DESCRIPTION, datatype
        character(8)  :: date
        character(10) :: time
        character(5)  :: zone
        integer,dimension(8) :: values

        call date_and_time(date, time, zone, values)

    write(numunit, '(A)') "!------------------------------------------------------------!"
    write(numunit, '(A,A)') "  Date: ", date
    write(numunit, '(A,A)') "  Simulation name: ", simlabel
    write(numunit, '(A,A)') "  Filename:", filename   
    write(numunit, '(A,A)') "  Produced in mod-subroutine:  ", routine 
    write(numunit, '(A)')   "  Written by AK September 2019"
    write(numunit, '(A,A)') "  Description:", description
    write(numunit, '(A,A)') "  Data format:", datatype   
    write(numunit, '(A)') "!------------------------------------------------------------!"

        end subroutine 
end module 
