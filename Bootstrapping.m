function Bootstrapping(loops,s1,s2)

indexes=1:135;
acceptable_indexes=indexes([3:9 12 14:26 28 30 31 33 35:38 40:50 52:57 ...
    59 61:62 64:67 69:70 72:82 84:85 88:89 91:94 96:102 104:109 112 115 ...
    116:118 120:123 125:128 130:134]);

total_between_emotions=ones(105,90,loops);
total_between_sessions=ones(105,10,loops);
between_emotions_means=ones(loops, 1);

for run=1:loops
    sample_with_rp=datasample(acceptable_indexes,105);

    for i=1:105
        sp=sample_with_rp(i);
        emocount=1;

        for j=1:10

            total_between_sessions(i,j,run)=1-pdist2(s1.subs{sp}.embody.pcavects_withmean(:,j)',s2.subs{sp}.embody.pcavects_withmean(:,j)','cosine');

            for k=(j+1):10

                total_between_emotions(i,emocount,run)=1-pdist2(s1.subs{sp}.embody.pcavects_withmean(:,j)',s1.subs{sp}.embody.pcavects_withmean(:,k)','cosine');
                emocount=emocount+1;
                total_between_emotions(i,emocount,run)=1-pdist2(s2.subs{sp}.embody.pcavects_withmean(:,j)',s2.subs{sp}.embody.pcavects_withmean(:,k)','cosine');
                emocount=emocount+1;

            end
        end
       
    end

    between_emotions_means(run)=mean(total_between_emotions(:,:,run),'all');

end

avg_between_emotions=mean(total_between_emotions,'all');
avg_between_sessions=mean(total_between_sessions,'all');

p_value=sum(between_emotions_means>0.2991,'all')/sum(between_emotions_means>-2,'all');

disp(avg_between_emotions)
disp(avg_between_sessions)
disp(p_value)
disp(between_emotions_means)

histogram(total_between_emotions(:), 100, 'EdgeColor', 'b', 'FaceColor', 'b');
grid on;
xlabel('Value')
ylabel('Count')