
close all
clear
clc

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
%depths = max(org_depths(:)) - org_depths ;



opts.maxIt = 100;
opts.patch_sz = 16;
opts.M = 64;
opts.batch_size=1000;

%opts.lambda = ones( opts.M*opts.batch_size, 1);

F = em_learning(depths, opts);
%F = greedy_learning(depths, opts);