function Distmetrics(mp_1, mp_2)

%absolute values of maps
map_1=abs(mp_1);
map_2=abs(mp_2);

%+1 when positive, -1 when negative
ambimap_1=(mp_1>0)-(mp_1<0);
ambimap_2=(mp_2>0)-(mp_2<0);

%sum of elementwise multiplication normalized with product sum of both matrixes
metric_1=sum(map_1.*map_2, 'all')/((sum(map_1, 'all'))*sum(map_2, 'all'));

%same with grids composed only of 0s and 1s
metric_1_1=sum(map_1|map_2, 'all')/((sum(map_1~=0, 'all'))*sum(map_2~=0, 'all'));

%same with square of the numerator (to get 1 in case of perfect match) and
%square root of the total score
metric_1_2=sqrt((sum((map_1.*map_2)~=0, 'all').^2)/((sum(map_1~=0, 'all'))*sum(map_2~=0, 'all')));

%same but taking negs and pos into account in the numerator only
metric_1_3=sqrt((sum((ambimap_1.*ambimap_2), 'all').^2)/((sum(map_1~=0, 'all'))*sum(map_2~=0, 'all')));

%same without binarization
raw_resemblance=(sum((mp_1.*mp_2), 'all')^2)/(sum((mp_1.^2), 'all') * sum((mp_2.^2), 'all'));
metric_1_4 = sqrt(raw_resemblance);

%same without sign-sensitivity
raw_unsigned_resemblance=(sum((map_1.*map_2), 'all')^2)/(sum((map_1.^2), 'all') * sum((map_2.^2), 'all'));
metric_1_5 = sqrt(raw_unsigned_resemblance);

%cosine similarity
cossi=1-pdist2(mp_1(:)',mp_2(:)','cosine');

fprintf('\n\nWITHOUT DOWNSAMPLING\n\n')
fprintf('\n1. Sign Insensitive Binarized Cosine Similarity: %.15g\n',round(metric_1_2,5));
fprintf('\n2. Sign Sensitive Binarized Cosine Similarity: %.15g\n',round(metric_1_3,5));
fprintf('\n3. Sign Insensitive Unbinarized Cosine Similarity: %.15g\n',round(metric_1_5,5));
fprintf('\n4. Sign Sensitive Unbinarized Cosine Similarity: %.15g\n',round(metric_1_4,5));
fprintf('\n5. Cosine Similarity: %.15g\n',round(cossi,5));
disp(' ')

downsample_c=10;
sm1=DownSample(mp_1,downsample_c);
sm2=DownSample(mp_2,downsample_c);

sambimap_1=(sm1>0)-(sm1<0);
sambimap_2=(sm2>0)-(sm2<0);

smap_1=abs(sm1);
smap_2=abs(sm2);


fprintf('\n\nWITH DOWNSAMPLING OF FACTOR %.15g\n\n', downsample_c);

%same with square of the numerator (to get 1 in case of perfect match) and
%square root of the total score
dmetric_1_2=sqrt((sum((smap_1.*smap_2)~=0, 'all').^2)/((sum(smap_1~=0, 'all'))*sum(smap_2~=0, 'all')));

%same but taking negs and pos into account in the numerator only
dmetric_1_3=sqrt((sum((sambimap_1.*sambimap_2), 'all').^2)/((sum(smap_1~=0, 'all'))*sum(smap_2~=0, 'all')));

%same without binarization
sraw_resemblance=(sum((sm1.*sm2), 'all')^2)/(sum((sm1.^2), 'all') * sum((sm2.^2), 'all'));
dmetric_1_4 = sqrt(sraw_resemblance);

%same without sign-sensitivity
sraw_unsigned_resemblance=(sum((smap_1.*smap_2), 'all')^2)/(sum((smap_1.^2), 'all') * sum((smap_2.^2), 'all'));
dmetric_1_5 = sqrt(sraw_unsigned_resemblance);

%cosine similarity
dcossi=sqrt(sum(sm1.*sm2,'all'))/(sqrt(sum(sm1.^2,'all'))*sqrt(sum(sm2.^2,'all')));

fprintf('\n1. Sign Insensitive Binarized Cosine Similarity: %.15g\n',round(dmetric_1_2,5));
fprintf('\n2. Sign Sensitive Binarized Cosine Similarity: %.15g\n',round(dmetric_1_3,5));
fprintf('\n3. Sign Insensitive Unbinarized Cosine Similarity: %.15g\n',round(dmetric_1_5,5));
fprintf('\n4. Sign Sensitive Unbinarized Cosine Similarity: %.15g\n',round(dmetric_1_4,5));
disp(' ')


%clustering 

true_k=12;
downsample_c=7;

sm1=DownSample(mp_1,downsample_c);
sm2=DownSample(mp_2,downsample_c);

nb_dtp1=sum(sm1~=0,'all');
nb_dtp2=sum(sm2~=0,'all');

datapts1=zeros(nb_dtp1,3);
datapts2=zeros(nb_dtp2,3);

dt1ndex=1;
dt2ndex=1;

for i = 1:size(sm1,2)
    for j=1:size(sm1,1)
        if sm1(j,i)~=0
            datapts1(dt1ndex,1)=size(sm1,1)-j;
            datapts1(dt1ndex,2)=i;
            datapts1(dt1ndex,3)=sm1(j,i);
            dt1ndex=dt1ndex+1;
        end

        if sm2(j,i)~=0
            datapts2(dt2ndex,1)=size(sm1,1)-j;
            datapts2(dt2ndex,2)=i;
            datapts2(dt2ndex,3)=sm2(j,i);
            dt2ndex=dt2ndex+1;
        end
    end
end

X1 = datapts1(:,[1,2]);
X2 = datapts2(:,[1,2]);


%{


figure;
plot(X1(:,2),X1(:,1),'k*','MarkerSize',5);
title 'Map';
xlabel 'X'; 
ylabel 'Y';

rng(1); % For reproducibility
[idx,C] = kmeans(X1,true_k);

x1 = min(X1(:,1)):0.01:max(X1(:,1));
x2 = min(X1(:,2)):0.01:max(X1(:,2));
[x1G,x2G] = meshgrid(x1,x2);
XGrid = [x1G(:),x2G(:)]; % Defines a fine grid on the plot


disp('starting kmeans')
idx2Region = kmeans(XGrid,true_k,'MaxIter',250,'Start',C);

disp('finishing kmeans')

figure;
gscatter(XGrid(:,2),XGrid(:,1),idx2Region,...
    [0,0.75,0.75;0.75,0,0.75;0.75,0.75,0],'..');
hold on;
plot(X1(:,2),X1(:,1),'k*','MarkerSize',5);
title 'Map';
xlabel 'X';
ylabel 'Y'; 
legends=['Region 1','Region 2','Region 3','Region 4','Region 5','Region
6','Region 7','Region 8','Region 9','Region 10','Region 11','Region 12']
legend('Region 1','Region 2','Region 3','Data','Location','SouthEast');
hold off;
%}

%DBSCAN
