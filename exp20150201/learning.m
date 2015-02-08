

data = load('./cached/nyu/living_room_depths.mat');
org_depth = data.depths;


% normalize them to [-1, 0]
ma = max(org_depth(:));
mi = min(org_depth(:));
depths =1-double((org_depth - mi) ./ ma );
depths = depths * 100;

opts.patch_sz = 16;
opts.M = 64;
opts.params_basis.method='lbfgs';
opts.params_coeff.optTol = 1e-7;
opts.params_coeff.order = 1;
opts.batch_size=1000;
opts.maxIt = 100;

opts.lambda = ones( opts.M*opts.batch_size, 1);

[F, C] = em_learning(depths, opts);
