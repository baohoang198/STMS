function ind_mut = continuous_mutation(ind, lb, ub)
% Gaussian mutation with clipping to [lb, ub]

    pmut        = 0.1;       % probability of mutating each gene
    sigma_ratio = 0.1;       % 10% of range

    range = ub - lb;
    sigma = sigma_ratio .* range;

    mask    = rand(size(ind)) < pmut;
    ind_mut = ind + mask .* (sigma .* randn(size(ind)));

    % Clip to bounds
    ind_mut = max(ind_mut, lb);
    ind_mut = min(ind_mut, ub);
end
