avg_betses=0;

for i=1:10
    avg_betses=avg_betses+findDissimilar(s1.subs,s2.subs,'emo',i,'ses','all','cosine',1)/10;
end

disp(avg_betses)


%%%%%%%

%disp((findDissimilar(s1.subs,s2.subs,'ses',1,'emo','all','cosine',1)+findDissimilar(s1.subs,s2.subs,'ses',2,'emo','all','cosine',1))/2)

%%%%%%%

%disp((findDissimilar(s1.subs,s2.subs,'ses',1,'sub','all','cosine',1)+findDissimilar(s1.subs,s2.subs,'ses',2,'sub','all','cosine',1))/2)