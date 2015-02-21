function H =  hessian_interior_b(c, lambda, s, B)
c=c(:);
s=s(:);


[L, M] = size(B);

%g = zeros(M, 1);
H = zeros(M, M);
%f = 0;

lambda = lambda.ineqnonlin;

for l = 1 : L
    b = B(l, :)';
    A = diag(b);
    z = exp(c .* b);
    phi = mylogsumexp(c .* b);
    alpha = 1.0 / sum(z);
    dphi = alpha * (A' * z);
    ddphi = A' * ( alpha * diag(z) - alpha^2 * (z * z')) * A;
    %f = f + (phi - s(l))^2; 
    %g = g + 2 * (phi - s(l)) * dphi ;
    H = H + 2 * (phi - s(l)) * ddphi  + 2 * (dphi * dphi') -  lambda(l) * ddphi;   
end


end