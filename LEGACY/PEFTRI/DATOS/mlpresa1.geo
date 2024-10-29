// Presa tridimensional construida a partir
// de la revolucion de una seccion transversal
// con respecto a un eje.
// Generacion de malla estructurada de tetraedros
SetFactory("OpenCASCADE");
lc=10.0;
lf=10.0;
Point(1) = {0, 0, 0, lc};
Point(2) = {70.2,0, 0, lc};
Point(3) = {22.005,66.5, 0, lf};
Point(4) = {16.425,103.0, 0, lc};
Point(5) = {1.625,103.0, 0, lc};
Point(6) = {1.625,66.5, 0, lf};
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 5};
Line(5) = {5, 6};
Line(6) = {6, 1};
Line(7) = {3, 6};
Curve Loop(1) = {1, 2, 7, 6};
Plane Surface(1) = {1};
Curve Loop(2) = {7, 3, 4, 5};
Plane Surface(2) = {2};
Extrude {{0, 1, 0}, {-210, 0, 0}, Pi/2} {
  Surface{1, 2};
}
//+
Transfinite Curve {9, 11, 18, 16, 13, 8} = 91 Using Progression 1;
//+
Transfinite Curve {6, 2, 15, 12} = 21 Using Progression 1;
//+
Transfinite Curve {3, 5, 20, 17} = 11 Using Progression 1;
//+
Transfinite Curve {1, 7, 4, 10, 14, 19} = 5 Using Progression 1;
//+
Transfinite Surface {1};
//+
Transfinite Surface {2};
//+
Transfinite Surface {3};
//+
Transfinite Surface {4};
//+
Transfinite Surface {5};
//+
Transfinite Surface {6};
//+
Transfinite Surface {5};
//+
Transfinite Surface {7};
//+
Transfinite Surface {8};
//+
Transfinite Surface {9};
//+
Transfinite Surface {10};
//+
Transfinite Surface {11};
//+
Transfinite Volume{1} = {2, 8, 7, 1, 3, 9, 10, 6};
//+
Transfinite Volume{2} = {3, 9, 10, 6, 4, 12, 11, 5};
