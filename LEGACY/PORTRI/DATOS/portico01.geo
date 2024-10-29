// Gmsh project created on Sun Feb  7 05:47:05 2021
SetFactory("OpenCASCADE");
//+
lc = DefineNumber[ 100, Name "Parameters/lc" ];
//+
Point(1) = {0, 0, 3.00, lc};
//+
Point(2) = {0, 0, 0, lc};
//+
Point(3) = {0, 4.8, 3.0, lc};
//+
Point(4) = {5.6, 0, 3.0, lc};
//+
Line(1) = {2, 1};
//+
Line(2) = {1, 4};
//+
Line(3) = {1, 3};
//+
Physical Point("DISP UX=0 UY=0 UZ=0 RX=0 RY=0 RZ=0") = {4, 2, 3};
//+
Physical Curve("CATE EYOU=22E6 POIS=0.294 RECY=0.4 RECZ=0.5") = {1};
//+
Physical Curve("CATE EYOU=22E6 POIS=0.294 RECY=0.6 RECZ=0.5 WYLO=20") = {2};
//+
Physical Curve("CATE EYOU=22E6 POIS=0.294 AREA=0.24 INEY=0.0032 INEZ=0.0072 JTOR=0.0075125 WYLO=20") = {3};
Physical Point("LOAD FX=10 FY=20") = {1};
