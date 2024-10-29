// Gmsh project created on Sun Dec  6 06:48:14 2020
SetFactory("OpenCASCADE");
//+
lc = DefineNumber[ 2, Name "Parameters/lc" ];
//+
Point(1) = {0, 0, 0, lc};
//+
Point(2) = {5.6/2, 0, 0, lc};
//+
Point(3) = {5.6/2, 200/2-8.5-12, 0, lc};
//+
Point(4) = {5.6/2+12, 200/2-8.5, 0, lc};
//+
Point(5) = {100/2, 200/2-8.5, 0, lc};
//+
Point(6) = {100/2, 200/2, 0, lc};
//+
Point(7) = {0, 200/2, 0, lc};
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
Line(7) = {7, 1};
//+
Curve Loop(1) = {1, 2, 3, 4, 5, 6, 7};
//+
Plane Surface(1) = {1};

//+
Point(8) = {0, 200/2+2, 0, lc};
//+
Point(9) = {100/2, 200/2+2, 0, lc};
//+
Point(10) = {300/2, 200/2+2, 0, lc};
//+
Point(11) = {300/2, 200/2+2+100, 0, lc};
//+
Point(12) = {100/2, 200/2+2+100, 0, lc};
//+
Point(13) = {0, 200/2+2+100, 0, lc};


//+
Line(8) = {8, 9};
//+
Line(9) = {9, 10};
//+
Line(10) = {10, 11};
//+
Line(11) = {11, 12};
//+
Line(12) = {12, 13};
//+
Line(13) = {13, 8};
//+
Line(14) = {9, 12};
//+
Curve Loop(2) = {8, 14, 12, 13};
//+
Curve Loop(3) = {8, 14, 12, 13};
//+
Plane Surface(2) = {3};
//+
Curve Loop(4) = {9, 10, 11, -14};
//+
Plane Surface(3) = {4};//+
Extrude {0, 0, 400} {
  Surface{1};
}
//+
Extrude {0, 0, 500} {
  Surface{2}; Surface{3};
}//+
//+
Circle(42) = {0, 200/2, 200, 3*25.4/8, -Pi/2, Pi/2};
//+
Line(43) = {28, 27};
//+
Curve Loop(22) = {43, 42};
//+
Plane Surface(21) = {22};
//+
Curve Loop(23) = {42, 43};
//+
Extrude {0, 0, 50} {
  Surface{21}; 
}
//+
Circle(48) = {0, 200/2, 200+50, 3*25.4/8+2, -Pi/2, Pi/2};
//+
Line(49) = {32, 29};
//+
Line(50) = {30, 31};
//+
Curve Loop(27) = {47, -49, -48, -50};
//+
Plane Surface(25) = {27};
//+
Extrude {0, 0, 4} {
  Surface{24}; Surface{25}; 
}
//+
Rotate {{1, 0, 0}, {0, 200/2, 200}, -Pi/2} {
  Volume{4}; Volume{5}; Volume{6}; 
}
//+
BooleanDifference{ Volume{2}; Delete; }{ Volume{4}; Volume{5}; Volume{6}; }
//+
BooleanUnion{ Volume{1}; Delete; }{ Volume{4}; Volume{5}; Volume{6}; Delete; }
