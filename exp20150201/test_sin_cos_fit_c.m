clc
close all
clear

x  = linspace(0, 2*pi, 20);
b1 = cos(x);
b2 = sin(x);

y1 = max(b1, b2);
y2 = max(b1, 1.5 * b2);
y3 = max(b1*1.5, b2);




data  = [y1; y2; y3]';
basis = [b1; b2]';


coeff = [1, 1, 1.5; 1, 1.5, 1];
c = convex_learning(y3, basis);
my_display_current(x, c, y3, basis);

