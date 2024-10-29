Gid Post Results File 1.0 
### 
# PEFICA-Octave postproceso para GiD 
# 
GaussPoints "GP" Elemtype Line 
Number of Gauss Points: 1 
Natural Coordinates: Internal 
end gausspoints 
# 
Result "Displacement" "Load Analysis"  1  Vector OnNodes 
ComponentNames "UX", "UY" 
Values 
     1   +0.000000e+00   +0.000000e+00 
     2   +1.687500e-03   -3.921875e-03 
     3   +2.625000e-03   +0.000000e+00 
     4   +3.892361e-03   -3.570313e-03 
     5   +2.579861e-03   -3.289063e-03 
End Values 
# 
Result "Resultados" "Load Analysis" 1 Vector OnGaussPoints "GP" 
ComponentNames "EPXX", "STXX", "NFXX" 
Values 
     1   +2.812500e-04   +5.625000e+04   +1.125000e+02 
     2   +1.562500e-04   +3.125000e+04   +6.250000e+01 
     3   -2.187500e-04   -4.375000e+04   -8.750000e+01 
     4   -1.041667e-04   -2.083333e+04   -2.083333e+01 
     5   -2.083333e-04   -4.166667e+04   -4.166667e+01 
     6   +2.083333e-04   +4.166667e+04   +4.166667e+01 
     7   -5.208333e-04   -1.041667e+05   -1.041667e+02 
End Values 
# 
