function final_final_avg = findDissimilar(sub_1, sub_2, within, choice, between, selection, metric, n)

case_number=0;

%Compute number of subjects and number of emotions
num_sub = max(size(sub_1));
num_emo = size(sub_1{12}.embody.pcavects,2);
num_ses = 2;

allVars={'sub','emo','ses'};

%convert 'all' into the right range, define a few useful lists
vars = {'sub','emo','ses'};
allRange = [num_sub; num_emo; num_ses];
vars(find(strcmp(vars,within))) = [];
vars(find(strcmp(vars,between))) = [];


if strcmp(selection,'all')
    selection=1:allRange(find(strcmp(allVars,vars{1})));
end


%CASE 1: WITHIN SUBJECT BETWEEN EMOTION IN SESSION

if strcmp('sub',within) && strcmp('emo',between)
    case_number=1;
    allMatrixes=zeros([num_emo,num_emo,num_ses]);
    
    for i=1:num_emo
        for j=1:num_emo
            allMatrixes(i,j,1)=rightMetric(sub_1{choice}.embody.pcavects_withmean(:,i),sub_1{choice}.embody.pcavects_withmean(:,j),metric);
            allMatrixes(i,j,2)=rightMetric(sub_2{choice}.embody.pcavects_withmean(:,i),sub_2{choice}.embody.pcavects_withmean(:,j),metric);
                
            if sum(sub_1{choice}.embody.bodymap{i},'all')==0 || sum(sub_1{choice}.embody.bodymap{j},'all')==0
                allMatrixes(i,j,1)=0;
            end

            if sum(sub_2{choice}.embody.bodymap{i},'all')==0 || sum(sub_2{choice}.embody.bodymap{j},'all')==0
                allMatrixes(i,j,2)=0;
            end

        end
    end


end

%CASE 2: WITHIN SUBJECT BETWEEN SESSION IN EMOTION

if strcmp('sub',within) && strcmp('ses',between)
    case_number=2;
    allMatrixes=zeros([1,1,num_emo]);
    
    for i=1:num_emo
        allMatrixes(1,1,i)=rightMetric(sub_1{choice}.embody.pcavects_withmean(:,i),sub_2{choice}.embody.pcavects_withmean(:,i),metric);

        if sum(sub_1{choice}.embody.bodymap{i},'all')==0 || sum(sub_2{choice}.embody.bodymap{i},'all')==0
             allMatrixes(1,1,i)=0;
        end

    end

end

%CASE 3: WITHIN EMOTION BETWEEN SUBJECT IN SESSION

if strcmp('emo',within) && strcmp('sub',between)
    case_number=3;
    allMatrixes=zeros([num_sub,num_sub,num_ses]);
    
    for i=1:num_sub
        for j=1:num_sub
            allMatrixes(i,j,1)=rightMetric(sub_1{i}.embody.pcavects_withmean(:,choice),sub_1{j}.embody.pcavects_withmean(:,choice),metric);
            allMatrixes(i,j,2)=rightMetric(sub_2{i}.embody.pcavects_withmean(:,choice),sub_2{j}.embody.pcavects_withmean(:,choice),metric);

            %allMatrixes(i,j,1)=rightMetric(sub_1.subs{i}.embody.bodymap{choice},sub_1.subs{j}.embody.bodymap{choice},metric);
            %allMatrixes(i,j,2)=rightMetric(sub_2.subs{i}.embody.bodymap{choice},sub_2.subs{j}.embody.bodymap{choice},metric);
            
            if sum(sub_1{i}.embody.bodymap{choice},'all')==0 || sum(sub_1{j}.embody.bodymap{choice},'all')==0
                allMatrixes(i,j,1)=0;
            end

            if sum(sub_2{i}.embody.bodymap{choice},'all')==0 || sum(sub_2{j}.embody.bodymap{choice},'all')==0
                allMatrixes(i,j,2)=0;
            end
                

        end
    end

end

%CASE 4: WITHIN EMOTION BETWEEN SESSION IN SUBJECT

if strcmp('emo',within) && strcmp('ses',between)
    case_number=4;
    allMatrixes=zeros([1,1,num_sub]);
    
    for i=1:num_sub
        allMatrixes(1,1,i)=rightMetric(sub_1{i}.embody.pcavects_withmean(:,choice),sub_2{i}.embody.pcavects_withmean(:,choice),metric);

        if sum(sub_1{i}.embody.bodymap{choice},'all')==0 || sum(sub_2{i}.embody.bodymap{choice},'all')==0
            allMatrixes(1,1,i)=0;
        end
        
    end

end

%CASE 5: WITHIN SESSION BETWEEN SUBJECTS IN EMOTION

if strcmp('ses',within) && strcmp('sub',between)
    case_number=5;
    allMatrixes=zeros([num_sub,num_sub,num_emo]);

    if choice==1
        sub_3=sub_1;
    else 
        sub_3=sub_2;
    end
    
    for i=1:num_sub
        for j=1:num_sub
            for k=1:num_emo
                allMatrixes(i,j,k)=rightMetric(sub_3{i}.embody.pcavects_withmean(:,k),sub_3{j}.embody.pcavects_withmean(:,k),metric);

                if sum(sub_3{i}.embody.bodymap{k},'all')==0 || sum(sub_3{j}.embody.bodymap{k},'all')==0
                    allMatrixes(i,j,k)=0;
                end

            end
        end
    end

end

%CASE 6: WITHIN SESSION BETWEEN EMOTIONS IN SUBJECT

if strcmp('ses',within) && strcmp('emo',between)
    case_number=6;
    allMatrixes=zeros([num_emo,num_emo,num_sub]);

    if choice==1
        sub_3=sub_1;
    else 
        sub_3=sub_2;
    end
    
    for i=1:num_emo
        for j=1:num_emo
            for k=1:num_sub
                allMatrixes(i,j,k)=rightMetric(sub_3{k}.embody.pcavects_withmean(:,i),sub_3{k}.embody.pcavects_withmean(:,j),metric);

                if sum(sub_3{k}.embody.bodymap{i},'all')==0 || sum(sub_3{k}.embody.bodymap{j},'all')==0
                    allMatrixes(i,j,k)=0;
                end

            end
        end
    end

end

%Selecting the desired parts of the matrix, and augment the dimension if
%needed

selMatrixes=allMatrixes(:,:,selection);

if (2*n)>numel(selMatrixes)
    disp("n is too high")
    return 
end

if ismatrix(selMatrixes)
    mock_slice=ones(size(selMatrixes));
    newMatrix=ones(size(selMatrixes,1),size(selMatrixes,2),2);
    newMatrix(:,:,1)=selMatrixes;
    newMatrix(:,:,2)=mock_slice;
    selMatrixes=newMatrix;

    selMatrixes(end,end,2)=1;
end

%FIND N MAX ELEMENTS

%replace all 1s by -2s
for slicenum=1:size(selMatrixes,3)
    slice=selMatrixes(:,:,slicenum);
    slice=round(slice, 6);
    slice(slice==1)=-2;
    selMatrixes(:,:,slicenum)=slice;
end

maxMatrices=selMatrixes;
%disp(maxMatrices)

final_cords=zeros(2*n,3);

within_strings={'subject','subject','emotion','emotion','session','session'};
between_strings={'emotions ','sessions ','subjects ','sessions ','subjects ','emotions '};
in_strings={'session ','emotion ','session ','subject ','emotion ','subject '};

disp(' ')

%find the n maximum elements
for m=1:n
    l=nanmax(maxMatrices,[],'all');
    [cor1,cor2,cor3] = ind2sub(size(maxMatrices),find(maxMatrices == l,1, 'first'));

    if case_number==2 || case_number==4
        cor2=2;
    end

    cor3=selection(cor3);
    final_cords(m,:)=[cor1,cor2,cor3];
    str_to_show=strcat({'Within '}, within_strings(case_number),{' '},num2str(choice),{', there is maximum similarity of '},num2str(l),{' between '},between_strings(case_number),num2str(cor1),{' and '}, num2str(cor2), {' in '} ,in_strings(case_number), num2str(cor3));
    disp(str_to_show{1});
    for slicenum=1:size(maxMatrices,3)
        slice=maxMatrices(:,:,slicenum);
        slice(slice==l)=-2;
        maxMatrices(:,:,slicenum)=slice;
    end
end

%replace all -2s by 2

for slicenum=1:size(selMatrixes,3)
    slice=selMatrixes(:,:,slicenum);
    slice=round(slice, 6);
    slice(slice==-2)=2;
    selMatrixes(:,:,slicenum)=slice;
end

disp(' ')

%find the n minimum elements

minMatrices=selMatrixes;

for min_m=1:n
    l=nanmin(minMatrices,[],'all');
    [cor1,cor2,cor3] = ind2sub(size(minMatrices),find(minMatrices == l,1, 'first'));

    if case_number==2 || case_number==4
        cor2=2;
    end

    cor3=selection(cor3);
    final_cords(min_m+m,:)=[cor1,cor2,cor3];
    str_to_show=strcat({'Within '}, within_strings(case_number),{' '},num2str(choice),{', there is minimum similarity of '},num2str(l),{' between '},between_strings(case_number),num2str(cor1),{' and '}, num2str(cor2), {' in '} ,in_strings(case_number), num2str(cor3));
    disp(str_to_show{1});
    for slicenum=1:size(minMatrices,3)
        slice=minMatrices(:,:,slicenum);
        slice(slice==l)=2;
        minMatrices(:,:,slicenum)=slice;
    end
end

%disp(final_cords)

disp(' ')

%find average (excluding diagonals)

counting=0;
totalcorr=0;

for p=1:size(selMatrixes,1)
    for q=1:size(selMatrixes,2)
        for r=1:size(selMatrixes,3)

            if (p~=q || size(selMatrixes,1)==1) && ~isnan(selMatrixes(p,q,r))
                counting=counting+1;
                totalcorr=totalcorr+selMatrixes(p,q,r);
            end

        end
    end
end

avgcorr=totalcorr/counting;

meantoshow=strcat({'Average cosine similarity between '},between_strings(case_number),{ 'is '},num2str(avgcorr));
%disp(meantoshow{1})
final_final_avg=avgcorr;