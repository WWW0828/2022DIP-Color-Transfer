function [input_mean, input_std] = GetMeanAndStandard(input, omit)
    % GetMeanAndStandard: calculate mean and standard deviation of each channel
    %        input: lab image, channel(1,2,3) = (r,g,b)
    %   input_mean: mean of each channel, size: (1, 3)
    %    input_std: standard deviation of each channel, size: (1, 3)
    if ~omit
        input_mean = [mean2(input(:, :, 1)), mean2(input(:, :, 2)), mean2(input(:, :, 3))];
        input_std =  [std2(input(:, :, 1)), std2(input(:, :, 2)), std2(input(:, :, 3))];
    else
        input_mean = [mean(input(:, :, 1), 'all', 'omitnan'), mean(input(:, :, 2), 'all', 'omitnan'), mean(input(:, :, 3), 'all', 'omitnan')];
        input_std =  [std(input(:, :, 1), 0, 'all', 'omitnan'), std(input(:, :, 2), 0, 'all', 'omitnan'), std(input(:, :, 3), 0, 'all', 'omitnan')];
    end
end