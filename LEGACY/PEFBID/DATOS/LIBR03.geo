// Gmsh project created on Fri Oct 18 09:55:52 2019
SetFactory("OpenCASCADE");
//+
nd=10; // numero de divisiones en altura entre 0.40 y 0.50
//+
Point(1) = {0, 0, 0, 1.0};
//+
Point(2) = {0.20, 0, 0, 1.0};
//+
Point(3) = {0, 0.10, 0, 1.0};
//+
Point(4) = {0.20, 0.10, 0, 1.0};
//+
Point(5) = {0, 0.30, 0, 1.0};
//+
Point(6) = {0.20, 0.30, 0, 1.0};
//+
Point(7) = {0, 0.40, 0, 1.0};
//+
Point(8) = {0.20, 0.40, 0, 1.0};
//+
Point(9) = {0, 0.50, 0, 1.0};
//+
Point(10) = {0.20, 0.50, 0, 1.0};
//+
Line(1) = {1, 2};
//+
Line(2) = {3, 4};
//+
Line(3) = {5, 6};
//+
Line(4) = {7, 8};
//+
Line(5) = {9, 10};
//+
Line(6) = {1, 3};
//+
Line(7) = {3, 5};
//+
Line(8) = {5, 7};
//+
Line(9) = {7, 9};
//+
Line(10) = {2, 4};
//+
Line(11) = {4, 6};
//+
Line(12) = {6, 8};
//+
Line(13) = {8, 10};
//+
Curve Loop(1) = {1, 10, -2, -6};
//+
Plane Surface(1) = {1};
//+
Curve Loop(2) = {2, 11, -3, -7};
//+
Plane Surface(2) = {2};
//+
Curve Loop(3) = {3, 12, -4, -8};
//+
Plane Surface(3) = {3};
//+
Curve Loop(4) = {4, 13, -5, -9};
//+
Plane Surface(4) = {4};
//+
Physical Point("LOAD FY=1.0") = {9};
//+
Physical Curve("DISP UY=0") = {1};
//+
Physical Curve("DISP UX=0") = {6, 7, 8, 9};
//+
Physical Surface("CATE  EYOU=200E6 POIS=0.25 TESP=0.01") = {1, 2, 3, 4};
//+
Transfinite Curve {5, 4, 3, 2, 1} = 2*nd+1 Using Progression 1;
//+
Transfinite Curve {9, 13, 8, 12, 7, 11} = nd+1 Using Progression 1;
//+
Transfinite Curve {6, 10} = 1+nd/2 Using Progression 1;
//+
Transfinite Surface {1} = {1, 2, 4, 3};
//+
Transfinite Surface {2} = {3, 4, 6, 5};
//+
Transfinite Surface {3} = {5, 6, 8, 7};
//+
Transfinite Surface {4} = {7, 8, 10, 9};
//+
Recombine Surface {1, 2, 3, 4};
