function [p,U,r] = computeMW(x,y)
% GOAL: compute Mann-Whitney U test

[p,~,~] = ranksum(x,y);

n1 = numel(x);
n2 = numel(y);

allData = [x(:); y(:)];
ranks = tiedrank(allData);
R1 = sum(ranks(1:n1));
R2 = sum(ranks(n1+1:n1+n2));

U1 = R1 - n1*(n1+1)/2;  % # pairs where x > y
U2 = R2 - n2*(n2+1)/2;  % # pairs where x > y

U = min(U1,U2);         % reported U
r = 2*U1/(n1*n2) - 1;   % rank biserial coeff for determining directionality
                        % rank biserial formula: https://pmc.ncbi.nlm.nih.gov/articles/PMC12701665/
end
