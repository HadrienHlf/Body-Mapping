function score = clusterScore(recap1, recap2, assignment)

centers1 = recap1(:,[1 2]);
count1 = recap1(:,3);
SD1 = recap1(:,4);

centers2 = recap2(:,[1 2]);
count2 = recap2(:,3);
SD2 = recap2(:,4); 

nb=size(assignment,1);
X=zeros(nb,2);

for i=1:nb
    k=assignment(i,1);
    l=assignment(i,2);

    X(i,1)=sqrt((centers1(k,[1 2])-centers2(l,[1 2]))*(centers1(k,[1 2])-centers2(l,[1 2]))');
    X(i,2)=abs(SD1(k)-SD2(l));
end

disp(X)