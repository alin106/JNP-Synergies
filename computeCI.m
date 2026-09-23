function CI = computeCI(alpha, n_group, data)
% GOAL: compute Bonferonni-adjusted CI half-width

a = (alpha/n_group)/2;
SEM = std(data)/sqrt(length(data));
ts = tinv(1-a, length(data)-1);
CI = ts*SEM; % CI half-width
end