function [F, C] = em_learning(data, opts)

[ height, width, num_images]= size(data);
psz = opts.patch_sz;
L = opts.patch_sz^2;
N = opts.batch_size;
M = opts.M;

buff =psz;

    

maxIt = opts.maxIt;
lambda = opts.lambda;
params_coeff = opts.params_coeff;
params_basis = opts.params_basis;
F = rand(L, M) * 100;
%F = -1+rand(L, M);
C = rand(M, N);




UB = ones(L*M, 1) * 100;
LB = zeros(L*M,1);
h = display_basis(F);

for t = 1 : maxIt
S = zeros([L, N]);
for i=1:N
  % choose an image for this batch
  ind=ceil(num_images*rand);
  this_image=data(:,:,ind);
  r=buff+ceil((height-psz-2*buff)*rand);
  c=buff+ceil((width-psz-2*buff)*rand);
  S(:,i)=reshape(this_image(r:r+psz-1,c:c+psz-1), L, 1);
end
	% update C
    anonFunc = @(x)obj_coeff(x, S, F);
	C = L1General2_TMP(anonFunc, C(:), lambda, params_coeff);
	C = reshape(C, [M, N]);
    
	%update F
	anonFunc = @(x)obj_basis(x, S, C);
	F = minConf_TMP(anonFunc, F(:), LB, UB, params_basis);
	F = reshape(F, [L, M]);
	if mod(t, 10) == 0
		h = display_basis(F, h);
        pause
	end
	
end


