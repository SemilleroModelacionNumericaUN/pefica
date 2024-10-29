// Gmsh project created on Wed Apr 28 05:07:15 2021
SetFactory("OpenCASCADE");
//+
lc = DefineNumber[ 4, Name "Parameters/lc" ];
//+
Point(1) = {0,0, 0, lc};
Point(2) = {4.23/2,0, 0, lc};
Point(3) = {4.23/2,16.19, 0, lc};
Point(4) = {0,16.19, 0, lc};
//
Point(5) = {4.23/2,50.96/2-7.92, 0, lc};
Point(6) = {50.03/2,50.96/2-4.43, 0, lc};
Point(7) = {50.03/2,50.96/2, 0, lc};
Point(8) = {0,50.96/2, 0, lc};
//+
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};
//+
Line(5) = {3, 5};
Line(6) = {5, 6};
Line(7) = {6, 7};
Line(8) = {7, 8};
Line(9) = {8, 4};
//+
Curve Loop(1) = {1, 2, 3, 4};
//+
Plane Surface(1) = {1};
//+
Curve Loop(2) = {3, -9, -8, -7, -6, -5};
//+
Plane Surface(2) = {2};
//+
Symmetry {0, 1, 0, 0} {
  Duplicata { Surface{1}; Surface{2}; }
}
//+
Symmetry {1, 0, 0, 0} {
  Duplicata { Surface{1}; Surface{2}; Surface{3}; Surface{4}; }
}
//+
Coherence;
//+
Extrude {0, 0, 200} {
  Surface{1}; Surface{2}; Surface{3}; Surface{4}; Surface{5}; Surface{6}; Surface{7}; Surface{8};
}
//+
Physical Volume("CATE EYOU=200E3 POIS=0.2") = {8, 5, 1, 7, 3, 4, 2, 6};
//+
Physical Curve("DISP UX=0 UY=0 UZ=0") = {11, 26};
//+
Physical Point("LOAD FZ=-1962") = {32, 43};
//+
Physical Point("LOAD FZ=-3924") = {33};
