function C = update_c(data, coeff, basis, opts)

N = size(coeff, 2);

C = zeros( size(coeff) );


inputs = cell(1, N);
for j = 1 : N
    disp(j)
    c0 = coeff(:, j);
    s  = data(:, j);
    fun = @(x)obj_c(x, s, basis, opts);
    
    hessianfcn = @(x, y)hessian_interior_c(x, y, s, basis, opts);
    nonlcon = @(x)confun(x, s, basis);
    options = optimset('Hessian','user-supplied', 'GradConstr', 'on', 'GradObj', 'on', 'Algorithm', 'interior-point', 'HessFcn', hessianfcn);
    % C(:, j) = fmincon(fun, c0, [], [], [],[], [], [], nonlcon, options);
    inputs{j} = {fun, c0, [], [], [],[], [], [], nonlcon, options};
end

cluster = parcluster(); 
job = createJob(cluster);
createTask(job, @fmincon, 1, inputs);
submit(job);
wait(job);

results = fetchOutputs(job);

for j = 1 : N
    C(:, j) = results{j};
end

delete(job);


end