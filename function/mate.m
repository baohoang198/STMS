function [offspring1, offspring2] = mate(A,B,N)
p = randsample(N-1,1);
if (randi([0 1]))
    Mask1 = [ones(p,N);zeros(N-p,N)];    
else
    Mask1 = [ones(N,p),zeros(N,N-p)]; 
end

Mask2 = not(Mask1);

temp1 = A .* Mask1;
temp2 = B .* Mask2;

offspring1 = temp1+temp2;

temp1 = A .* Mask2;
temp2 = B .* Mask1;

offspring2 = temp1+temp2;
end