SetFactory("OpenCASCADE");
//+
lc = DefineNumber[ 100, Name "Parameters/lc" ];
//+
Point(1) = {0, 0, 0, lc};
//+
Point(2) = {6, 0, 0, lc};
//+
Point(3) = {12, 0, 0, lc};
//+
Point(4) = {3, 4, 0, lc};
//+
Point(5) = {9, 4, 0, lc};
//+
Line(1) = {1, 2};
//+
Line(2) = {2, 3};
//+
Line(3) = {4, 5};
//+
Line(4) = {1, 4};
//+
Line(5) = {4, 2};
//+
Line(6) = {2, 5};
//+
Line(7) = {5, 3};
//+
//+
Physical Curve("CATE EYOU=200E6 AREA=0.002") = {1, 2, 3};
//+
Physical Curve("CATE EYOU=200E6 AREA=0.001") = {4, 5, 6, 7};
//+
Physical Point("DISP UX=0 UY=0", 8) = {1};
//+
Physical Point("DISP UY=0", 9) = {3};
//+
Physical Point("LOAD FX=100 FY=-50", 10) = {4};
//+
Physical Point("LOAD FY=-50", 11) = {5};
