clc
close all
clear

x  = linspace(0, 2*pi, 20);
x  = x(:);
b1 = sin(x);
b2 = cos(x);

L = numel(b1);
N = 1000;
M = 2;


data = zeros(L, N);
coeff = rand(M, N) * 10 - 5;
basis = cat(2, b1, b2);
for j = 1 : N
    data(:, j) = max(basis * diag(coeff(:, j)), [], 2);
end

% figure
% hold on
% for j = 1 : 20: N
%     plot(x, data(:, j))
% end
B = zeros(size(basis));
for l = 1 : L
    disp('please wait...' )
    disp(l);
    sl = data(l, :);
    sl = sl(:);
    bl = convex_learning(sl, coeff');
    B(l, :) = bl';
    disp(B(l, :))
end
