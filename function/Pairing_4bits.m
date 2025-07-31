function mating_pool = Pairing(pop_keep,N)
k=1;
p=0;
mating_pool=[];
CP=zeros(length(pop_keep(1,1,:)),1);
%cumulative probabilities
for i=1:length(pop_keep(1,1,:))
    %     disp(i)
    if i==1
        CP(i)=(length(pop_keep(1,1,:))-i+1)/sum(1:length(pop_keep(1,1,:)));
    else
        CP(i)=CP(i-1)+(length(pop_keep(1,1,:))-i+1)/sum(1:length(pop_keep(1,1,:)));
        %     disp(CP(i))
    end
end
% disp(CP)

for j=1:length(pop_keep(1,1,:))
    r=rand;
    for jj=1:length(pop_keep(1,1,:))-1
        if r<CP(1)
            mating_pool(:,:,j)=pop_keep(:,:,1);
            break;
        elseif r>CP(jj) && r<=CP(jj+1)
            mating_pool(:,:,j)=pop_keep(:,:,jj+1);
            break;
        else
            continue;
        end
    end
end
for j=1:length(pop_keep(1,1,:))
    if mating_pool(:,:,j)==pop_keep(:,:,j)
        mating_pool(:,:,j)=randi([0 3],N,N);
    end
end
end