
function nyu_extract_one_catergory_scene(input, output, sceneType)

disp(input)
disp(output)
disp(sceneType)

load(input);

if ~exist('sceneTypes', 'var')  || ~exist('depths', 'var') || ~exist('images', 'var') || ~exist('scenes', 'var')  
    error('cannot find the required data')
end


if ~exist(output, 'dir')
    mkdir(output)
end

index = strcmpi(sceneType, sceneTypes);

if sum(index) ==  0
    disp(['unknow scene type: ' sceneType])
    return
end

images = images(:, :, :, index);
depths = depths(:, :, index);
scenes = scenes(index);

save(fullfile(output, [sceneType '_depths.mat']), 'depths');
save(fullfile(output, [sceneType '_images.mat']), 'images');
save(fullfile(output, [sceneType '_scenes.mat']), 'scenes');


for i = 1 : size(images, 4)
    name = [ scenes{i} '_' num2str(i, '%04d') ];
    
    fn_image = fullfile(output, [name '.jpg']);
    imwrite(images(:, :, :, i), fn_image) 
    
    fn_depth = fullfile(output, [ 'd_' name '.jpg']);
    depth_img = gray2ind(mat2gray(depths(:, :,  i)), 256); 
    imwrite(depth_img, hot(256), fn_depth); 
end 


end