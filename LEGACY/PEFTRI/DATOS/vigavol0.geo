// Gmsh project created on Fri Apr 23 06:25:41 2021
SetFactory("OpenCASCADE");
//+
lc = DefineNumber[ 5, Name "Parameters/lc" ];
//+
Point(1) = {0, 0, 0, lc};
Point(2) = {30.01, 0, 0, lc};
Point(3) = {30.01,1.31, 0, lc};
Point(4) = {15.005+0.65, 1.31, 0, lc};
Point(5) = {15.005+0.65, 34.41-1.31, 0, lc};
Point(6) = {30.01, 34.41-1.31, 0, lc};
Point(7) = {30.01, 34.41, 0, lc};
Point(8) = {0, 34.41, 0, lc};
Point(9) = {0, 34.41-1.31, 0, lc};
Point(10) = {15.005-0.65, 34.41-1.31, 0, lc};
Point(11) = {15.005-0.65, 1.31, 0, lc};
Point(12) = {0, 1.31, 0, lc};
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
Line(8) = {8, 9};
//+
Line(9) = {9, 10};
//+
Line(10) = {10, 11};
//+
Line(11) = {11, 12};
//+
Line(12) = {12, 1};
//+
Curve Loop(1) = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12};
//+
Plane Surface(1) = {1};
//+
Extrude {0, 0, 425} {
  Surface{1};
}
//+
Point(25) = {0, 34.41, 425-10, lc};
//+
Point(26) = {30.01, 34.41, 425-10, lc};
//+
Line(37) = {25, 26};
//+
BooleanFragments{ Volume{1}; Delete; }{ Curve{37}; }
//+
Physical Surface("DISP UX=0 UY=0 UZ=0") = {14};
//+
Physical Surface("PRES WY=-0.08") = {8};
//+
Physical Volume("CATE EYOU=70E3 POIS=0.2") = {1};
//+
