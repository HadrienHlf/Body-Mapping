PCAmaps=zeros(50364, 10);

s1.emdata=getfield_list(s1.subs,'embody.vectmaps');
s1.emdata=cat(3,s1.emdata{:});
s1.emdata  = permute(s1.emdata,[3 1 2 ]);

s2.emdata=getfield_list(s2.subs,'embody.vectmaps');
s2.emdata=cat(3,s2.emdata{:});
s2.emdata  = permute(s2.emdata,[3 1 2 ]);

indexes=1:135;
acceptable_indexes=indexes([2:28, 30:31, 33:82, 84:94, 96:102, 104:110, 112, 114:118, 120:123, 125:128, 130:135]);

for l=acceptable_indexes
    for p=1:10
        if anynan(s1.subs{l}.embody.bodymap{p}) || anynan(s2.subs{l}.embody.bodymap{p})
            disp(l)
        end
    end
end

for i=1:50364
   for k=1:10
       PCAmaps(i,k)=ICC(3,'single',[s1.emdata(acceptable_indexes,i, k)  s2.emdata(acceptable_indexes,i, k)]);
   end
end

embody_plotmap(PCAmaps(:,10))

