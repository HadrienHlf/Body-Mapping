function smallmap = DownSample(mp, n)

an=fix(524/n)+1;
bn=fix(174/n)+1;

smallmap=zeros(an, bn);

for i=1:an
    for j=1:bn
        smallmap(i,j)=mean(mp((i-1)*n+1:min(i*n,524),(j-1)*n+1:min(j*n,175)),'all');
    end
end