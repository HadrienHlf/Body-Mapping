function assignment = GSVar(pr1,pr2)

unattributed=1:size(pr1,1);
used=zeros(size(pr2,1));
assignment=zeros(size(pr1,1),1);

while sum(unattributed)~=0
    for i=1:size(pr1,1)
        if unattributed(i)~=0

            for j=1:size(pr2,1)
                %disp(assignment)
                if used(pr1(i,j))==0
                    assignment(i)=pr1(i,j);
                    unattributed(i)=0;
                    used(pr1(i,j))=i;
                    break
                elseif find(pr2(pr1(i,j))==i,1)<find(pr2(pr1(i,j))==used(pr1(i,j)),1)
                    unattributed(used(pr1(i,j)))=used(pr1(i,j));
                    used(pr1(i,j))=i;
                    assignment(i)=used(pr1(i,j));
                end
            end

        end
    end
end