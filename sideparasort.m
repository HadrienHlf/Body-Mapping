function M1=sideparasort(L1, v)

i=size(L1,2);
while i>0
    if L1(1,i,1)==0 && i==size(L1,2)
        L1(1,i,1)=v(1);
        L1(1,i,2)=v(2);
    elseif L1(1,i,1)==0
        L1(1,i+1,1)=0;
        L1(1,i+1,2)=0;
        L1(1,i,1)=v(1);
        L1(1,i,2)=v(2);
    elseif v(2)<L1(1,i,2) && i~=size(L1,2)
        L1(1,i+1,1)=L1(1,i,1);
        L1(1,i+1,2)=L1(1,i,2);
        L1(1,i,1)=v(1);
        L1(1,i,2)=v(2);
    elseif v(2)<L1(1,i,2)
        L1(1,i,1)=v(1);
        L1(1,i,2)=v(2);

    end
    i=i-1;
end

M1=L1;