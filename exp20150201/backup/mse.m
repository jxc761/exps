function mse =  mse(data, coeff, basis)



mse = 0;

N = size(data, 2);

for j = 1 : N
    r = max(basis * diag(coeff(:, j)), [], 2) - data(:, j);
    mse = mse + sum(r.^2);
    
end

mse = mse / N;
end