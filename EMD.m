function output = EMD(Cs_i, Ct)
%EMD(Earth Mover's Distance) 
    delta = 15;
    dis = pdist2(Cs_i(1,:), Ct(1,:), 'euclidean');
    output = 1-exp(-dis/delta);
end