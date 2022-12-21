function RGB = LAB2RGB(input)
    %LAB2RGB: Convert CIE 1976 L*a*b* to RGB
    %   input: A lab representation of an image wiht size: (M, N, 3, "uint8")
    %   RGB: A rgb representation of an image with size: (M, N, 3, "uint8")

    L = input(:, :, 1);
    A = input(:, :, 2);
    B = input(:, :, 3);
    
    % Thresholds
    T1 = 0.008856;
    T2 = 0.206893;

    [M, N] = size(L);
    s = M * N;

    L = reshape(L, 1, s);
    A = reshape(A, 1, s);
    B = reshape(B, 1, s);

    % Compute Y
    fY = ((L + 16) / 116) .^ 3;
    YT = fY > T1;
    fY = (~YT) .* (L / 903.3) + YT .* fY;
    Y = fY;

    % Alter fY slightly for further calculations
    fY = YT .* (fY .^ (1/3)) + (~YT) .* (7.787 .* fY + 16/116);

    % Compute X
    fX = A / 500 + fY;
    XT = fX > T2;
    X = (XT .* (fX .^ 3) + (~XT) .* ((fX - 16/116) / 7.787));

    % Compute Z
    fZ = fY - B / 200;
    ZT = fZ > T2;
    Z = (ZT .* (fZ .^ 3) + (~ZT) .* ((fZ - 16/116) / 7.787));

    % Normalize for D65 white point
    X = X * 0.950456;
    Z = Z * 1.088754;

    % XYZ to RGB
    MAT = [0.5141, 0.3239, 0.1604;
           0.2651, 0.6702, 0.0641;
           0.0241, 0.1228, 0.0844];
    MAT = inv(MAT);

    RGB = max(min(MAT * [X; Y; Z], 1), 0);
    R = reshape(RGB(1,:), M, N);
    G = reshape(RGB(2,:), M, N);
    B = reshape(RGB(3,:), M, N); 
    RGB = uint8(round(cat(3,R,G,B) * 255));
    
end