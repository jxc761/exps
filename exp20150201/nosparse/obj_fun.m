%%%
% f(c, s, B) = sum_l \| max_j {B(l, j) c_j} - s_l \|^2
% 
%
function [f, g, H] =  obj_fun(c, s, B)

c=c(:);
s=s(:);


[L, M] = size(B);

g = zeros(M, 1);
H = zeros(M, M);
f = 0;


for l = 1 : L
    b = B(l, :)';
    sl  = max(c .* b);
     
    f = f + (sl - s(l))^2;
    
    %f = f + (phi - s(l))^2;
    if nargout > 1
        A = diag(b);
        z = exp(c .* b);
        phi = mylogsumexp(c .* b);
        alpha = 1.0 / sum(z);
        dphi = alpha * (A' * z);
        g = g + 2 * (phi - s(l)) * dphi;
        
        if nargout > 2
            ddphi = A' * ( alpha * diag(z) - alpha^2 * (z * z')) * A;
            H = H + 2 * (phi - s(l)) * ddphi  + 2 * (dphi * dphi');
        end
    end
end


end