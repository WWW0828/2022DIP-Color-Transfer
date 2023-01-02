% main function
% source/* <-> target/* = result/*

n_img = 6;
%* FOR ALL IMAGES IN SOURCE & TARGET:
for img_id = 1:n_img
    disp(['reading ' 'source/s' num2str(img_id) '.bmp, target/t' num2str(img_id) '.bmp']);
    source_image = imread(['source/s' num2str(img_id) '.bmp']);
    target_image = imread(['target/t' num2str(img_id) '.bmp']);
    
    global_result = GlobalColorTransfer(source_image, target_image);
    imwrite(global_result, ['result/global/r' num2str(img_id) '.bmp']);
    
    kmeans_result = KMeansColorTransfer(source_image, target_image);
    imwrite(kmeans_result, ['result/kmeans/r' num2str(img_id) '.bmp']);
    
    probabalistic_result = ProbabalisticColorTransfer(source_image, target_image);
    imwrite(probabalistic_result, ['result/kmeans/r' num2str(img_id) '.bmp']);
end