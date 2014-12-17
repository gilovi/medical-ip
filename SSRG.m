function ‫‪SSRG(input_FileName,‬‬ coarse_seg ‫‪,‬‬ ‫‪organ_type,‬‬ ‫)‪output_fileName‬‬
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% loop over the layers and take the closest local maxima from orig to the center of
% mass in the last conn and uses it as a seed for next

mat = load_untouch_nii_gzip(inputFileName);
orig_im = mat.img;
dim = size(orig_im);

if ‫‪organ_type < 3 
    %finding largest cut
    h = 1 : dim(3);

    cut_size = arrayfun(@(x) nnz(a(:,:,x)) ,h);
    [M,L_ind]= max(cut_size);
    %extract initial seed
    slice = coarse_seg(:,:,L_ind);
    CC = bwconncomp (slice,4);

    cent = regionprops(CC,'Centroid');
    seed = cent(L_ind);
    
    
end

end

