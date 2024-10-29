//+
Point(1) = {0, 0, 0, 1.0};
//+
Point(2) = {3, 4, 0, 1.0};
//+
Point(3) = {3, 0, 0, 1.0};
//+
Point(4) = {6, 0, 0, 1.0};
//+
Line(1) = {1, 3};
//+
Line(2) = {3, 4};
//+
Line(3) = {4, 2};
//+
Line(4) = {2, 3};
//+
Line(5) = {1, 2};
//+
Physical Point("DISP UX=0 UY=0") = {1};
//+
Physical Point("DISP UY=0") = {4};
//+
Physical Point("LOAD FX=100") = {2};
//+
Physical Curve("CATE EYOU=200E6 AREA=0.25") = {5, 3};
//+
Physical Curve("CATE EYOU=200E6 AREA=0.50") = {1, 2};
//+
Physical Curve("CATE EYOU=200E6 AREA=0.10") = {4};
//+
Transfinite Curve {5, 1, 4, 3, 2} = 2 Using Progression 1;
