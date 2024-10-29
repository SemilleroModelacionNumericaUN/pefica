// Gmsh project created on Mon Oct 28 09:12:24 2019
SetFactory("OpenCASCADE");
lf=2.00;
lc=0.50;
lp=0.10;
//+
Point(1) = {0, 0, 0, lf};
Point(2) = {16, 0, 0, lf};
Point(3) = {0, 12, 0, lc};
Point(4) = {16, 12, 0, lf};
Point(5) = {0, 16, 0, lp};
Point(6) = {2, 16, 0, lp};
Point(7) = {4, 16, 0, lp};
Point(8) = {16, 16, 0, lf};
//+
Line(1) = {1, 2};
Line(2) = {3, 4};
Line(3) = {5, 6};
Line(4) = {6, 7};
Line(5) = {7, 8};
Line(6) = {1, 3};
Line(7) = {3, 5};
Line(8) = {2, 4};
Line(9) = {4, 8};
//+
Curve Loop(1) = {1, 8, -2, -6};
Plane Surface(1) = {1};
Curve Loop(2) = {2, 9, -5, -4, -3, -7};
Plane Surface(2) = {2};
//+
Physical Curve("DISP UX=0 UY=0") = {1};
Physical Curve("DISP UX=0") = {6, 7, 8, 9, 14};
Physical Curve("PRES WY=-1") = {3};
//+
Physical Surface("CATE EYOU=14E3 POIS=0.20 TESP=1 TIPR=21") = {2};
Physical Surface("CATE EYOU=69E3 POIS=0.30 TESP=1 TIPR=21") = {1};
//+
