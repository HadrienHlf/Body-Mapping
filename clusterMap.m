function recap = clusterMap(map)

nb_dtp1=sum(map~=0,'all');

datapts1=zeros(nb_dtp1,3);

dt1ndex=1;

max_dist=size(map,1)/50;

for i = 1:size(map,2)
    for j=1:size(map,1)
        if map(j,i)~=0
            datapts1(dt1ndex,1)=size(map,1)-j;
            datapts1(dt1ndex,2)=i;
            datapts1(dt1ndex,3)=map(j,i);
            dt1ndex=dt1ndex+1;
        end
    end
end

X1 = datapts1(:,[1,2]);

idx = dbscan(X1,max_dist,10);

numGroups = length(unique(idx));


gscatter(X1(:,2),X1(:,1),idx,hsv(numGroups));
annotation('ellipse',[0.54 0.41 .07 .07],'Color','red')
grid



count = zeros(numGroups,1);
   for k = 1:numGroups
      count(k) = sum(idx==k);
   end

centers=zeros(numGroups, 2);
MDM=zeros(numGroups, 1);

for l=1:length(idx)
    centers(idx(l),1)=centers(idx(l),1)+X1(l,1)/count(idx(l));
    centers(idx(l),2)=centers(idx(l),2)+X1(l,2)/count(idx(l));
end

for m=1:length(idx)
    eucli=sqrt((X1(m,[1 2])-centers(idx(m),[1 2]))*(X1(m,[1 2])-centers(idx(m),[1 2]))');
    MDM(idx(m))=MDM(idx(m))+eucli/count(idx(m));
end

recap=[centers count MDM];
%disp(recap)