// Gmsh project created on Wed Oct 31 11:07:05 2018
// longitudes en m y fuerzas en kN
SetFactory("Opencascade");
lc=4.0;
Point(1) = {0, 0, 0, lc};
Point(6) = {1.625,39.0, 0, lc};
Point(5) = {1.625,103.0, 0, lc};
Point(4) = {16.425,103.0, 0, lc};
Point(3) = {22.005,66.5, 0, lc};
Point(2) = {70.2,0, 0, lc};
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 5};
Line(5) = {5, 6};
Line(6) = {6, 1};
Curve Loop(1) = {1, 2, 3, 4, 5, 6};
Plane Surface(1) = {1};
Physical Curve("DISP UX=0 UY=0") = {1};
Physical Curve("PRES GAWA=9.80 HEWA=90.0") = {5, 6};
Physical Surface("CATE EYOU=20E6  POIS=0.25 GAMM=23.0 TESP=1.0 TIPR=21") = {1};
