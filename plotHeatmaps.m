function plotHeatmaps(sim_matrix, subjs, task, metric)
% GOAL: plot Figure 6, i.e. uses similarity matrix (sim matrix to create 
%       heatmaps demonstrating differences between within-group and
%       between-group similarity

% Get score group indices (Severe/Moderate/Mild)
nSevere = numel(subjs(strcmp(subjs(:,2),"Severe")));
nModerate = numel(subjs(strcmp(subjs(:,2),"Moderate")));
nMild = numel(subjs(strcmp(subjs(:,2),"Mild")));

severe_idx = 1:nSevere;
moderate_idx = nSevere+1:nSevere+nModerate;
mild_idx = nSevere+nModerate+1:nSevere+nModerate+nMild;
group_idx = {severe_idx, moderate_idx, mild_idx};

sim_matrix(eye(size(sim_matrix)) == 1) = NaN;
sim_matrix_shuffled = sim_matrix;

% Shuffle subjects within each group for plotting purposes
if strcmp(task,'FlexorSynergy') && strcmp(metric,'cs')
    final_seed = 5;
elseif strcmp(task,'ShoulderFlex') && strcmp(metric,'cs')
    final_seed = 8;
elseif strcmp(task,'Grasp') && strcmp(metric,'cs')
    final_seed = 1;
else
    final_seed = 0;
end

for i_group = 1:length(group_idx)
    idx = group_idx{i_group};
    rng(final_seed);
    perm = randperm(length(idx));
    new_order = idx(perm);
    sim_matrix_shuffled(idx,:) = sim_matrix_shuffled(new_order,:);
    sim_matrix_shuffled(:,idx) = sim_matrix_shuffled(:,new_order);
end

% Smoothing within each group-group comparison (each "box" of the heatmap)
sigma = 2; % gaussian smoothing parameter
sim_matrix_filt = sim_matrix_shuffled;

for i_group1 = 1:length(group_idx)
    for i_group2 = 1:length(group_idx)
        rows = group_idx{i_group1};
        cols = group_idx{i_group2};

        % Filtering the current box
        submat = sim_matrix_shuffled(rows,cols);
        mask = ~isnan(submat);
        sub0 = submat;
        sub0(~mask) = 0;                         % filtering can't handle NaNs, so replace NaNs with 0s
        num = imgaussfilt(sub0,sigma);           % smooth values within each box
        den = imgaussfilt(double(mask),sigma);   % values close to diagonal will be weighed down by the diagonals 0, so den corrects for this
        sub_filt = num ./ den;                   % correction with den
        sub_filt(~mask) = NaN;                   % replace diagonals with NaN again
        sim_matrix_filt(rows,cols) = sub_filt;
    end
end

% Plot heatmap
figure;
imagesc(sim_matrix_filt);
colormap(jet);
hold on;
ax = gca;
ax.TickDir = 'out';
ax.XTick = []; ax.YTick = [];
ax.XTickLabel = []; ax.YTickLabel = [];
cb = colorbar;
cb.Ticks = [0.75 0.80 0.85];
cb.FontSize = 16;
xline(nSevere + 0.5,'k-','LineWidth',2);
xline(nSevere+nModerate+0.5,'k-','LineWidth',2);
yline(nSevere + 0.5, 'k-', 'LineWidth', 2);
yline(nSevere+nModerate+0.5,'k-','LineWidth',2);

% Bolden the outlines of within-group comparisons
for i_group = 1:length(group_idx)
    idx = group_idx{i_group};
    x1 = idx(1) - 0.5;
    x2 = idx(end) + 0.5;
    y1 = idx(1) - 0.5;
    y2 = idx(end) + 0.5;
    rectangle('Position',[x1,y1,x2-x1,y2-y1],'EdgeColor','k','LineWidth',3.5);
end

fig_name = sprintf('Fig6_%s_%s.png', metric, task);
set(gcf, 'Name', fig_name);
saveas(gcf, fullfile(pwd,'Figures',fig_name));
end
