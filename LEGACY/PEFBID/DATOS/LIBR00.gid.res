Gid Post Results File 1.0 
### 
# PEFICA-Octave postproceso para GiD 
# 
GaussPoints "GP" Elemtype Triangle 
Number of Gauss Points: 1 
Natural Coordinates: Internal 
end gausspoints 
# 
Result "Displacement" "Load Analysis"      1 Vector OnNodes 
ComponentNames "UX", "UY" 
Values 
     1   +0.000000e+00   +0.000000e+00 
     2   +0.000000e+00   +0.000000e+00 
     3   -1.324856e-07   -1.321822e-06 
     4   -2.820889e-06   -6.604264e-06 
     5   -2.466069e-06   -4.185510e-06 
End Values 
# 
Result "Forces" "Load Analysis"      1 Vector OnNodes 
ComponentNames "FX", "FY" 
Values 
     1   +5.565876e-01   +1.041148e+01 
     2   -5.565876e-01   +3.841852e+00 
     3   +0.000000e+00   -1.213333e+00 
     4   +0.000000e+00   -7.823333e+00 
     5   +0.000000e+00   -5.216667e+00 
End Values 
# 
Result "Stress" "Load Analysis"      1 Vector OnGaussPoints "GP" 
ComponentNames "STXX", "STYY", "STXY" 
Values 
     1   -1.409943e+01   -5.639772e+01   -2.119770e+00 
     2   +3.724580e+00   -1.311541e+02   +6.500432e-02 
     3   -5.087004e+00   -7.711922e+01   +3.633574e+00 
End Values 
# 
Result "Principal Stress" "Load Analysis"      1 Vector OnGaussPoints "GP" 
ComponentNames "STP1", "STP2", "STP3" 
Values 
     1   +0.000000e+00   -1.399346e+01   -5.650369e+01 
     2   +3.724611e+00   +0.000000e+00   -1.311542e+02 
     3   +0.000000e+00   -4.904177e+00   -7.730205e+01 
End Values 
# 
Result "Strain" "Load Analysis"      1 Vector OnGaussPoints "GP" 
ComponentNames "EPXX", "EPYY", "EPXY" 
Values 
     1   +0.000000e+00   -2.643643e-06   -2.649713e-07 
     2   +1.825656e-06   -6.604264e-06   +8.125539e-09 
     3   +7.096401e-07   -3.792373e-06   +4.541968e-07 
End Values 
# 
Result "Principal Strain" "Load Analysis"      1 Vector OnGaussPoints "GP" 
ComponentNames "EPP1", "EPP2", "EPP3" 
Values 
     1   +8.812144e-07   +6.622898e-09   -2.650266e-06 
     2   +1.825658e-06   +1.592869e-06   -6.604265e-06 
     3   +1.027578e-06   +7.210667e-07   -3.803800e-06 
End Values 
# 
Result "Other results" "Load Analysis"      1 Scalar OnGaussPoints "GP" 
ComponentNames "STVM" 
Values 
     1   +5.096863e+01 
     2   +1.330556e+02 
     3   +7.497036e+01 
End Values 
# 
