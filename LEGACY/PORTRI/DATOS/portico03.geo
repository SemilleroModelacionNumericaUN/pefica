// Gmsh project created on Wed Feb 10 13:25:34 2021
SetFactory("OpenCASCADE");
//+
lc = DefineNumber[ 100, Name "Parameters/lc" ];
//+
Point(1) = {0, 0, 0, lc};
//+
Point(2) = {6, 0, 0, lc};
//+
Point(3) = {6+9, 0, 0, lc};
//+
Point(4) = {6+9+6, 0, 0, lc};
//+
Point(5) = {0, 7, 0, lc};
//+
Point(6) = {6, 7, 0, lc};
//+
Point(7) = {6+9, 7, 0, lc};
//+
Point(8) = {6+9+6, 7, 0, lc};
//+
Point(9) = {0, 0, 4.2, lc};
//+
Point(10) = {6, 0, 4.2, lc};
//+
Point(11) = {6+9, 0, 4.2, lc};
//+
Point(12) = {6+9+6, 0, 4.2, lc};
//+
Point(13) = {0, 7, 4.2, lc};
//+
Point(14) = {6, 7, 4.2, lc};
//+
Point(15) = {6+9, 7, 4.2, lc};
//+
Point(16) = {6+9+6, 7, 4.2, lc};
//+
Point(17) = {0, 0, 4.2+3.8, lc};
//+
Point(18) = {6, 0, 4.2+3.8, lc};
//+
Point(19) = {6+9, 0, 4.2+3.8, lc};
//+
Point(20) = {6+9+6, 0, 4.2+3.8, lc};
//+
Point(21) = {0, 7, 4.2+3.8, lc};
//+
Point(22) = {6, 7, 4.2+3.8, lc};
//+
Point(23) = {6+9, 7, 4.2+3.8, lc};
//+
Point(24) = {6+9+6, 7, 4.2+3.8, lc};
//+
Line(1) = {1, 9};
//+
Line(2) = {2, 10};
//+
Line(3) = {3, 11};
//+
Line(4) = {4, 12};
//+
Line(5) = {5, 13};
//+
Line(6) = {6, 14};
//+
Line(7) = {7, 15};
//+
Line(8) = {8, 16};
//+
Line(9) = {9, 17};
//+
Line(10) = {10, 18};
//+
Line(11) = {11, 19};
//+
Line(12) = {12, 20};
//+
Line(13) = {13, 21};
//+
Line(14) = {14, 22};
//+
Line(15) = {15, 23};
//+
Line(16) = {16, 24};
//+
Line(17) = {9, 10};
//+
Line(18) = {10, 11};
//+
Line(19) = {11, 12};
//+
Line(20) = {13, 14};
//+
Line(21) = {14, 15};
//+
Line(22) = {15, 16};
//+
Line(23) = {9, 13};
//+
Line(24) = {10, 14};
//+
Line(25) = {11, 15};
//+
Line(26) = {12, 16};
//+
Line(27) = {17, 18};
//+
Line(28) = {18, 19};
//+
Line(29) = {19, 20};
//+
Line(30) = {21, 22};
//+
Line(31) = {22, 23};
//+
Line(32) = {23, 24};
//+
Line(33) = {17, 21};
//+
Line(34) = {18, 22};
//+
Line(35) = {19, 23};
//+
Line(36) = {20, 24};
//+
Physical Point("DISP UX=0 UY=0 UZ=0 RX=0 RY=0 RZ=0") = {1, 2, 3, 4, 5, 6, 7, 8};
//+
//Physical Point("LOAD FY=25") = {9, 10, 11, 12};
//+
//Physical Point("LOAD FY=50") = {17, 18, 19, 20};
//+
Physical Curve("CATE EYOU=20E6 POIS=0.2 PIBZ=0.384 PIHY=0.785 PITW=0.0197 PITF=0.0335") = {1, 2, 3, 4, 8, 7, 6, 5, 9, 10, 11, 12, 13, 14, 15, 16};
//+
Physical Curve("CATE EYOU=20E6 POIS=0.2 RECZ=0.3 RECY=0.3") = {23, 24, 25, 26, 33, 34, 35, 36};
//+
Physical Curve("CATE EYOU=20E6 POIS=0.2 RECZ=0.3 RECY=0.3 WYLO=20") = {17, 18, 19, 27, 28, 29, 30, 31, 32};
//+
Physical Curve("CATE EYOU=20E6 POIS=0.2 RECZ=0.3 RECY=0.3 WYLO=20") += {20, 21, 22};
