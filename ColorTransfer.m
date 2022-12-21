function output = ColorTransfer(source_img, target_img)
    %ColorTransfer: transfer one image
    %   source_img: rgb source image
    %   target_img: rgb target image
    %   output: rgb result image

    %todo1: convert to lab
    lab_source = RGB2LAB(source_img);
    lab_target = RGB2LAB(target_img);

    %todo2: calculate mean and standard
    [mean_source, std_source] = GetMeanAndStandard(lab_source);
    [mean_target, std_target] = GetMeanAndStandard(lab_target);

    %todo3: calculate new lab
    lab_result = zeros(size(lab_source));
    for channel=1:3
        lab_result(:, :, channel) = (lab_source(:, :, channel) - mean_source(channel)) * (std_target(channel) / std_source(channel));
        lab_result(:, :, channel) = round(lab_result(:, :, channel) + mean_target(channel));
    end
    lab_result(lab_result < 0) = 0;
    lab_result(lab_result > 255) = 255;
    
    %todo4: convert back to rgb    
    output = LAB2RGB(lab_result);
end