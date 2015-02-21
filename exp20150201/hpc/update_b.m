function B = update_b(data, coeff, basis)

B = zeros( size(basis) );
coeff_t = coeff';
L = size(B, 1);


inputs = cell(1, L);
for l = 1 : L
    disp(l);
    b0 = basis(l, :)';
    s  = data(l, :)';
    
    
    fun         = @(x)obj_b(x, s, coeff_t);
    hessianfcn  = @(x, y)hessian_interior_b(x, y, s, coeff_t);
    nonlcon     = @(x)confun(x, s, coeff_t);
    options     = optimset('Hessian','user-supplied', 'GradConstr', 'on', 'GradObj', 'on', 'Algorithm', 'interior-point', 'HessFcn', hessianfcn);
    inputs{l}   = {fun, b0, [], [], [],[], [], [], nonlcon, options};
    
    % bl = fmincon(fun, b0, [], [], [],[], [], [], nonlcon, options);
    
    % B(l, :) = bl';
end

cluster = parcluster();
job = createJob(cluster);
createTask(job, @fmincon, 1, inputs);
submit(job);
wait(job);

results = fetchOutputs(job);

for j = 1 : N
    B(l, :)  = results{j}';
end

delete(job);

end