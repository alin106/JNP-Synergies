function [contrast_results, contrast_vals] = runContrast(m1,m2,data,task,alpha)
% GOAL: perform contrast analysis:
%       1) create contrast distributions
%       2) create csv's for artanova
%       3) perform contrast comparisons using Mann-Whitney U test, and 
%       4) plot Figure 7B
% Outputs:
%    contrast_results: struct with results of all statistical tests
%    contrast_vals: contrast distributions

score_groups = {'Severe','Moderate','Mild'};
n_group = 3;

% Colors for plotting
if strcmp(m1,'ndiem')
    m1_color = [126 71 148] / 255;
else
    m1_color = [226 87 89] / 255;
end

if strcmp(m2,'ndiem')
    m2_color = [126 71 148] / 255;
else
    m2_color = [226 87 89] / 255;
end

pair_centers = [1 4 7];
offset = 0.35;
figure('Position', [100, 100, 700, 350]); hold on

% Loop over score groups
for i_group = 1:n_group
    group = score_groups{i_group};

    % Get reference and within-group similarity data
    m1_ref = cell2mat(data.(m1).(task).ref_data(:,1));
    m2_ref = cell2mat(data.(m2).(task).ref_data(:,1));
    m1_within = cell2mat(data.(m1).(task).within_data.(group)(:,1));
    m2_within = cell2mat(data.(m2).(task).within_data.(group)(:,1));
    
    n_within = length(m1_within);
    n_ref = length(m1_ref);

    % Pooled variance estimators
    m1_pooled_est = sqrt(((var(m1_within) * (n_within - 1)) + ...
        (var(m1_ref) * (n_ref - 1))) / (n_within + n_ref - 2));

    m2_pooled_est = sqrt(((var(m2_within) * (n_within - 1)) + ...
        (var(m2_ref) * (n_ref - 1))) / (n_within + n_ref - 2));

    % Create contrast distributions
    m1_contrast = (m1_within - mean(m1_ref)) ./ m1_pooled_est;
    m2_contrast = (m2_within - mean(m2_ref)) ./ m2_pooled_est;

    % Saving contrast values
    contrast_vals.(group).(m1) = data.(m1).(task).within_data.(group);
    contrast_vals.(group).(m2) = data.(m2).(task).within_data.(group);
    contrast_vals.(group).(m1)(:,1) = num2cell(m1_contrast);
    contrast_vals.(group).(m2)(:,1) = num2cell(m2_contrast);

    % Exporting csv's to ~/artanova for artanova.R
    contrast_pairs.(group).(m1) = [contrast_vals.(group).(m1)(:,1), ...
     strcat(contrast_vals.(group).(m1)(:,2), '_', contrast_vals.(group).(m1)(:,3))];
    contrast_pairs.(group).(m2) = [contrast_vals.(group).(m2)(:,1), ...
        strcat(contrast_vals.(group).(m2)(:,2), '_', contrast_vals.(group).(m2)(:,3))];
    writecell(contrast_pairs.(group).(m1), fullfile(pwd, 'artanova', ...
        sprintf('artanova_%s_%s_%s.csv', m1, task, group)));
    writecell(contrast_pairs.(group).(m2), fullfile(pwd, 'artanova', ...
        sprintf('artanova_%s_%s_%s.csv', m2, task, group)));

    % Perform contrast comparisons (Mann-Whitney U test)
    [p,U,r] = computeMW(m1_contrast,m2_contrast);
    p_adj = p * n_group;

    % Saving
    contrast_results.(group).p_adj = p_adj;
    contrast_results.(group).U = U;
    contrast_results.(group).r = r;

    % Plotting
    m1_CI = computeCI(alpha, n_group, m1_contrast);
    m2_CI = computeCI(alpha, n_group, m2_contrast);

    x_m1 = pair_centers(i_group) - offset;
    x_m2 = pair_centers(i_group) + offset;
    plot(x_m1,mean(m1_contrast),'o','MarkerFaceColor',m1_color,'Color',m1_color, ...
        'MarkerSize',10,'LineWidth',2);
    plot(x_m2,mean(m2_contrast),'o','MarkerFaceColor',m2_color,'Color',m2_color, ...
        'MarkerSize',10,'LineWidth',2);
    errorbar(x_m1, mean(m1_contrast), m1_CI, 'Color', m1_color, 'LineWidth', 2, 'CapSize', 15);
    errorbar(x_m2, mean(m2_contrast), m2_CI, 'Color', m2_color, 'LineWidth', 2, 'CapSize', 15);
end

if strcmp(task,'Grasp')
    ylim([-0.55,0.55])
end

xlim([0 8])
xticks(pair_centers)
xticklabels({'Severe','Moderate','Mild'})
box off
set(gca,'TickDir','out','FontSize',18,'LineWidth',1.5)
ylabel('Contrast from Reference','FontSize',18)
fig_name = sprintf('Fig7B_%s_%s_%s.png', m1, m2, task);
set(gcf, 'Name', fig_name);
saveas(gcf, fullfile(pwd,'Figures',fig_name));
