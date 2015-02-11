function [f, g, H] =  obj_c(c, s, B)
c=c(:);
s=s(:);


[L, M] = size(B);

g = zeros(M, 1);
H = zeros(M, M);
f = 0;


for l = 1 : L
    b = B(l, :)';
    A = diag(b);
    z = exp(c .* b);
    phi = mylogsumexp(c .* b);
    sl  = max(c .* b);
    alpha = 1.0 / sum(z);
    dphi = alpha * (A' * z);
    ddphi = A' * ( alpha * diag(z) - alpha^2 * (z * z')) * A;
    %f = f + (phi - s(l))^2; 
    f = f + (sl - s(l))^2; 
    g = g + 2 * (phi - s(l)) * dphi ;
    H = H + 2 * (phi - s(l)) * ddphi  + 2 * (dphi * dphi');   
end


end