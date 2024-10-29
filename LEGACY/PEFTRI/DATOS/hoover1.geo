// Gmsh project created on Wed Jul 17 19:36:53 2019
SetFactory("OpenCASCADE");
//+
lc=15;
Point(1) = {0, 0, 0, lc};
//+
Point(2) = {0, -46, 0, lc};
//+
Point(3) = {220, -46, 0, lc};
//+
Point(4) = {220, -15, 0, lc};
//+
Point(5) = {235, -15, 0, lc};
//+
Point(6) = {235, 0, 0, lc};
//+
Point(7) = {220, 0, 0, lc};
//+
Point(8) = {137.1795, 185.1281, 0, lc};
//+
Point(9) = {135, 195.3372, 0, lc};
//+
Point(10) = {135, 220, 0, lc};
//+
Point(11) = {90, 220, 0, lc};
//+
Line(1) = {1, 2};
//+
Line(2) = {2, 3};
//+
Line(3) = {3, 4};
//+
Line(4) = {4, 5};
//+
Line(5) = {5, 6};
//+
Line(6) = {6, 7};
//+
Line(7) = {7, 8};
//+
Line(8) = {9, 10};
//+
Line(9) = {10, 11};
//+
Line(10) = {8, 9};
//+
Point(12) = {30.6219, 50.0239, 0, 1.0};
//+
Point(13) = {80.5845, 150.6025, 0, 1.0};
//+
BSpline(11) = {1, 12, 13, 11};


//+
Curve Loop(1) = {8, 9, -11, 1, 2, 3, 4, 5, 6, 7, 10};
//+
Plane Surface(1) = {1};
//+
Extrude {{0, 1, 0}, {409.5856, 0, 0}, 197988749*Pi/500000000} {
  Surface{1};
}
//+
Physical Volume("CATE EYOU=45436450.56 POIS=0.21 GAMM=24") = {1};
//+
Physical Surface("DISP UZ=0") = {1};
//+
Physical Surface("DISP UX=0 UY=0 UZ=0") = {7, 8, 9, 13, 5, 6};
//+
Physical Surface("PRES GAWA=9.81 HEWA=180") = {4};
