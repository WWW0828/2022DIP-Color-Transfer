function output = SuperpixelsKmeans(image, k)
    % SuperpixelsKmeans: Superpixels + K-means Clustering
    %    image: rgb source image
    %        k: number of cluster
    %   output: k-means cluster result

    [M, N, C] = size(image);
    output = zeros(M, N, 'double');

    % superpixels
    [S,NS] = superpixels(image,1500);
    
    Lab = im2single(rgb2lab(image));
    mean_lab = zeros(NS, 3, 'double');

    for i = 1:NS
        Lab_i = Lab .* double(S == i);  
        Lab_i(Lab_i == 0) = nan;
        mean_lab(i,:) = [mean(Lab_i(:,:,1), 'all', 'omitnan'), mean(Lab_i(:,:,2), 'all', 'omitnan'), mean(Lab_i(:,:,3), 'all', 'omitnan')]; 
    end
    mean_lab(isnan(mean_lab)) = 0;

    % kmeans
    mapping = kmeans(mean_lab, k, 'Replicates', 3);
    
    for x = 1:M
        for y = 1:N
            output(x,y) = mapping(S(x,y),1);
        end
    end
end