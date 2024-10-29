// Gmsh project created on Sun Jul 21 17:28:14 2019
SetFactory("OpenCASCADE");
lc=0.09;
//+
Point(1) = {0, 0, 0, lc};
//+
Point(2) = {2.26, 0, 0, lc};
//+
Point(3) = {2.5775, 0.55, 0, lc};
//+
Point(4) = {1.4475, 2.5075, 0, lc};
//+
Point(5) = {0.8125, 2.5075, 0, lc};
//+
Point(6) = {-0.3175, 0.55, 0, lc};
//+
Circle(1) = {0.3175, 0.55, 0, 0.325, 0, 2*Pi};
//+
Circle(2) = {1.9425, 0.55, 0, 0.325, 0, 2*Pi};
//+
Circle(3) = {1.13, 1.9575, 0, 0.325, 0, 2*Pi};
//+
Line(4) = {1, 2};
//+
Line(5) = {2, 3};
//+
Line(6) = {3, 4};
//+
Line(7) = {4, 5};
//+
Line(8) = {5, 6};
//+
Line(9) = {6, 1};
//+
Curve Loop(1) = {1};
//+
Plane Surface(1) = {1};
//+
Curve Loop(2) = {3};
//+
Plane Surface(2) = {2};
//+
Curve Loop(3) = {2};
//+
Plane Surface(3) = {3};
//+
Point(10) = {0, 0, 0.7, lc};
//+
Point(11) = {2.26, 0, 0.7, lc};
//+
Point(12) = {2.5775, 0.55, 0.7, lc};
//+
Point(13) = {1.4475, 2.5075, 0.7, lc};
//+
Point(14) = {0.8125, 2.5075, 0.7, lc};
//+
Point(15) = {-0.3175, 0.55, 0.7, lc};
//+
Line(10) = {10, 11};
//+
Line(11) = {11, 12};
//+
Line(12) = {12, 13};
//+
Line(13) = {13, 14};
//+
Line(14) = {14, 15};
//+
Line(15) = {15, 10};
//+
Line(16) = {1, 10};
//+
Line(17) = {2, 11};
//+
Line(18) = {3, 12};
//+
Line(19) = {4, 13};
//+
Line(20) = {5, 14};
//+
Line(21) = {6, 15};
//+
Curve Loop(4) = {4, 5, 6, 7, 8, 9};
//+
Curve Loop(5) = {2};
//+
Curve Loop(6) = {1};
//+
Curve Loop(7) = {3};
//+
Plane Surface(4) = {4, 5, 6, 7};
//+
Curve Loop(8) = {4, 17, -10, -16};
//+
Plane Surface(5) = {8};
//+
Curve Loop(9) = {5, 18, -11, -17};
//+
Plane Surface(6) = {9};
//+
Curve Loop(10) = {21, 15, -16, -9};
//+
Plane Surface(7) = {10};
//+
Curve Loop(11) = {14, -21, -8, 20};
//+
Plane Surface(8) = {11};
//+
Curve Loop(12) = {20, -13, -19, 7};
//+
Plane Surface(9) = {12};
//+
Curve Loop(13) = {12, -19, -6, 18};
//+
Plane Surface(10) = {13};
//+
//+
Rectangle(11) = {1.13-0.4, 1.02-0.2, 0.7, 0.8, 0.4, 0};
//+
Curve Loop(15) = {14, 15, 10, 11, 12, 13};
//+
Curve Loop(16) = {22, 23, 24, 25};
//+
Plane Surface(12) = {15, 16};
//+
Surface Loop(1) = {11, 12, 8, 7, 5, 4, 6, 10, 9, 3, 1, 2};
//+
Volume(1) = {1};
//+
Physical Volume("CATE EYOU=20E6 POIS=0.3") = {1};
//+
Physical Surface("PRES WZ=-14583", 27) = {11};
//+
Physical Surface("DISP UX=0 UY=0 UZ=0", 28) = {1, 3, 2};
//+
Characteristic Length {7, 8, 9, 16, 17, 18, 19} = lc;
//+
//Transfinite Curve {5, 7, 9, 11, 13, 15} = 5 Using Progression 1;
//+
//Transfinite Curve {6, 4, 8, 10, 12, 14} = 11 Using Progression 1;
