// Gmsh project created on Wed Oct 28 08:16:08 2020
SetFactory("OpenCASCADE");
//+
lc = DefineNumber[ 100, Name "Parameters/lc" ];
//+
Point(1) = {0, 0, 0, lc};
//+
Point(2) = {5, 0, 0, lc};
//+
Point(3) = {0, 3, 0, lc};
//+
Point(4) = {5, 3, 0, lc};
//+
Point(5) = {0, 6, 0, lc};
//+
Point(6) = {5, 6, 0, lc};
//+
Line(1) = {1, 3};
//+
Line(2) = {3, 5};
//+
Line(3) = {2, 4};
//+
Line(4) = {4, 6};
//+
Line(5) = {3, 4};
//+
Line(6) = {5, 6};
//+
Physical Point("DISP UX=0 UY=0 RZ=0") = {1, 2};
//+
Physical Point("LOAD FX=10") = {3};
//+
Physical Point("LOAD FX=20") = {5};
//+
Physical Curve("PRES WY=-5") = {5, 6};
//+
Physical Curve("CATE EYOU=20E6 POIS=0.3 AREA=0.02 INER=0.01") = {1, 2, 3, 4, 5, 6};
