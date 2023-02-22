indexes=1:135;
acceptable_indexes=indexes([2:28, 30:31, 33:82, 84:94, 96:102, 104:110, 112, 114:118, 120:123, 125:128, 130:135]);

map_todisp=zeros(524,175,2);

m=2;

for i=acceptable_indexes
    for j=1:524
        for k=1:175
            ambimap_1=(s1.subs{i}.embody.bodymap{m}(j,k)>0)+(s1.subs{i}.embody.bodymap{m}(j,k)<0);
            ambimap_2=(s2.subs{i}.embody.bodymap{m}(j,k)>0)+(s2.subs{i}.embody.bodymap{m}(j,k)<0);

            map_todisp(j,k,1)=map_todisp(j,k,1)+ambimap_1/size(acceptable_indexes,1);
            map_todisp(j,k,2)=map_todisp(j,k,2)+ambimap_2/size(acceptable_indexes,1);
        end
    end
end

embody_plotmap(map_todisp(:,:,2))