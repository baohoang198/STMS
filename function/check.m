function [list1, list2] = check(A)
% Searching submatrix ( 0 1; 1 0 ) and ( 1 0; 0 1)
% Return location of left-up element submatrix

H1 = [-1 1;1 -1];
H2 = [1 -1; -1 1];
%index1 = [0 0]; 
%index2 = [0;
index1 = zeros(0,0);
index2 = zeros(0,0);
A1 = conv2(A, H1, 'valid');
A2 = conv2(A, H2, 'valid');

[row1, col1] = find(A1 == 2);
[row2, col2] = find(A2 == 2);

if not(isequal(size(row1), [0 1]))
    index1 = [row1 col1];
end

if not(isequal(size(row2), [0 1]))
    index2 = [row2 col2];
end

list1 = index1;
list2 = index2;
end


