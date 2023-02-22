function showSimData(s1, s2, num)

simdata=[];

if num==1
    for i=1:10
        simdata=[simdata,computeSimiDis(s1.subs,s2.subs,'emo',i,'ses','all','cosine',1)];
    end
end 

if num==2
    simdata=[computeSimiDis(s1.subs,s2.subs,'ses',1,'emo','all','cosine',1),computeSimiDis(s1.subs,s2.subs,'ses',2,'emo','all','cosine',1)];
end

if num==3
    simdata=[computeSimiDis(s1.subs,s2.subs,'ses',1,'sub','all','cosine',1),computeSimiDis(s1.subs,s2.subs,'ses',2,'sub','all','cosine',1)];
end

no_ones=simdata(round(simdata,4)~=1);

disp(nanmean(no_ones))
histogram(no_ones, 100, 'EdgeColor', 'b', 'FaceColor', 'b');
grid on;
xlabel('Value')
ylabel('Count')

boxplot(no_ones)