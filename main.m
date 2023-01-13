% main function
% source/* <-> target/* = result/*

n_img = 6;
%* FOR ALL IMAGES IN SOURCE & TARGET:
for img_id = 1:n_img
    % read images
    disp(['reading ' 'source/s' num2str(img_id) '.bmp, target/t' num2str(img_id) '.bmp']);
    source_image = imread(['source/s' num2str(img_id) '.bmp']);
    target_image = imread(['target/t' num2str(img_id) '.bmp']);
    result_image1 = GlobalColorTransfer(source_image, target_image, img_id);
    result_image2 = KmeansColorTransfer(source_image, target_image, img_id);
end