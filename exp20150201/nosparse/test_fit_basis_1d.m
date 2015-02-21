clc
close all
clear

x  = linspace(0, 2*pi, 20);
x  = x(:);
b1 = sin(x);
b2 = cos(x);

L = numel(b1);
N = 100;
M = 2;


data = zeros(L, N);
coeff = rand(M, N) * 10 - 5;
basis = cat(2, b1, b2);
for j = 1 : N
    [data(:, j), I] = max(basis * diag(coeff(:, j)), [], 2);
    
    mask = zeros(M, 1);
    mask(I) = 1;
    
    if sum(mask) ~= M
       disp(j)
       disp(sum(mask))
    end
    
    IDX = (mask == 0);
    
    coeff(IDX, j) = 0;
end



% C = zeros(size(coeff));
% for j = 1 : N
%     disp('please wait...' )
%     disp(j);
%     sj = data(:, j);
%     cj = convex_learning(sj, basis);
%     C(:, j) = cj;
%     disp( cat(2, coeff(:, j), C(:, j), coeff(:, j) - C(:, j) ) )
%     disp(sum( (coeff(:, j) - C(:, j)).^2 ))
% end


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

figure
hold on
plot(x, basis(:, 1), 'bs--', 'LineWidth', 2)
plot(x, B(:, 1), 'ro--', 'LineWidth', 2)
legend('ground truth', 'learned')
hold off


figure
hold on
plot(x, basis(:, 2), 'bs--', 'LineWidth', 2)
plot(x, B(:, 2), 'ro--', 'LineWidth', 2)
legend('ground truth', 'learned')
hold off
