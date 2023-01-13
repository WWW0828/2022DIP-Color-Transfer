function output = ProbabalisticColorTransfer(source_img, target_img, save)
    %ProbabalisticColorTransfer: transfer one image
    %   source_img: rgb source image
    %   target_img: rgb target image
    %   save: save output image or not
    %   output: rgb result image

    %* || Definition ||
    %  Gi: Gaussian distribution Gi(i;µi_t,σi_t) for region i
    %  µi_t: Mean of Gi at iteration t
    %  σi_t: Standard deviation of Gi at iteration t
    %  iPxy_t: Probability of pixel I(x,y) in Gi at iteration t
    %  Pxy_t: Probability distribution of pixel I(x,y) at iteration t
    %         Pxy_t = {iPxy_t | i = 1, 2, ...}
    
    % convert to lab
    lab_source = RGB2LAB(source_img);
    lab_target = RGB2LAB(target_img);

    
    % TODO1: Expectation
    % Estimate probability distribution Pxy_t in iteration t 
    % according to the result from iteration t − 1. Instead of 
    % using Eqn. 2, we introduce a new representation, subjected 
    % to Sum(iPxy_t) = 1, for i=1~N
    
    % TODO2: Spatial smoothing
    % Perform spatial smoothness propagation and update the
    % expectation values as iPxy_t.

    % TODO3: Maximization
    % Re-estimate µi_t and σi_t using Eqn. 3 and 4 with new probability
    % distribution iPxy_t for each Gaussian component i

    % TODO4: Refine Gaussians
    % Given the new estimation of Gaussian parameters from the previous step, 
    % for every pair of Gaussian components in the same image, e.g.,Gi(i; µi_t, σi_t) 
    % and Gj (j; µj_t, σj_t), if |µi_t − µj_t| < δ for some small δ, we merge them and 
    % re-estimate their parameters. 
    % Subject to the tolerance δ, this step produces an optimal number of Gaussians 
    % in each image. In practice, we iterate the algorithm for a fixed number of 
    % Gaussians until it converges before applying region merging. This produces 
    % better convergence result.

    % TODO5: Output
    % If the difference of means and variances between all corresponding pairs of 
    % Gaussian components between iterations t and t - 1 is small enough, and there 
    % is no Gaussian merging in current iteration t, stop. Otherwise, go back to  
    % step1 and begin iteration t + 1.
    
    % calculate mean and standard
    [mean_source, std_source] = GetMeanAndStandard(lab_source);
    [mean_target, std_target] = GetMeanAndStandard(lab_target);

    % calculate new lab
    lab_result = zeros(size(lab_source));
    
    % convert back to rgb    
    output = LAB2RGB(lab_result);
    if save
        imwrite(output, ['result/probabalistic/r' num2str(img_id) '.bmp']);
    end
    disp('Probabalistic Color Transfer done...');
end