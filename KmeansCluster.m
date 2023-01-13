function output = KmeansCluster(image, k)
    %KmeansCluster: transfer one image
    %   image: rgb source image
    %   k: number of cluster
    %   output: k-means cluster result

    [M, N, C] = size(image);
    output = zeros(M, N, 'double');

    Lab = im2single(RGB2LAB(image));

    % superpixels
    [S,NS] = superpixels(Lab,1200);
    mean_lab = zeros(NS, 3, 'double');
    for i = 1:NS
        Lab_i = Lab .* double(S == i);  
        Lab_i(Lab_i == 0) = nan;
        for j = 1:3
            mean_lab(i,j) = mean(Lab_i(:,:,j), 'all', 'omitnan'); 
        end
    end
    mean_lab(isnan(mean_lab)) = 0;

    % kmeans
    mapping = kmeans(mean_lab, k);
    for x = 1:M
        for y = 1:N
            output(x,y) = mapping(S(x,y),1);
        end
    end
end