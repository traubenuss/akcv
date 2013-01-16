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

% load DCP specific parameters
params = dcp_load_params();

% generate world set
world_set = dcp_generate_world_set(params, 'world_images', 'world_set.mat', false);


%% Extracting most discriminative patches

%% Visualisation of the results

%% Evaluation of the results