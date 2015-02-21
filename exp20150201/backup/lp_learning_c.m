function [x,fval,exitflag] = lp_learning_c(B, s)

[L, M] = size(B);

f = [-ones(L, 1); zeros(M,1)];

A1 = cat(2, eye(L, L), zeros(L,M));
A2 = zeros(L*M, L + M);

for i = 1 : M
    A2((i-1)*L+1:i*L, 1:L) = 0-eye(L, L);
    A2((i-1)*L+1:i*L, L+i) = B(:, i);
end
A = cat(1, A1, A2);
b = zeros(L+L*M, 1);
b(1:L) = 1.0 * s(:);
[x,fval,exitflag]  = linprog(f,A,b);


