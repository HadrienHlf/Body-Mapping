indexes=1:135;
acceptable_indexes=indexes([2:28, 30:31, 33:82, 84:94, 96:102, 104:110, 112, 114:118, 120:123, 125:128, 130:135]);

shuffled=acceptable_indexes(randperm(length(acceptable_indexes)));

betses=zeros(1240,1);
total_betses=zeros(1240,1);

for w=1:1000
for i=1:124
    np=acceptable_indexes(i);
    ns=shuffled(i);

    for j=1:10
        betses((i-1)*10+j,1)=1-pdist2(s1.subs{np}.embody.pcavects_withmean(:,j)',s2.subs{np}.embody.pcavects_withmean(:,j)','cosine');
    end 
end

total_betses=total_betses+betses/1000;

end

disp(nanmean(total_betses))

histogram(total_betses, 100, 'EdgeColor', 'r', 'FaceColor', 'r');
grid on;
xlabel('Value')
ylabel('Count')

%disp(nanmean(total_betses))