// Gmsh project created on Tue Feb  8 09:52:52 2022
SetFactory("OpenCASCADE");
//+
Point(1) = {0, 0, 0, 0.05};
//+
Point(2) = {0.9, 0, 0, 0.05};
//+
Point(3) = {0.7, 0.5, 0, 0.05};
//+
Point(4) = {0, 1, 0, 0.01};
//+
Point(5) = {0.5, 1, 0, 0.05};
//+
Line(1) = {1, 2};
//+
Line(2) = {2, 3};
//+
Line(3) = {1, 3};
//+
Line(4) = {3, 4};
//+
Line(5) = {4, 1};
//+
Line(6) = {3, 5};
//+
Line(7) = {5, 4};
//+
Curve Loop(1) = {1, 2, -3};
//+
Plane Surface(1) = {1};
//+
Curve Loop(2) = {3, 4, 5};
//+
Plane Surface(2) = {2};
//+
Curve Loop(3) = {4, -7, -6};
//+
Plane Surface(3) = {3};
//+
Physical Point("DISP UX=0 UY=0") = {1, 2};
//+
Physical Point("LOAD FX=0 FY=-2") = {4};
//+
Physical Curve("PRES WX=0 WY=-100") = {7};
//+
Physical Surface("CATE EYOU=20e6 POIS=0.25 TESP=0.2 TIPR=20") = {1, 2, 3};
