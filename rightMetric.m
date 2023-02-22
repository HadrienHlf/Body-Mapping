function dis = rightMetric(map_1, map_2, rmetric)

if strcmp(rmetric,'cosine')
    dis = 1-pdist2(map_1(:)',map_2(:)','cosine');
end

return 