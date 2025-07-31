function result = invalid(A)
[row,colummn] = size(A);
if (sum(A(row,:)) == 0)
    result = 1;
else
    [x_max, y_max] = size(A);
    one = ones(1, y_max);
    A = [A; one];
    [x_max, y_max] = size(A);
    padding = zeros(x_max + 2, y_max + 2);
    padding(2: x_max +1, 2: y_max + 1) = A;
    %padding(end, :) = 1;
    [row, col] = find(A == 1);
    list = [row(1) col(1)];
    len = length(row);
    matrix_test = [1 1 1; 1 0 1; 1 1 1];
    num = 0;
    has_check = [];
    while (length(list) > 0)
        %%% pop phan tu ra khoi list
        idx = list(1,:);
        has_check = [has_check; list(1,:)];
        num = num + 1;
        i = idx(1) + 1;     j = idx(2) + 1;
        list = list(2:end,:);

        %%% Tim phan tu 1 xung quang A[i,j]
        matrix = padding(i-1:i+1,j-1:j+1);
        matrix_result = matrix_test .* matrix;
        [row, col] = find(matrix_result == 1);
        row = row + i - 3;
        col = col + j -3;
        if isempty(row)
            continue
        end
        A = [row col];
        %%if isempty(list)
          %%  list = A;
            %%continue
       %% end
        new = [];
        for i = 1: length(row)
            [len_list, z] = size(has_check);
            ele = repmat(A(i,:), len_list, 1);
            temp = ele - has_check;
            temp = find( (temp(:,1) | temp(:,2) ) == 0);
            if ~isempty(temp)
                continue
            end
            [len_list, z] = size(list);
            if len_list
                ele = repmat(A(i,:), len_list, 1);
                temp = ele - list;
                temp = find( (temp(:,1) | temp(:,2) ) == 0);
                if ~isempty(temp)
                    continue
                end
            end
            new = [new; A(i,:)];
        end
        list = [list; new];
    end

    if num < len
        result = 1;
    else
        result = 0;
    end

end

end