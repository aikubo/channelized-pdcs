module formatmod
implicit none
100 FORMAT(F22.12,3ES22.5,F22.12)
101 FORMAT(i7)
102 FORMAT(i7,1X(3ES22.5),1X,i7)
103 FORMAT(i7,1X(6ES22.5),1X,i7)
400 FORMAT(4F22.12)
401 FORMAT(4F22.12,1x,ES22.5)
300 FORMAT(6F22.12)
301 FORMAT(11F22.10)
302 FORMAT(8F22.10,ES22.7,7F22.10)
502 FORMAT(10F22.10)
308 FORMAT(9F22.12)
311 FORMAT(11F22.12)
802 FORMAT(i7,F22.5)
805 FORMAT(6F22.5,3i7)
806 FORMAT(7F22.5,3i7)
803 FORMAT(1X(5ES22.5),1X(3F22.12))
407 FORMAT(7F22.12,2i7)
405 FORMAT(6F22.12)
403 FORMAT(2F22.12)

end formatmod
