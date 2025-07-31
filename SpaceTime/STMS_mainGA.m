
%% Constant
clc;
clear;
addpath('../function')

%% Initial Parameter
Nbit = 2;
Nstate = 2.^Nbit;

num_elemets_x = 16;
num_elemets_y = 16;
leng_time = 8;
N = num_elemets_y*leng_time;
theta_desired = [ -50 -30 0 30 50];
Num_indiv = 20;
Num_generation = 10; 
tic();


fileID = fopen('log.csv','w');
fprintf(fileID,'F , cost , gen \n');
LOG_NUM_GENERATION = [];
LOG_COST = [];
LOG_PATTERN = [];
FITNESS_VALUE=[];

%% Initialize Population
count_FlagEnd=0;
% % % x=input('New GA? [1]Yes [0]No: ');
Population = zeros(Num_indiv,N);
for k =1:Num_indiv
    Pattern = randi([0 Nstate-1],1,N);
    Population(k,:) = Pattern;
end
n = 1;
%% GA implementation
cost = zeros(Num_indiv,1);
while (n ~=0)
    for Q = 1:Num_indiv
        tmp_minQ0=0;
        Costx=Cost_function(num_elemets_x,num_elemets_y,Population(Q,:),theta_desired);
        cost(Q) = Costx;
    end
    %% Selection: Sorting
    for Q = 1:(Num_indiv-1)
        for K = Q:Num_indiv
            if (cost(K)<cost(Q))
                temp = cost(K);
                cost(K) = cost(Q);
                cost(Q) = temp;
                temp = Population(K,:);
                Population(K,:) = Population(Q,:);
                Population(Q,:) = temp;
            end
        end
    end

    FITNESS_VALUE=[FITNESS_VALUE,cost(1)];
    LOG_NUM_GENERATION = [LOG_NUM_GENERATION; n];

    %% Selection
    new_Population=[];
    new_Population(1:fix(Num_indiv/2),:)=Population(1:fix(Num_indiv/2),:);
    mating_pool=Pairing(Population(fix(Num_indiv/2):Num_indiv,:),N,Nstate-1);

    %% Mating and mutation
    K1=1;
    for K = 1:2:fix(Num_indiv)
        [new_Population(K+fix(Num_indiv/2),:), new_Population(K+fix(Num_indiv/2)+1,:) ] = mate_Roulette(Population(K1,:), mating_pool(K1,:));
        K1=K1+1;
        new_Population(K+fix(Num_indiv/2),:) = mutation(new_Population(K+fix(Num_indiv/2)+1,:),Nstate-1);
        new_Population(K+fix(Num_indiv/2)+1,:) = mutation(new_Population(K+fix(Num_indiv/2)+1,:),Nstate-1);

    end

    %% New Generation
    for Q = (Num_indiv/2+1):length(new_Population(:,1))
        Costx=Cost_function(num_elemets_x,num_elemets_y,new_Population(Q,:),theta_desired);
        cost(Q) = Costx;
    end
    for Q = 1:length(new_Population(:,1))-1
        for K = Q:length(new_Population(:,1))
            if (cost(K)<cost(Q))
                temp = cost(K);
                cost(K) = cost(Q);
                cost(Q) = temp;
                temp = new_Population(K,:);
                new_Population(K,:) = new_Population(Q,:);
                new_Population(Q,:) = temp;
            end
        end
    end

    %% Results
    Population=new_Population(1:Num_indiv,:);
    disp(['Gen ',num2str(n)]);
    disp(['Cost: ',num2str(cost(1))]);
    %     disp(Population(1,:));
    %     disp(['Best Cost:',num2str(cost(1))])
    %     writematrix(cost(:,:),['results/CostOfIndivInGen',num2str(J),'.txt']);
    %     disp(cost(2))
    n = n+1;

    %% Covergence
    if cost(1) <= 20
        break,
    end
    if n == 3000
        break,
    end
end
% for i=1:Num_indiv
%     writematrix(Population(i,:),['results/POP',num2str(i),'_',num2str(peakTarget),'deg','_.csv']);
% end
writematrix(Population(1,:),'results/220926_spaceTimeSequence1.csv');
writematrix(cost(1,:),'results/220926_spaceTimeSequence1.txt');
%%Results
k = figure();
plot(LOG_NUM_GENERATION,FITNESS_VALUE);
xlabel('Generation');
ylabel('Cost value');
saveas(k,sprintf('results/220926_GAresults_incident1.png'));
fclose(fileID);
Matrix=Population(1,:);
disp(Population(1,:));
disp(['Best Cost:',num2str(cost(1))])
toc();

