function [offspring1, offspring2] = mate_Roulette(dad,mom)
[row col]=size(dad);
dad=reshape(dad,1,row*col);
mom=reshape(mom,1,row*col);
a=1;
p1 = randi([a fix(row*col/2)]);
p2=randi([fix(row*col/2)+1 row*col-a]);

%% Create Mask
Mask1 = [ones(1,p1) zeros(1,p2-p1) ones(1,row*col-p2)];    
Mask2 = not(Mask1);
% disp(size(Mask1))

%% calculate offsprings
temp1 = dad .* Mask1;
temp2 = mom .* Mask2;
offspring1 = temp1+temp2;

temp1 = dad .* Mask2;
temp2 = mom .* Mask1;
offspring2 = temp1+temp2;

%% reshape
offspring1=reshape(offspring1,row,col);
offspring2=reshape(offspring2,row,col);
end