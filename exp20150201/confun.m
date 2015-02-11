function [c, ceq, gradc, gradceq] = confun(x, s, B)

% Nonlinear inequality constraints
x=x(:);
s=s(:);


[L, M] = size(B);


c = zeros(M, 1);

gradc = zeros(M, L);
for l = 1 : L
    b = B(l, :)';
    phi = mylogsumexp(x .* b);
    % c(l) =s(l) -  phi ; 
    c(l) =s(l) -  max(x .* b);
    
    z = exp(x .* b);
    A = diag(b);
  
    alpha = 1.0 / sum(z);
    dphi = alpha * (A' * z);
    gradc(:, l) = -1.0 *  dphi;
end




 
% Nonlinear equality constraints
ceq = [];
gradceq=[];

