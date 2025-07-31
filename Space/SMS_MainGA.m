%% Constant
clc;
clear;
%addpath ('../SourceCode/function');
addpath('../function')
% % addpath(genpath('C:\Program Files\Matlab\toolbox\topotoolbox-master'))
% AF_pattern = AF_pattern(40,0);
numberCol = 8;
Incident = -20;
BWTarget = 3; %deg
peakTarget = [0];
Nbit = 2;

N=32;
Nstate = 2.^Nbit;
Num_indiv = 20;
Num_generation = 500;
%kmb=1;
%flag_equal=false;
%minbox=[];
EndFlag = 0;
LOG_NUM_GENERATION = [];
LOG_COST = [];
LOG_PATTERN = [];
FITNESS_VALUE=[];
num_draw = 0;

tic();
for idx_peak = 1: length(peakTarget)

fileID = fopen('log.csv','w');
fprintf(fileID,'F , cost , gen \n');
LOG_NUM_GENERATION = [];
LOG_COST = [];
LOG_PATTERN = [];
FITNESS_VALUE=[];
%% Initialize Population: Create random 20 binary matrix 10x10
count_FlagEnd=0;
% % % x=input('New GA? [1]Yes [0]No: ');
    Population = zeros(Num_indiv,N);
    for k =1:Num_indiv
        Pattern = randi([0 Nstate-1],1,N);
        Population(k,:) = Pattern;
    end

%% GA implementation
cost = zeros(Num_indiv,1);
for J = 1: Num_generation
    if (J == 1)
        for Q = 1:Num_indiv
            tmp_minQ0=0;
            Costx = Cost(Population(Q,:),Incident,peakTarget(idx_peak),BWTarget,Nbit,numberCol);
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
    end
    FITNESS_VALUE=[FITNESS_VALUE,cost(1)];
    LOG_NUM_GENERATION = [LOG_NUM_GENERATION; J];
    
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
            Costx=Cost(new_Population(Q,:),Incident,peakTarget(idx_peak),BWTarget,Nbit,numberCol);
            cost(Q) = Costx;
            num_draw = num_draw + 1;
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
    disp(['Gen ',num2str(J),' of Reflection Angle',num2str(peakTarget(idx_peak))]);
%     disp(Population(1,:));
%     disp(['Best Cost:',num2str(cost(1))])
%     writematrix(cost(:,:),['results/CostOfIndivInGen',num2str(J),'.txt']);
%     disp(cost(2))
end
% for i=1:Num_indiv
%     writematrix(Population(i,:),['results/POP',num2str(i),'_',num2str(peakTarget),'deg','_.csv']);
% end
writematrix(Population(1,:),['results/Incident',num2str(Incident),'_reflect_',num2str(peakTarget(idx_peak)),'.csv']);
writematrix(cost(1,:),['results/CostofIncident',num2str(Incident),'_reflect_',num2str(peakTarget(idx_peak)),'.txt']);
%%Results
k = figure(idx_peak);
plot(LOG_NUM_GENERATION,FITNESS_VALUE);
saveas(k,sprintf('results/GAresults_incident_-20_ref%d.png',idx_peak));
fclose(fileID);
Matrix=Population(1,:);
disp(Population(1,:));
disp(['Best Cost:',num2str(cost(1))])
end
toc();

