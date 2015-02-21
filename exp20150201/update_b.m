function B = update_b(data, coeff, basis)

B = zeros( size(basis) );
coeff_t = coeff';

for l = 1 : size(B, 1)
    disp(l);
    b0 = basis(l, :)';
    s  = data(l, :)';
    
    
    fun = @(x)obj_b(x, s, coeff_t);
    hessianfcn = @(x, y)hessian_interior_b(x, y, s, coeff_t);
    nonlcon = @(x)confun(x, s, coeff_t);
    options = optimset('Hessian','user-supplied', 'GradConstr', 'on', 'GradObj', 'on', 'Algorithm', 'interior-point', 'HessFcn', hessianfcn);
    bl = fmincon(fun, b0, [], [], [],[], [], [], nonlcon, options);
    
    B(l, :) = bl';
    
end

end