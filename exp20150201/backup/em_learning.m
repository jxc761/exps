function [F, C] = em_learning(data, opts)

[ height, width, num_images]= size(data);
psz = opts.patch_sz;
L   = opts.patch_sz^2;
N   = opts.batch_size;
M   = opts.M;
buff = psz;
maxIt = opts.maxIt;
    
% opts.params_basis.method='lbfgs';
% opts.params_coeff.optTol = 1e-7;
% opts.params_coeff.order = 1;
opts.params_coeff.Method = 'lbfgs';
opts.params_coeff.MaxIter= 10;
opts.params_coeff.lambda = ones( opts.M * opts.batch_size, 1);


opts.params_basis.Method = 'lbfgs';
opts.params_basis.MaxIter= 10;

params_coeff = opts.params_coeff;
params_basis = opts.params_basis;

% initialize
% F = zeros(L, M);
% for i=1:M
%     % choose an image for this batch
%     ind=ceil(num_images*rand);
%     this_image=data(:,:,ind);
%     r=buff+ceil((height-psz-2*buff)*rand);
%     c=buff+ceil((width-psz-2*buff)*rand);
%     F(:,i)=reshape(this_image(r:r+psz-1,c:c+psz-1), L, 1);
% end
% % F = rand(L, M);

F = greedy_learning(data, opts);

C = zeros(M, N);

%C = rand(M, N);

close all

display_basis(F, 1);
%display_coeff(C, 2);


%UB = ones(L*M, 1) * 100;
%LB = zeros(L*M,1);

for t = 1 : maxIt
    if mod(t, 5) == 0
        disp('it' + 5)
    end
    
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
	C = minFunc(anonFunc, C(:), params_coeff);
    %C = L1General2_OPG(anonFunc, C(:), params_coeff.lambda, params_coeff);
	C = reshape(C, [M, N]);
    display_coeff(C, 2);
    
	%update F
	anonFunc = @(x)obj_basis(x, S, C);
	F = minFunc(anonFunc, F(:), params_basis);
	F = reshape(F, [L, M]);
	%if mod(t, 10) == 0
    display_basis(F, 1);

	%end
	
end


