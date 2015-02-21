% function test_learning_on_1d
clc
close all
clear

x  = linspace(0, 2*pi, 20);
x  = x(:);
b1 = sin(x);
b2 = cos(x);
b1 = b1 ./ sqrt(sum(b1^2));
b2 = b2 ./ sqrt(sum(b2^2));

basis = cat(2, b1, b2);

