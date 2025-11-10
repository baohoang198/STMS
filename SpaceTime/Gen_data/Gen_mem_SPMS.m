% main_generate_stm.m
% -------------------
% Generates a ROWS×COLS×TIME_STEPS matrix with only the 2-bit states
% {0,1,2,3} (i.e. binary 00,01,10,11), then writes stm_matrix.mem.

clear all; clc; close all;

%% PARAMETERS
ROWS       = 20;    % # of rows in metasurface
COLS       = 1;    % # of columns
TIME_STEPS = 10;   % # of time frames

%% DEFINE YOUR FOUR STATES (00, 01, 10, 11)
states = uint8([0, 1, 2, 3]);  % 2-bit codes

%% OPTION A: RANDOM TEST PATTERN
% Pick randomly among the four states for each (r,c,t)

idx = randi(numel(states), ROWS/2, COLS, TIME_STEPS);
M_test_actual = states(idx);


M_test = repelem(M_test_actual,2,1,1);
fprintf('Writing random four-state pattern to stm_matrix.mem...\n');
write_stm_mem(M_test, 'stm_matrix.mem');
write_stm_control_upper(M_test,'upper.mem')
write_stm_pattern_control(M_test, 'my_ctrl_pattern.mem');
write_stm_control_anisotropic(M_test_actual, 'anisotropic.mem');


%% OPTION B: LOAD A USER-DEFINED MATRIX
% If you already have M(r,c,t) in a .mat, ensure it only contains 0–3
% Uncomment to use:
%
% data = load('my_stm_data.mat');  % contains variable M
% M = uint8(data.M);
% assert(all(M(:) < 4), 'All entries must be in {0,1,2,3}');
% write_stm_mem(M, 'stm_from_mat.mem');


fprintf('Done.\n');
