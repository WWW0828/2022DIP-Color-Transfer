%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1. ADJUST THE 3 PARAMETERS (line 11~13) %%
%%    BEFORE RUNNING THE PROGRAM           %%
%% 2. ALSO REMEMBER TO CHECK THE FILEPATHS %%
%%    OF SOURCE/TARGET IMAGES (line 16~18) %%
%% 3. CHANGE THE FILEPATH OF RESULT IMAGE  %%
%%    SAVING IN LocalColorTransfer.m and   %%
%%    GlobalColorTransfer.m (imwrite(...)) %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

k = 6;                             % #cluster (for kmeans)
superpixel_before_kmeans = false;   % superpixels + kmeans (true) or only kmeans (false)
n_img = 6;                         % #sourceimage

for img_id = 1:n_img
    disp(['reading ' 'source/s' num2str(img_id) '.bmp, target/t' num2str(img_id) '.bmp']);
    source_image = imread(['source/s' num2str(img_id) '.bmp']);
    target_image = imread(['target/t' num2str(img_id) '.bmp']);
    result_image1 = GlobalColorTransfer(source_image, target_image, img_id);
    result_image2 = LocalColorTransfer(source_image, target_image, img_id, k, superpixel_before_kmeans);
end