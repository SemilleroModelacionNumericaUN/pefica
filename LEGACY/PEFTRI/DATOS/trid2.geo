// Gmsh project created on Fri Jun 21 15:35:17 2019
SetFactory("OpenCASCADE");
//+
Point(1) = {0, 0, 0, 1.0};
//+
Point(2) = {0.4, 0, 0, 1.0};
//+
Point(3) = {0, 0.3, 0, 1.0};
//+
Point(4) = {0.4, 0.3, 0, 1.0};
//+
Point(5) = {0, 0, 0.3, 1.0};
//+
Point(6) = {0.4, 0, 0.3, 1.0};
//+
Point(7) = {0, 0.3, 0.3, 1.0};
//+
Point(8) = {0.4, 0.3, 0.3, 1.0};
//+
Line(1) = {1, 2};
//+
Line(2) = {2, 4};
//+
Line(3) = {4, 3};
//+
Line(4) = {3, 1};
//+
Line(5) = {5, 6};
//+
Line(6) = {6, 8};
//+
Line(7) = {8, 7};
//+
Line(8) = {7, 5};
//+
Line(9) = {1, 5};
//+
Line(10) = {2, 6};
//+
Line(11) = {4, 8};
//+
Line(12) = {3, 7};
//+
//+
Line(13) = {2, 3};
//+
Line(14) = {3, 5};
//+
Line(15) = {2, 5};
//+
Curve Loop(1) = {1, 15, -9};
//+
Plane Surface(1) = {1};
//+
Curve Loop(2) = {15, -14, -13};
//+
Plane Surface(2) = {2};
//+
Curve Loop(3) = {4, 9, -14};
//+
Plane Surface(3) = {3};
//+
Curve Loop(4) = {1, 13, 4};
//+
Plane Surface(4) = {4};
//+
Surface Loop(1) = {1, 4, 2, 3};
//+
Volume(1) = {1};
//+
Line(16) = {2, 8};
//+
Line(17) = {8, 3};
//+
Curve Loop(5) = {2, 11, -16};
//+
Plane Surface(5) = {5};
//+
Curve Loop(6) = {3, -17, -11};
//+
Plane Surface(6) = {6};
//+
Curve Loop(7) = {16, 17, -13};
//+
Plane Surface(7) = {7};
//+
Curve Loop(8) = {2, 3, -13};
//+
Plane Surface(8) = {8};
//+
Surface Loop(2) = {5, 8, 6, 7};
//+
Volume(2) = {2};
//+
Line(18) = {5, 8};
//+
Curve Loop(9) = {5, 6, -18};
//+
Plane Surface(9) = {9};
//+
Curve Loop(10) = {5, -10, 15};
//+
Plane Surface(10) = {10};
//+
Curve Loop(11) = {10, 6, -16};
//+
Plane Surface(11) = {11};
//+
Curve Loop(12) = {16, -18, -15};
//+
Plane Surface(12) = {12};
//+
Surface Loop(3) = {9, 10, 11, 12};
//+
Volume(3) = {3};
//+
Surface Loop(4) = {9, 10, 11, 12};
//+
Curve Loop(13) = {18, 7, 8};
//+
Plane Surface(13) = {13};
//+
Curve Loop(14) = {7, -12, -17};
//+
Plane Surface(14) = {14};
//+
Curve Loop(15) = {12, 8, -14};
//+
Plane Surface(15) = {15};
//+
Curve Loop(16) = {14, 18, 17};
//+
Plane Surface(16) = {16};
//+
Surface Loop(5) = {13, 14, 15, 16};
//+
Volume(4) = {5};
//+
Surface Loop(6) = {2, 7, 16, 12};
//+
Volume(5) = {6};
//+
Physical Volume("CATE EYOU=20E6 POIS=0.3") = {3, 1, 2, 4, 5};
//+
Physical Surface("DISP UX=0 UY=0 UZ=0") = {3, 15};
//+
Physical Point("LOAD FX=1000") = {8};
//+
Physical Surface("PRES WX=20000") = {11, 5};
//+
Transfinite Curve {10, 15, 5, 1, 9, 16, 18, 6, 2, 11, 8, 7, 17, 14, 13, 12, 3, 4} = 2 Using Progression 1;
//+