function C = update_c(data, coeff, basis, opts)

C = zeros( size(coeff) );

for j = 1 : size(coeff, 2)
    disp(j)
    c0 = coeff(:, j);
    s  = data(:, j);
    fun = @(x)obj_c(x, s, basis, opts);
    
    hessianfcn = @(x, y)hessian_interior_c(x, y, s, basis, opts);
    nonlcon = @(x)confun(x, s, basis);
    options = optimset('Hessian','user-supplied', 'GradConstr', 'on', 'GradObj', 'on', 'Algorithm', 'interior-point', 'HessFcn', hessianfcn);
    C(:, j) = fmincon(fun, c0, [], [], [],[], [], [], nonlcon, options);
end

end