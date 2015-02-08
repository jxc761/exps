
[root_dir, ~, ~] = fileparts(mfilename('fullpath'));
libs_dir = fullfile(root_dir, 'libs');

%install L1 General
L1 = fullfile(libs_dir, 'L1General');
addpath(L1);
addpath(fullfile(L1, 'KPM'));
addpath(fullfile(L1, 'minFunc'));
addpath(fullfile(L1, 'L1General', 'sub'));
addpath(fullfile(L1, 'L1General'));
addpath(fullfile(L1, 'L1General2'));
addpath(fullfile(L1, 'misc'));


addpath(fullfile(libs_dir, 'minConf'));
addpath(fullfile(libs_dir, 'minConf', 'minFunc'));
addpath(fullfile(libs_dir, 'minConf', 'minConf'));


