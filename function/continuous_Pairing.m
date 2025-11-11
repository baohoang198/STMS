function mating_pool = continuous_Pairing(Pop, N)

    num = size(Pop,1);
    mating_pool = zeros(num, N);

    for i = 1:num
        idx = randi(num);
        mating_pool(i,:) = Pop(idx,:);
    end
end
