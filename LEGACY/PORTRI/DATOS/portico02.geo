// Gmsh project created on Sun Feb  7 05:47:05 2021
SetFactory("OpenCASCADE");
//+
lc = DefineNumber[ 100, Name "Parameters/lc" ];
//+
Point(1) = {0,0, 3.00, lc};
//+
Point(2) = {5.00,0, 3.00, lc};
//+
Point(3) = {0,0,0, lc};
//+
Point(4) = {0, 3.00, 3.00, lc};
//+
Line(1) = {1, 2};
//+
Line(2) = {4, 1};
//+
Line(3) = {3, 1};
//+
Physical Point("DISP UX=0 UY=0 UZ=0 RX=0 RY=0 RZ=0") = {2, 3, 4};
//+
Physical Point("LOAD FY=90") = {1};
//+
Physical Curve("CATE EYOU=22E6 POIS=0.30 RECZ=0.30 RECY=0.40 WYLO=-34") = {1};
//+
Physical Curve("CATE EYOU=22E6 POIS=0.30 RECZ=0.30 RECY=0.50 WYLO=-42") = {2};
//+
Physical Curve("CATE EYOU=22E6 POIS=0.30 RECZ=0.30 RECY=0.45") = {3};
