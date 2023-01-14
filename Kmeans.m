function output = Kmeans(image, k)
    % Kmeans: K-means Clustering
    %    image: rgb source image
    %        k: number of cluster
    %   output: k-means cluster result
    
    [M, N, C] = size(image);

    Lab = im2single(rgb2lab(image));
    
    L = Lab(:, :, 1);
    a = Lab(:, :, 2);
    b = Lab(:, :, 3);
    data = double([L(:), a(:), b(:)]);
    
    mapping = kmeans(data, k, 'Replicates', 3);
    mapping = reshape(mapping, M, N);
    output = mapping;
end