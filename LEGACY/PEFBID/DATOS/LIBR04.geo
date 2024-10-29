// Gmsh project created on Tue Nov  6 16:46:21 2018
SetFactory("OpenCASCADE");
//+
Point(1) = {0, 0, 0, 1.0};
//+
Point(2) = {6, 0, 0, 1.0};
//+
Point(3) = {3, 5.2, 0, 1.0};
//+
Point(4) = {0, 5.2, 0, 1.0};
//+
Line(1) = {1, 2};
//+
Line(2) = {2, 3};
//+
Line(3) = {3, 4};
//+
Line(4) = {4, 1};
//+
Circle(5) = {0, 0, 0, 3, 0, 2*Pi};
//+
Curve Loop(1) = {1, 2, 3, 4};
//+
Plane Surface(1) = {1};
//+
Curve Loop(2) = {5};
//+
Plane Surface(2) = {2};
//+
BooleanDifference{ Surface{1}; Delete; }{ Surface{2}; Delete; }
//+
Point(6) = {0, 0, 0, 1.0};
//+
Point(7) = {4.5, 2.6, -0, 1.0};
//+
Line(6) = {6, 7};
//+
Line(7) = {6, 4};
//+
BooleanFragments{ Curve{7}; Curve{6}; Delete; }{ Curve{1}; Delete; }
//+
BooleanFragments{ Curve{4}; Delete; }{ Curve{9}; Delete; }
//+
//+
Recursive Delete {
  Surface{1};
}
//+
Point(10) = {0, 5.2, -0, 1.0};
//+
Line(15) = {2, 10};
//+
Line(16) = {10, 4};
//+
Line(17) = {1, 5};
//+
Curve Loop(1) = {12, 15, 16, -7};
//+
Plane Surface(1) = {1};
//+
Curve Loop(2) = {11, 7, -14, -9};
//+
Plane Surface(2) = {2};
//+
Curve Loop(3) = {10, 9, -13, -17};
//+
Plane Surface(3) = {3};
//+
Recursive Delete {
  Curve{8}; Curve{6};
}
//+
Physical Curve("DISP UX=0 UY=0") = {17};
//+
Physical Curve("DISP UX=0") = {15};
//+
Physical Curve("PRES WY=-5000") = {16};
//+
Physical Surface("CATE EYOU=20E6 POIS=0.3 TESP=1 TIPR=21") = {1, 2, 3};
//+
Transfinite Curve {12, 11, 10, 13, 14, 16} = 8 Using Progression 1;
//+
Transfinite Curve {15, 7, 9, 17} = 8 Using Progression 1;
//+
Transfinite Surface {1} Right;
//+
Transfinite Surface {2} Right;
//+
Transfinite Surface {3} Right;
//+
Recombine Surface {1,2,3};
//+
