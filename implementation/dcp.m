%% ----------------- Discriminative Classifier Parts ----------------------
% AKCV-KU WS 2012, University of Technology, Graz
% 
% sample execution script of the framework
% 

%% Initial steps
close all
clear all
clc
% initialise VLFeat
addpath('utils')
run('vlfeat-0.9.16/toolbox/vl_setup')
run('libsvm-3.14/matlab/make.m')
addpath('libsvm-3.14/matlab')

% load DCP specific parameters
params = dcp_load_params();

% generate world set
world_set = dcp_generate_world_set(params, 'world_images', 'ws_1.mat', false);

% specify discovery set
discovery_set = getFilesInDirAndSubDirs('test_bus');


%% Extracting most discriminative patches
patches = dcp_extract(params, discovery_set, world_set);

%% Visualisation of the results
dcp_visualise_patches(params, patches, discovery_set);

%% Evaluation of the results