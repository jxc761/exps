clc
close all
clear

L = 24;
M = 4;

basis = zeros(L, M);
basis(:     , 1) = 1;
basis(4:10  , 2) = 1;
basis(8:14  , 3) = 1;
basis(18:22 , 4) = 1;


N = 200;



data = zeros(L, N);
coeff = rand(M, N) * 10;
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

%%
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

for j = 1 : M
    figure
    hold on
    plot(basis(:, j), 'bs--', 'LineWidth', 2)
    plot(B(:, j), 'ro--', 'LineWidth', 2)
    legend('ground truth', 'learned')
    hold off
end



