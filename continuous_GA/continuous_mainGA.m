%% Continuous GA for antenna diameters: [W1 L1 W2 L2]
clc;
clear all;
close all;
addpath('../function')

Num_indiv      = 20;
Num_generation = 500;

% Number of design variables per individual
N = 4;   % [W1, L1, W2, L2]

% ====== BOUNDS (EDIT THESE TO YOUR REAL VALUES) ======
W1_min = 0.5;   W1_max = 5.0;
L1_min = 1.0;   L1_max = 10.0;
W2_min = 0.5;   W2_max = 5.0;
L2_min = 1.0;   L2_max = 10.0;

lb = [W1_min, L1_min, W2_min, L2_min];
ub = [W1_max, L1_max, W2_max, L2_max];
% =====================================================

LOG_NUM_GENERATION = [];
FITNESS_VALUE      = [];
num_draw           = 0;

tic();
fileID = fopen('log.csv','w');
fprintf(fileID,'F , cost , gen \n');

%% Initialize Population: random continuous values in [lb, ub]
Population = zeros(Num_indiv, N);
for k = 1:Num_indiv
    Population(k,:) = lb + (ub - lb).*rand(1, N);
end

%% GA implementation
cost = zeros(Num_indiv,1);

for J = 1:Num_generation
    %% Evaluate first generation and sort (your original structure)
    if (J == 1)
        for Q = 1:Num_indiv
            Costx   = continuous_Cost(Population(Q,:));   % <-- continuous cost
            cost(Q) = Costx;
        end
        % Sorting (same double-loop as your code)
        for Q = 1:(Num_indiv-1)
            for K = Q:Num_indiv
                if (cost(K) < cost(Q))
                    temp     = cost(K);
                    cost(K)  = cost(Q);
                    cost(Q)  = temp;

                    temp               = Population(K,:);
                    Population(K,:)    = Population(Q,:);
                    Population(Q,:)    = temp;
                end
            end
        end
    end

    %% Log
    FITNESS_VALUE      = [FITNESS_VALUE, cost(1)];
    LOG_NUM_GENERATION = [LOG_NUM_GENERATION; J];
    fprintf(fileID,'%f , %d\n', cost(1), J);

    %% Selection – keep best half
    half = fix(Num_indiv/2);
    new_Population          = zeros(Num_indiv, N);
    new_Population(1:half,:)= Population(1:half,:);

    %% Pairing
    mating_pool = continuous_Pairing(Population(1:half,:), N);

    %% Mating and mutation (continuous)
    K1 = 1;
    for K = 1:2:half
        % children indices: half+K and half+K+1 → 11..20
        idx1 = half + K;
        idx2 = half + K + 1;

        [child1, child2] = continuous_mate_Roulette(Population(K1,:), mating_pool(K1,:));

        new_Population(idx1,:) = continuous_mutation(child1, lb, ub);
        if idx2 <= Num_indiv
            new_Population(idx2,:) = continuous_mutation(child2, lb, ub);
        end

        K1 = K1 + 1;
        if K1 > half
            K1 = 1;   % loop inside best half if needed
        end
    end

    %% New Generation: evaluate new individuals and sort
    for Q = (half+1):Num_indiv
        Costx   = continuous_Cost(new_Population(Q,:));
        cost(Q) = Costx;
        num_draw = num_draw + 1;
    end

    % Sort new population (same structure as your code)
    for Q = 1:(Num_indiv-1)
        for K = Q:Num_indiv
            if (cost(K) < cost(Q))
                temp    = cost(K);
                cost(K) = cost(Q);
                cost(Q) = temp;

                temp                    = new_Population(K,:);
                new_Population(K,:)     = new_Population(Q,:);
                new_Population(Q,:)     = temp;
            end
        end
    end

    Population = new_Population(1:Num_indiv,:);

    disp(['Gen ',num2str(J)]);
    disp(['Best Cost: ',num2str(cost(1))])
end

%% Results
best_individual = Population(1,:)   % [W1 L1 W2 L2]
best_cost       = cost(1)

if ~exist('results','dir'); mkdir results; end
writematrix(best_individual,'results/best_antenna_dims.csv');
writematrix(best_cost,'results/best_antenna_cost.txt');

k = figure(1);
plot(LOG_NUM_GENERATION, FITNESS_VALUE);
xlabel('Generation'); ylabel('Best cost');
title('Continuous GA convergence');
saveas(k,'results/GAresults_continuous.png');

fclose(fileID);
toc();
