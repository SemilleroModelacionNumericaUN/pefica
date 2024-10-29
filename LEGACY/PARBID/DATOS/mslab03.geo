// Gmsh project created on Wed May 20 14:23:15 2020
SetFactory("OpenCASCADE");
//+
lc = DefineNumber[ 100, Name "Parameters/lc" ];
//+
Point(1) = {0, 0, 0, lc};
//+
Point(2) = {0.25, 0.10, 0, lc};
//+
Point(3) = {0.25, 0.0, 0, lc};
//+
Point(4) = {0.50, 0.20, 0, lc};
//+
Point(5) = {0.50, 0.0, 0, lc};
//+
Point(6) = {0.75, 0.3, 0, lc};
//+
Point(7) = {0.75, 0.0, 0, lc};
//+
Point(8) = {1.0, 0.2, 0, lc};
//+
Point(9) = {1.0, 0.0, 0, lc};
//+
Point(10) = {1.25, 0.10, 0, lc};
//+
Point(11) = {1.25, 0.0, 0, lc};
//+
Point(12) = {1.5, 0.0, 0, lc};
//+
Line(1) = {1, 3};
//+
Line(2) = {3, 5};
//+
Line(3) = {5, 7};
//+
Line(4) = {7, 9};
//+
Line(5) = {9, 11};
//+
Line(6) = {11, 12};
//+
Line(7) = {1, 2};
//+
Line(8) = {2, 4};
//+
Line(9) = {4, 6};
//+
Line(10) = {6, 8};
//+
Line(11) = {8, 10};
//+
Line(12) = {10, 12};
//+
Line(13) = {3, 2};
//+
Line(14) = {2, 5};
//+
Line(15) = {5, 4};
//+
Line(16) = {4, 7};
//+
Line(17) = {7, 6};
//+
Line(18) = {7, 8};
//+
Line(19) = {8, 9};
//+
Line(20) = {9, 10};
//+
Line(21) = {10, 11};
//+
Physical Point("DISP UX=0 UY=0") = {1};
//+
Physical Point("DISP UY=0") = {12};
//+
Physical Point("LOAD FY=-1") = {5, 7, 9};
//+
Physical Curve("CATE EYOU=200E6 AREA=31.67E-6") = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21};
