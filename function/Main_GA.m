%% Constant
clc;
clear;
N=9;
c=3e8;
f=12e9;
lambda=c/f;
phiS=0;
thetaS=90;
lambda=c/f;
Num_gene = 20;
Num_generation = 250;
EndFlag = 0;
LOG_NUM_GENERATION = [];
LOG_COST = [];
LOG_PATTERN = [];
FITNESS_VALUE=[];
num_draw = 0;
fileID = fopen('log.csv','w');
fprintf(fileID,'F , cost , gen \n');
min_value=0;
tic();
%% Initialize Population: Create random 20 binary matrix 10x10
%he so danh gia dung cua GA
%tmp_maxQ0=0;
%tmp_maxQ1=0;
count_FlagEnd=0;

Population = zeros(N,N,Num_gene);
for k =1:Num_gene
    %Pattern = ones(H,N0);
    Pattern = randi([0 1],N,N);
    while(invalid(Pattern) == 1)
        Pattern = randi([0 1],N,N);
        %Pattern = ones(H,N0);
    end
    Population(:,:,k) = Pattern;
end


%% GA implementation
cost = zeros(Num_gene,1);
for J = 1: Num_generation
    
    %% Verify criteria
    if (J == 1)
        for Q = 1:Num_gene
            tmp_minQ0=0;
            cost(Q) = Fitness_function(Population(:,:,Q),f);
            num_draw = num_draw + 1;
        end
              
    else
        tmp_minQ0=cost(1);
        for Q = (Num_gene/2+1):Num_gene
            cost(Q) = Fitness_function(Population(:,:,Q),f);
            num_draw = num_draw + 1;
        end 
    end
    
    %% Selection: Sorting
    for Q = 1:(Num_gene-1)
        for K = Q:Num_gene
            if (cost(K)<cost(Q))
                temp = cost(K);
                cost(K) = cost(Q);
                cost(Q) = temp;
                temp = Population(:,:,K);
                Population(:,:,K) = Population(:,:,Q);
                Population(:,:,Q) = temp;
            end
        end
    end
    tmp_minQ1=cost(1);
    if tmp_minQ1==tmp_minQ0
        count_FlagEnd=count_FlagEnd+1;
    else
        count_FlagEnd=0;
    end
    
    if count_FlagEnd==30
        break;
    end

    FITNESS_VALUE=[FITNESS_VALUE,cost(1)];
    LOG_NUM_GENERATION = [LOG_NUM_GENERATION; J];
  
    %% Mating and mutation
    for K = 1:2:fix(Num_gene/2)
        [Population(:,:,K+Num_gene/2), Population(:,:,K+Num_gene/2+1) ] = mate(Population(:,:,K), Population(:,:,K+1),N);
        
        Population(:,:,K+Num_gene/2+1) = mutation(Population(:,:,K+Num_gene/2+1));
        
        while (invalid(Population(:,:,K+Num_gene/2))==1)
            Population(:,:,K+Num_gene/2) = mutation(Population(:,:,K+Num_gene/2));
        end
    end
    disp(Population);
    disp(['The he thu:',num2str(J)]);
    disp(['Cost(1):',num2str(cost(1))]);
    disp(['cost(10):',num2str(cost(10))]);
end
plot(LOG_NUM_GENERATION,FITNESS_VALUE);
fclose(fileID);
Matrix=Population(:,:,1);
toc();
