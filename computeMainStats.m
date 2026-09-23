function [sim_results] = computeMainStats(within_data, ref_data)
% GOAL: compare within-group similarity distributions against reference
%       similarity distributions to determine significant differences
% Outputs:
%    stats_results: struct with results of all statistical tests
%    within_data: struct with arrays of within-group distributions
%    ref_data: array of the reference distribution

% Get score group indices (Severe/Moderate/Mild)
score_groups = {'Severe','Moderate','Mild'};
n_group = 3;

% Looping stats calculations over impairment groups
for i_group = 1:n_group
    group = score_groups{i_group};
    within_array = cell2mat(within_data.(group)(:,1));
    ref_array = cell2mat(ref_data(:,1));

    % Mann-Whitney U test
    [p,U,r] = computeMW(within_array,ref_array);
    p_adj = p * n_group;  % Bonferroni correction

    sim_results.(group).p_adj = p_adj;
    sim_results.(group).U = U;
    sim_results.(group).r = r;
end
end