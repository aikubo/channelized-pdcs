!! test module 

module test 
implicit none
subroutine createtestdata(X,Y,Z)
    integer, intent(in):: X,Y,Z 
    integer:: midx, midy, midz
    
    midx=X/2 
    midy=y/2
    midz=z/2
    
    
    for i=1,X*Y*Z:
        
    
