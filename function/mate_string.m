function [offspring1, offspring2] = mate_string(A, B,N)
p = randsample(N-1,1);

Mask1 = [ones(1,p) zeros(1,N-p)];    

Mask2 = not(Mask1);

temp1 = A .* Mask1;
temp2 = B .* Mask2;

offspring1 = or(temp1,temp2);

temp1 = A .* Mask2;
temp2 = B .* Mask1;

offspring2 = or(temp1,temp2);
end


