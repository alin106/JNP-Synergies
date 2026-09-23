%% MainScript.m
% Code accompanying "Muscle synergy analysis reveals sources of variation in upper extremity
% motor control after stroke"
% Author: Adrian Lin
% Last Updated: 9/16/2026

clear; clc; close all
data = load('data.mat');

% Parameters
task_opt = {'FlexorSynergy','ShoulderFlex','Grasp'};
metric_opt = {'cs','ndiem'};
alpha = 0.05;
set(0, 'DefaultAxesFontName', 'Myriad Pro')

% Loop for all metrics and tasks
for i_metric = 1:length(metric_opt)
    metric = metric_opt{i_metric};

    for i_task = 1:length(task_opt)
        task = task_opt{i_task};
        sim_table = data.(metric).(task).sim_table;
        sim_matrix = table2array(sim_table);
        subjs = data.(metric).(task).subjs;

        % Figure 6 (Heatmap)
        if strcmp(metric,'cs')
            plotHeatmaps(sim_matrix, subjs, task, metric);
        end

        % Figure 7a (Similarity Analysis)
        within_data = data.(metric).(task).within_data;
        ref_data = data.(metric).(task).ref_data;

        [sim_results.(metric).(task)] = computeMainStats(within_data, ref_data);
        plotSimilarity(within_data, ref_data, alpha, task, metric);
    end
end

% Figure 7b (Contrast Analysis)
m1 = metric_opt{1}; % cs
m2 = metric_opt{2}; % ndiem

for i_task = 1:length(task_opt)
    task = task_opt{i_task};
    [contrast_results.(task), contrast_vals.(task)] = runContrast(m1,m2,data,task,alpha);
end
