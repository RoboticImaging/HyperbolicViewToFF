clear
clc
close all

addpath("../ToFFpipeline/")


% pth = fullfile("..\data\results\mat\occlusions\");
% pth = fullfile("..\data\results\mat\ballpit\");
% pth = fullfile("..\data\results\mat\plastic_boxes\");
pth = fullfile("..\data\results\mat\fruit\");

[dLF, ampLF, LFargs] = readToFFarray(pth); 

% LFXMonoWriteGifAnim( dLF, 'test.gif')
% LFXMonoWriteGifAnim( ampLF, 'test_amp.gif')


LFXWriteGifAnimLawnmower( dLF, 'test.gif')
LFXWriteGifAnimLawnmower( ampLF, 'test_amp.gif')


