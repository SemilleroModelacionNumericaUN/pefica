// Gmsh project created on Thu Oct 29 16:06:49 2020
SetFactory("OpenCASCADE");
//+
lc = DefineNumber[ 100, Name "Parameters/lc" ];
//+
Point(1) = {0, 0, 0, lc};
//+
Point(2) = {0, 20, 0, lc};
//+
Point(3) = {20, 10, 0, lc};
//+
Point(4) = {10, 5, 10, lc};
//+
Point(5) = {10, 15, 10, lc};
//+
Line(1) = {1, 4};
//+
Line(2) = {2, 4};
//+
Line(3) = {4, 5};
//+
Line(4) = {5, 3};
//+
Line(5) = {5, 2};
//+
Line(6) = {4, 3};
//+
Physical Point("DISP UX=0 UY=0 UZ=0") = {2, 1, 3};
//+
Physical Point("LOAD FX=80") = {4};
//+
Physical Point("LOAD FY=40") = {5};
//+
Physical Curve("CATE EYOU=200E6 POIS=0.3 AREA=0.01") = {1, 2, 3, 4, 5, 6};
