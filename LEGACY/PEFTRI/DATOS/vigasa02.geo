// Gmsh project created on Mon Aug  2 18:49:42 2021
SetFactory("OpenCASCADE");
//+
lc = DefineNumber[ 1.2, Name "Parameters/lc" ];
//+
Point(1) = {(29.98/2), 0, 0, lc};
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
Point(8) = {(29.98/2), 34.4, 0, lc};
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
Line(8) = {8, 1};
//+
Curve Loop(1) = {1, 2, 3, 4, 5, 6, 7, 8};
//+
Plane Surface(1) = {1};
//+
Extrude {0, 0, (510/2)+20} {
  Surface{1};
}
//+
Point(25) = {(29.98/2), 0, 510/2, lc};
//+
Point(26) = {29.98, 0, 510/2, lc};
//+
Line(37) = {25, 26};
//+
Point(27) = {(29.98/2), 34.4, (510/2)-(510/3)-1, lc};
//+
Point(28) = {29.98, 34.4, (510/2)-(510/3)-1, lc};
//+
Line(38) = {27, 28};
//+
Point(29) = {(29.98/2), 34.4, (510/2)-(510/3)+1, lc};
//+
Point(30) = {29.98, 34.4, (510/2)-(510/3)+1, lc};
//+
Line(39) = {29, 30};
//+
BooleanFragments{ Volume{1}; Delete; }{ Curve{37}; Curve{38}; Curve{39}; }
//+
Physical Curve("DISP UY=0") = {37};
//+
Physical Surface("DISP UX=0") = {11};
//+
Physical Surface("DISP UZ=0") = {12};
//+
Physical Volume("CATE EYOU=65890 POIS=0.264") = {1};
//+
Physical Surface("PRES WY=-12.17") = {9};
// P=1674N, A=17.2mm * 2mm, wy=P/(4A)
//+
Characteristic Length {44, 42, 46, 40, 36, 33, 38, 34, 26, 25, 30, 28, 29, 27, 43, 41, 45, 39, 35, 32, 37, 31} = lc;
//+
// carga aplicada P= N deflexion max d=mm
