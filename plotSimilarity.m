function plotSimilarity(within_data, ref_data, alpha, task, metric)
% GOAL: plot Figure 7A, i.e. comparing within-group similarity distributions 
%       against the reference similarity distribution

score_groups = {'Severe','Moderate','Mild'};
n_group = 3;

for i_group = 1:n_group
    group = score_groups{i_group};
    within_array = cell2mat(within_data.(group)(:,1));
    ref_array = cell2mat(ref_data(:,1));
    CI_within(i_group) = computeCI(alpha, n_group, within_array);
    mean_within(i_group) = mean(within_array);
end

switch metric
    case 'cs'
        color = [226 87 89] / 255;
    case 'ndiem'
        color = [126 71 148] / 255;
end

CI_ref = computeCI(alpha, n_group, ref_array);

x_values = 1:3;
x_offset = 0.5;
x_values_offset = x_values + x_offset;

% plotting
figure('Position', [100, 100, 450 400]);
errorbar(x_values_offset, mean_within, CI_within, 'o', 'LineWidth', 3.7, 'MarkerSize', 10, ...
    'MarkerEdgeColor', color, 'MarkerFaceColor', color, 'Color', color,'CapSize',11.6);
hold on

plot_mean = yline(mean(ref_array), '--', 'Color','#636363','LineWidth', 3);

x_fill = [0,4,4,0];
y_fill = [mean(ref_array) - CI_ref, mean(ref_array) - CI_ref, ...
    mean(ref_array) + CI_ref, mean(ref_array) + CI_ref];
fill(x_fill, y_fill, [0.4, 0.4, 0.4],'FaceAlpha', 0.15,'EdgeColor', 'none');
uistack(plot_mean, 'top');
set(gca, 'XColor', 'k', 'YColor', 'k', 'TickDir', 'out');
set(gca, 'FontSize', 17);
set(gca, 'LineWidth', 3);
set(gca, 'TickLength', [0.03, 0.035]);
xticks(x_values_offset);
xlim([min(x_values_offset) - 0.5, max(x_values_offset) + 0.5]);
xticklabels({'Severe','Moderate','Mild'});
box off

if strcmp(task, 'FlexorSynergy') && strcmp(metric, 'ndiem')
    ylim([9.7 11.1]);
    yticks(10:0.5:11);
elseif strcmp(task, 'FlexorSynergy') && strcmp(metric, 'cs')
    ylim([0.795 0.832]);
    yticks(0.8:0.01:9.83)
elseif strcmp(task, 'Forward') && strcmp(metric, 'ndiem')
    ylim([11.6 12.2]);
    yticks(11.6:0.2:12.2);
elseif strcmp(task, 'Forward') && strcmp(metric, 'cs')
    ylim([0.805 0.835]);
    yticks(0.8:0.01:9.83)
elseif strcmp(task, 'Grasp') && strcmp(metric, 'ndiem')
    ylim([9.4 10.6]);
    yticks(9.5:0.5:10.5);
elseif strcmp(task, 'Grasp') && strcmp(metric, 'cs')
    ylim([0.78 0.823]);
    yticks(0.78:0.01:0.82)
end

switch metric
    case 'cs'
        ylabel('CS', 'FontSize', 20);
    case 'ndiem'
        ylabel('N-DIEM', 'FontSize', 20);
end

fig_name = sprintf('Fig7A_%s_%s.png',metric, task);
set(gcf, 'Name', fig_name);
saveas(gcf,fullfile(pwd,'Figures',fig_name));
end