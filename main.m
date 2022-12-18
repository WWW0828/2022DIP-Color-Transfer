% main function
% source/* <-> target/* = result/*

n_img = 6;
%* FOR ALL IMAGES IN SOURCE & TARGET:
for img_id = 1:n_img
    % todo1: read images
    disp(['reading' 'source/s' num2str(img_id) '.bmp, target/t' num2str(img_id) '.bmp']);
    source_image = imread(['source/s' num2str(img_id) '.bmp']);
    target_image = imread(['target/t' num2str(img_id) '.bmp']);

    % todo2: color transfer
    result_image = ColorTransfer(source_image, target_image);

    % todo6: save new image
    imwrite(result_image, ['result/r' num2str(img_id) '.bmp']);
end