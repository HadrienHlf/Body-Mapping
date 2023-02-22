indexes=1:135;
acceptable_indexes=indexes([3:9 12 14:26 28 30 31 33 35:38 40:50 52:57 59 61:62 64:67 69:70 72:82 84:85 88:89 91:94 96:102 104:109 112 115 116:118 120:123 125:128 130:134]);

for i=acceptable_indexes
    for j=1:10
        if isnan(1-pdist2(s1.subs{i}.embody.pcavects_withmean(:,j)',s1.subs{12}.embody.pcavects_withmean(:,j)','cosine'))
            disp('session 1')
            disp(i)

        end

        if isnan(1-pdist2(s2.subs{i}.embody.pcavects_withmean(:,j)',s2.subs{12}.embody.pcavects_withmean(:,j)','cosine'))
            disp('session 2')
            disp(i)
        end

    end
end

%SESSION1:114 113 103 87 63 58 51 34 32 27 11 10 2 1
%SESSION2:135 129 124 119 111 110 103 95 90 86 83 71 68 60 39 29 13 11 10 2
%
%FULL (30): 135 129 124 119 114 113 111 110 103 95 90 87 86 83 71 68 63 60 58 51 39 34 32 29 27 13 11 10 2 1
% 