// Gmsh project created on Thu Jun 27 07:47:36 2019
SetFactory("OpenCASCADE");
//+
lf=1.5;
lm=2*lf;
lc=4*lf;
//+
Point(1) = {0, -0, 0, lc};
//+
Point(2) = {70, 0, 0, lc};
//+
Point(3) = {70, 60, 0, lc};
//+
Point(4) = {45, 60, 0, lm};
//+
Point(5) = {36, 60, 0, lm};
//+
Point(6) = {6, 60, 0, lm};
//+
Point(7) = {5, 60, 0, lm};
//+
Point(8) = {0, 60, 0, lm};
//+
Point(9) = {0, 24, 0, lf};
//+
Point(10) = {15, 24, 0, lf};
//+
Point(11) = {5, 30, 0, lf};
//+
Point(12) = {6, 30, 0, lf};
//+
Point(13) = {15, 30, 0, lf};
//+
Point(14) = {0, 30, 0, lf};
//+
Point(15) = {45, 0, 0, lc};
//+
Point(16) = {45, 30, 0, lm};
//+
Point(17) = {70, 30, 0, lc};
//+
Point(18) = {0, 23, 0, lc};
//+
Point(19) = {16.6, 23, 0, lf};
//+
Line(1) = {1, 15};
//+
Line(2) = {15, 19};
//+
Line(3) = {10, 9};
//+
Line(4) = {18, 1};
//+
Line(5) = {15, 2};
//+
Line(7) = {3, 4};
//+
Line(8) = {15, 16};
//+
Line(9) = {16, 13};
//+
Line(10) = {13, 10};
//+
Line(11) = {16, 4};
//+
Line(12) = {4, 5};
//+
Line(13) = {5, 13};
//+
Line(14) = {13, 12};
//+
Line(15) = {12, 6};
//+
Line(16) = {6, 5};
//+
Line(17) = {2, 17};
//+
Line(18) = {17, 16};
//+
Line(19) = {17, 3};
//+
Line(20) = {7, 11};
//+
Line(21) = {7, 8};
//+
Line(22) = {8, 14};
//+
Line(23) = {14, 11};
//+
Line(24) = {14, 9};
//+
Line(25) = {9, 11};
//+
Line(26) = {12, 11};
//+
Line(27) = {10, 12};
//+
Line(28) = {18, 19};
//+
Line(29) = {19, 13};
//+
Curve Loop(1) = {1, 2, 28, 4};
//+
Plane Surface(1) = {1};
//+
Curve Loop(2) = {2, -29, -9, -8};
//+
Plane Surface(2) = {2};
//+
Curve Loop(3) = {5, 17, 18, -8};
//+
Plane Surface(3) = {3};
//+
Curve Loop(4) = {18, 11, -7, -19};
//+
Plane Surface(4) = {4};
//+
Curve Loop(5) = {9, -13, -12, -11};
//+
Plane Surface(5) = {5};
//+
Curve Loop(6) = {13, 14, 15, 16};
//+
Plane Surface(6) = {6};
//+
Curve Loop(7) = {25, -23, 24};
//+
Plane Surface(7) = {7};
//+
Curve Loop(8) = {23, -20, 21, 22};
//+
Plane Surface(8) = {8};
//+
Curve Loop(9) = {3, 25, -26, -27};
//+
Plane Surface(9) = {9};
//+
Curve Loop(10) = {27, -14, 10};
//+
Plane Surface(10) = {10};
//+
Extrude {{0, 60, 0}, {0, 0, 0}, Pi/2} {
  Surface{1}; Surface{2}; Surface{3}; Surface{4}; Surface{5}; Surface{6}; Surface{7}; Surface{8}; Surface{9}; Surface{10};
}
//+
Physical Surface("DISP UZ=0") = {1, 2, 3, 4, 5, 6, 7, 9, 10, 8};
//+
Physical Surface("DISP UX=0") = {14, 18, 29, 22, 26, 33, 39, 36, 43, 45};
//+
Physical Surface("DISP UY=0") = {28};
//+ wy=0.01273 N/mm2 P=wy*A=1 N
Physical Surface("PRES WY=0.01273") = {38};
//+ eyou=20e3 N/mm2
Physical Volume("CATE EYOU=20E3 POIS=0.25") = {1, 2, 3, 4, 5, 6};
//+ eyou=200e3 N/mm2
Physical Volume("CATE EYOU=200E3 POIS=0.20") = {7, 8, 9, 10};
//+
