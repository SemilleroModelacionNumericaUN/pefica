// Gmsh project created on Mon Aug  2 18:49:42 2021
SetFactory("OpenCASCADE");
//+
lc = DefineNumber[ 2, Name "Parameters/lc" ];
//+
Point(1) = {0, 0, 0, lc};
//+
Point(2) = {29.98, 0, 0, lc};
//+
Point(3) = {29.98, 1.2, 0, lc};
//+
Point(4) = {(29.98/2)+0.6, 1.2, 0, lc};
//+
Point(5) = {(29.98/2)+0.6, 34.4-1.2, 0, lc};
//+
Point(6) = {29.98, 34.4-1.2, 0, lc};
//+
Point(7) = {29.98, 34.4, 0, lc};
//+
Point(8) = {0, 34.4, 0, lc};
//+
Point(9) = {0, 34.4-1.2, 0, lc};
//+
Point(10) = {(29.98/2)-0.6, 34.4-1.2, 0, lc};
//+
Point(11) = {(29.98/2)-0.6, 1.2, 0, lc};
//+
Point(12) = {0, 1.2, 0, lc};
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
Extrude {0, 0, (510/2)+20} {
  Surface{1};
}
//+
Point(25) = {0, 0, 510/2, lc};
//+
Point(26) = {29.98, 0, 510/2, lc};
//+
Line(37) = {25, 26};
//+
Point(27) = {0, 34.4, (510/2)-(510/3), lc};
//+
Point(28) = {29.98, 34.4, (510/2)-(510/3), lc};
//+
Line(38) = {27, 28};
//+
BooleanFragments{ Volume{1}; Delete; }{ Curve{37}; Curve{38}; }
//+
Physical Curve("DISP UY=0") = {37};
//+
Physical Curve("DISP UY=-1") = {38};
//+
Physical Surface("DISP UZ=0") = {15};
//+
Physical Volume("CATE EYOU=70000 POIS=0.2") = {1};
//+
Characteristic Length {42, 40, 38, 48, 34, 31, 44, 46, 36, 50, 52, 32, 26, 25, 28, 27, 41, 39, 37, 47, 33, 30, 43, 45, 35, 49, 51, 29} = lc;
//+
// carga aplicada P=776.42 N deflexion max d=1.13637mm
