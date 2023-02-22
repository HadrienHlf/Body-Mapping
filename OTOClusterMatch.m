function score = OTOClusterMatch(map_1, map_2)

recap1=clusterMap(map_1);
recap2=clusterMap(map_2);

inversion=0;

if size(recap1, 1) > size(recap2, 1)
    recap0=recap2;
    recap2=recap1;
    recap1=recap0;
    inversion=1;
end

centers1 = recap1(:,[1 2]);
count1 = recap1(:,3);

centers2 = recap2(:,[1 2]);
count2 = recap2(:,3);

nc1=length(count1);
nc2=length(count2);

pri1=zeros(nc1, nc2, 2);
pri2=zeros(nc2, nc1, 2);

for i=1:nc1
    for j=1:nc2
        dis=sqrt((centers1(i,[1 2])-centers2(j,[1 2]))*(centers1(i,[1 2])-centers2(j,[1 2]))');
        pri1(i,:,:)=sideparasort(pri1(i,:,:),[j,dis]);
    end
end

for k=1:nc2
    for l=1:nc1
        dis=sqrt((centers1(l,[1 2])-centers2(k,[1 2]))*(centers1(l,[1 2])-centers2(k,[1 2]))');
        pri2(k,:,:)=sideparasort(pri2(k,:,:),[l,dis]);
    end
end

priorities_1=pri1(:,:,1);
priorities_2=pri2(:,:,1);

assignment=GSVar(priorities_1,priorities_2);

rang=(1:nc1)';

if inversion==0
    final_assignment=[rang, assignment];
else
    final_assignment=[assignment, rang];
    recap0=recap1;
    recap1=recap2;
    recap2=recap0;
end

disp(final_assignment)
clusterScore(recap1,recap2,final_assignment)