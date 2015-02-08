function [f, grad_f] = obj_basis(x, S, C)

L = size(S, 1);
M = size(C, 1);
N = size(S, 2);
F = reshape(x, [L, M]);

S = reshape(S, [L, 1, N]);

aggF = reshape( repmat(F    , [1, N]), [L, M, N]);
aggC = reshape( repmat(C(:)	, [L, 1]), [L, M, N]);


P = aggF .* aggC; % L x M X N
Q = exp(P); % Q(x, i, j) = exp C(i, j) F(x, i, j)

R = mylogsumexp(P, 2); 
T = exp(R);
E = R - S;

aggE = repmat(E, [1, M, 1]);
aggT = repmat(T, [1, M, 1]);



G =( 2 * aggC .* Q .* aggE) ./ (N * aggT);

grad_f = sum(G, 3);
grad_f = grad_f(:);
f = sum( E(:).^2 ) ./ N; 
%disp(['grad_f:' num2str(grad_f)]);
disp(['f     :' num2str(f)]);
end