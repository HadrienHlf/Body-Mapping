function final_dis = computeSimiDis(sub_1, sub_2, within, choice, between, selection, metric, n)

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

final_dis=selMatrixes(:);