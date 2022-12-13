// longitud=m, fuerza=kN
cl__1 = 1;
Point(1) = {0, 0, 0, cl__1};
Point(2) = {300, 0, 0, cl__1};
Point(3) = {300, 150, 0, cl__1};
Point(4) = {191.45, 150, 0, cl__1};
Point(5) = {168.25, 150, 0, cl__1};
Point(6) = {145, 150, 0, cl__1};
Point(7) = {100, 80, 0, cl__1};
Point(8) = {90, 80, 0, cl__1};
Point(9) = {0, 80, 0, cl__1};
Point(10) = {168.25, 152, 0, cl__1};
Point(11) = {160.5, 152, 0, cl__1};
Point(12) = {145, 152, 0, cl__1};
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 5};
Line(5) = {5, 6};
Line(6) = {6, 7};
Line(7) = {7, 8};
Line(8) = {8, 9};
Line(9) = {9, 1};
Line(10) = {6, 12};
Line(11) = {12, 11};
Line(12) = {11, 10};
Line(13) = {10, 5};
Curve Loop(1) = {1, 2, 3, 4, 5, 6, 7, 8, 9};
Curve Loop(2) = {5, 10, 11, 12, 13};
Plane Surface(1) = {1};
Plane Surface(2) = {2};
MeshSize {1, 2, 3, 8, 9} = 12;
MeshSize {5, 6, 7, 8, 4, 10, 11, 12} = 2;
Physical Curve("DISP UX=0 UY=0") = {1,2,9};
Physical Point("LOAD FY=-10E3") = {11};
Physical Point("CURV HO=UY VE=FY") = {11};
Physical Surface("CATE EYOU=20E3 POIS=0.3 GAMM=24 TESP=1 TIPR=21 EPLA=0 SIGY=3E3 TYMO=21") = {1};
// suelo: arcilla blanda, E=20MPa, PE=27 kN/m3, modelo elastoplástico end. isotrópico
Physical Surface("CATE EYOU=20E6 POIS=0.3 GAMM=24 TESP=1 TIPR=21 TYMO=11") = {2};
// placa concreto: E=20GPa, PE=24 kN/m3, elástico