function [cont] = seed_contour(seed)
%SEED_CONTOUR rerturns the contour of filled seed 

fil = imfill(seed);
cont = edge(fil);

end

