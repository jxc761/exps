function [f, grad_f] = obj_coeff(x, S, F)

L = size(S, 1);
M = size(F, 2);
N = size(S, 2);

C = reshape(x, [M, N]);
S = reshape(S, [L, 1, N]);

aggF = reshape( repmat(F		, [1, N]), [L, M, N]);
aggC = reshape( repmat(C(:)	, [L, 1]), [L, M, N]);


P = aggF .* aggC; % L x M X N
Q = exp(P); % Q(x, i, j) = exp C(i, j) F(x, i, j)

R = mylogsumexp(P, 2); 
T = exp(R);
E = R - S;

aggE = repmat(E, [1, M, 1]);
aggT = repmat(T, [1, M, 1]);



G = (2 * aggF .* Q .* aggE) ./ (N * aggT);

grad_f = reshape( sum(G, 1), [M, N]);
grad_f = grad_f(:);
f = sum( E(:).^2 ) ./ N; 

%disp(['grad_f:' num2str(grad_f)]);
disp(['f     :' num2str(f)]);
end