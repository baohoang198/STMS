function [child1, child2] = continuous_mate_Roulette(parent1, parent2)
% Continuous crossover (arithmetic/blend)

    alpha  = rand(1, numel(parent1));   % vector alpha for each gene
    child1 = alpha .* parent1 + (1-alpha) .* parent2;
    child2 = alpha .* parent2 + (1-alpha) .* parent1;
end
