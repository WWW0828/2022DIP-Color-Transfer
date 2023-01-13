function output = KmeansColorTransfer(source, target, img_id)
    %KmeansColorTransfer: transfer one image
    %   source: rgb source image
    %   target: rgb target image
    %   img_id: image's id (for file saving)
    %   output: lab convert result
    
    disp('K-means Color Transfering...');
    subplot(1, 2, 1); imshow(source); title('Source Image');
    subplot(1, 2, 2); imshow(target); title('Target Image');
    
    % if k >= 16, then in line 73: 
    % ERROR: Requested array exceeds the maximum possible variable size.
    k = 10; 
    neighbor = 3;
    
    mask_source = KmeansCluster(source, k);
    mask_target = KmeansCluster(target, k);
    disp(' k-mean clustering of source and target done...');
    
    [M, N, C] = size(source);
    cluster_source = max(mask_source, [], 'all');
    cluster_target = max(mask_target, [], 'all');
    mapping = zeros(1, cluster_source, 'uint8');
    
    mean_source = zeros(cluster_source, 3, 'double');
    mean_target = zeros(cluster_target, 3, 'double');
    std_source = zeros(cluster_source, 3, 'double');
    std_target = zeros(cluster_target, 3, 'double');
    new_Lab = zeros(M, N, C, 'double');
    
    % converting RGB to a decorrelated color space 𝑙𝛼𝛽
    Lab_source = RGB2LAB(source);
    Lab_target = RGB2LAB(target);
    disp(' convert from RGB to Lab color space done...');
    
    % compute probability
    alpha = 0.4;
    delta_s = 4;
    delta_c = 0.05;
    P = zeros(M, N, cluster_source, 'double');

    for x = 1:M
        for y = 1:N
            for xp = (x - neighbor):(x + neighbor)
                for yp = (y - neighbor):(y + neighbor)
                    if ~(xp < 1 || yp < 1 || xp > M || yp > N)
                        i = mask_source(xp,yp);
                        d = alpha * exp(-pdist2([x,y], [xp,yp], 'euclidean')/delta_s);
                        d = d + (1 - alpha) * exp(-pdist2(transpose(squeeze(Lab_source(x,y,:))), transpose(squeeze(Lab_source(xp,yp,:))), 'euclidean')/delta_c);
                        P(x, y, i) = P(x, y, i) + d;
                    end
                end
            end
            P(x,y,:) = P(x,y,:) / sum(P(x,y,:), 'all');
        end
    end
    disp(' probability computing done...');
    
    % computing the means and standard deviations
    for i = 1:cluster_source
        Lab_source_i = Lab_source .* double(mask_source == i);  
        Lab_target_i = Lab_target .* double(mask_target == i); 
        Lab_source_i(Lab_source_i == 0) = nan;
        Lab_target_i(Lab_target_i == 0) = nan;
        [mean_source(i, :), std_source(i, :)] = GetMeanAndStandard(Lab_source_i, true);
        [mean_target(i, :), std_target(i, :)] = GetMeanAndStandard(Lab_target_i, true);
    end
    disp(' mean and standard deviation computing done...');
    
    % construct the mapping function
    permutation = perms((1:cluster_source)); 
    permutation_size = size(permutation);
    min = 1e9;
    for n = 1:permutation_size(1,1)
        dis = 0;
        for i = 1:cluster_source
            dis = dis + EMD(mean_source(i,:), mean_target(permutation(n,i),:));
        end 
        if dis < min
            min = dis;
            mapping = permutation(n,:);
        end
    end
    disp(' mapping function is constructed...');
    
    % adjusting the means and standard deviations of the synthetic image
    for x = 1:M
        for y = 1:N
            for k = 1:3
                i = mask_source(x,y);
                j = mapping(1,i);
                new_Lab(x,y,k) = P(x,y,i) * ((Lab_source(x,y,k) - mean_source(i,k)) * (std_target(j,k)/std_source(i,k))) + mean_target(j,k);
            end
        end
    end
    
    % converting the color back to RGB
    output = LAB2RGB(new_Lab);

    imwrite(output, ['result/kmeans/r' num2str(img_id) '.bmp']);
    disp('K-means Color Transfer done...');
end