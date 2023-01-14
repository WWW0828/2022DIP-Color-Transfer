function output = LocalColorTransfer(source, target, img_id, k, superpixel)
    % LocalColorTransfer: transfer one image
    %       source: rgb source image
    %       target: rgb target image
    %       img_id: image's id (for file saving)
    %            k: n_clusters in kmeans
    %   superpixel: whether to apply superpixels before kmeans clustering
    %       output: lab convert result
    
    disp('K-means Color Transfering...');
    
    if superpixel
        disp('- mode: superpixel: O, kmeans: O');
        mask_source = SuperpixelsKmeans(source, k);
        mask_target = SuperpixelsKmeans(target, k);
    else
        disp('- mode: superpixel: X, kmeans: O');
        mask_source = Kmeans(source, k);
        mask_target = Kmeans(target, k);
    end
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
    Lab_source = rgb2lab(source);
    Lab_target = rgb2lab(target);
    disp(' RGB -> Lab done...');
    
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
    min_d = 1e9;
    for n = 1:permutation_size(1,1)
        pardis = zeros(1, cluster_source);
        for i = 1:cluster_source
            pardis(i, :) = EMD(mean_source(i,:), mean_target(permutation(n, 1),:));
        end
        dis = sum(pardis, 'all');
        if dis < min_d
            min_d = dis;
            mapping = permutation(n,:);
        end
    end
    disp(' mapping function is constructed...');
    
    % adjusting the means and standard deviations of the synthetic image
    for x = 1:M
        for y = 1:N
            i = mask_source(x,y);
            j = mapping(1,i);
            for channel = 1:3
                new_Lab(x,y,channel) = ((Lab_source(x,y,channel) - mean_source(i,channel)) * (std_target(j,channel)/std_source(i,channel))) + mean_target(j,channel);
            end
        end
    end
    
    % converting the color back to RGB
    output = lab2rgb(new_Lab);
    disp(' Lab -> RGB done, saving result...');
    imwrite(output, ['result/current_execute/r' num2str(img_id) '_k0' num2str(k) '.bmp']);
end