function output = GlobalColorTransfer(source_img, target_img)
    %GlobalColorTransfer: transfer one image
    %   source_img: rgb source image
    %   target_img: rgb target image
    %   save: save output image or not
    %   output: rgb result image

    lab_source = RGB2LAB(source_img);
    lab_target = RGB2LAB(target_img);

    [mean_source, std_source] = GetMeanAndStandard(lab_source, false);
    [mean_target, std_target] = GetMeanAndStandard(lab_target, false);

    lab_result = zeros(size(lab_source));
    for channel=1:3
        lab_result(:, :, channel) = (lab_source(:, :, channel) - mean_source(channel)) * (std_target(channel) / std_source(channel));
        lab_result(:, :, channel) = round(lab_result(:, :, channel) + mean_target(channel));
    end
    lab_result(lab_result < 0) = 0;
    lab_result(lab_result > 255) = 255;
    
    output = LAB2RGB(lab_result);
    imwrite(output, ['result/global/r' num2str(img_id) '.bmp']);
    disp('Global Color Transfer done...');
end