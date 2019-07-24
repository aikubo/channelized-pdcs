module convb
USE CONSTANTS
USE parampost
IMPLICIT NONE 

contains 
   ____ function convertb(X, fid)
        DO I=1,timesteps 
                READ(fid) X(:,I)
        END DO 
   END function convertb 

end module convb
        
