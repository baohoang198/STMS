function result = mutation(A,Nstate)
    U = 0.003; 
[dim1, dim2] = size(A);
A=reshape(A,1,dim1*dim2);
muta = ceil(numel(A) * U);

randbit = randsample(dim1*dim2, muta);
% rand_col = randsample(dim2, muta);

for k = 1:muta     
    j = randbit(k);
    temp=A(1,j);
    while A(1,j)==temp
        A(1,j) = randi([0 Nstate],1,1);
    end
end
result = reshape(A,dim1,dim2);
end