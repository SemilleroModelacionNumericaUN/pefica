// Gmsh project created on Thu Aug 12 11:30:09 2021
SetFactory("OpenCASCADE");
//+
lc = DefineNumber[ 1, Name "Parameters/lc" ];
lc2 = DefineNumber[ 0.2, Name "Parameters/lc2"];
//+
Point(1) = {0, 0, 0, lc};
//+
Point(2) = {0.9, 0, 0, lc};
//+
Point(3) = {0.7, 0.5, 0, lc};
//+
Point(4) = {0, 1, 0, lc};
//+
Point(5) = {0.5, 1, 0, lc};
//+
Line(1) = {1, 2};
//+
Line(2) = {2, 3};
//+
Line(3) = {3, 5};
//+
Line(4) = {5, 4};
//+
Line(5) = {4, 1};
//+
Curve Loop(1) = {1, 2, 3, 4, 5};
//+
Plane Surface(1) = {1};
//+
Physical Curve("DISP UX=0 UY=0") = {1};
//+
Physical Point("LOAD FY=-2") = {4};
//+
Physical Curve("PRES WY=-100") = {4};
//+
Physical Surface("CATE EYOU=20000000 POIS=0.25 TESP=0.2 TIPR=20") = {1};
