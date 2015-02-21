clear
clc
close all

data = load('./cached/nyu/living_room_depths.mat');
org_depths = double(data.depths);


% normalize them to [0, 1]
depths = zeros(size(org_depths));
for j = 1 : size(org_depths, 3)
    cur = org_depths(:, :, j);
    ma  = max(cur(:));
    mi  = min(cur(:));
    depths(:, :, j) = 1 - double((cur - mi) ./ (ma - mi) );
    % disp([j, ma, mi]);
end

[height, width, num_images] = size(depths);
buff = 8;
psz = 8;
L = psz * psz;
N = 100;
M = 64;


% initialize
basis = zeros(L, M);
for i=1:M
    % choose an image for this batch
    ind=ceil(num_images*rand);
    this_image=depths(:,:,ind);
    r=buff+ceil((height-psz-2*buff)*rand);
    c=buff+ceil((width-psz-2*buff)*rand);
    basis(:,i)=reshape(this_image(r:r+psz-1,c:c+psz-1), L, 1);
end
figure(2)
display_array(basis, 2);
% [L, N] = size(data);



opts.sigma = 0.316;
opts.lambda = opts.sigma * 0.14;
save('data2.mat', 'data')
maxIt = 100;
for t = 1 : maxIt
    
    
    data = zeros([L, N]);
    for i=1:N
        % choose an image for this batch
        ind=ceil(num_images*rand);
        this_image=depths(:, :,ind);
        r=buff+ceil((height-psz-2*buff)*rand);
        c=buff+ceil((width-psz-2*buff)*rand);
        data(:,i)=reshape(this_image(r:r+psz-1,c:c+psz-1), L, 1);
    end
    
    % initialize coeff and basis 
    coeff = rand(M, N);
    
    coeff = update_c(data, coeff, basis, opts);
    
    figure(1)
    imagesc(coeff);
    drawnow
    
    basis = update_b(data, coeff, basis);
    basis = basis * diag( sqrt(sum(basis.^2, 1)) );
    
    figure(2)
    display_array(basis, 2);
    save(['coeff2_' num2str(t) '.mat'], 'coeff');
    save(['basis2_' num2str(t) '.mat'], 'basis');
   
    
end