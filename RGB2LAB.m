function LAB = RGB2LAB(input)
    %RGB2LAB: Convert RGB to CIE 1976 L*a*b*
    %   input: A rgb representation of an image wiht size: (M, N, 3, "uint8")
    %   LAB: A lab representation of an image with size: (M, N, 3, "uint8")

    R = double(input(:, :, 1));
    G = double(input(:, :, 2));
    B = double(input(:, :, 3));

    if max(max(R)) > 1.0 || max(max(G)) > 1.0 || max(max(B)) > 1.0
        R = double(R) / 255;
        G = double(G) / 255;
        B = double(B) / 255;
    end
    
    T = 0.008856;

    [M, N] = size(R); 
    s = M * N; 
    RGB = [reshape(R,1,s); reshape(G,1,s); reshape(B,1,s)];
    
    MAT = [ 0.5141, 0.3239, 0.1604;
            0.2651, 0.6702, 0.0641;
            0.0241, 0.1228, 0.0844];

    XYZ = MAT * RGB;

    % Normalize for D65 white point
    X = XYZ(1,:) / 0.950456;
    Y = XYZ(2,:);
    Z = XYZ(3,:) / 1.088754;

    XT = X > T;
    YT = Y > T;
    ZT = Z > T;
    Y3 = Y.^(1/3); 

    fX = XT .* X.^(1/3) + (~XT) .* (7.787 .* X + 16/116);
    fY = YT .* Y3 + (~YT) .* (7.787 .* Y + 16/116);
    fZ = ZT .* Z.^(1/3) + (~ZT) .* (7.787 .* Z + 16/116);

    L = reshape(YT .* (116 * Y3 - 16.0) + (~YT) .* (903.3 * Y), M, N);
    A = reshape(500 * (fX - fY), M, N);
    B = reshape(200 * (fY - fZ), M, N);
    LAB = cat(3, L, A, B);

end