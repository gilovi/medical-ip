function SSRG(input_FileName, coarse_seg, organ_type, output_fileName)

    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here

    %take the last segmented cut, and finding the intersection of it with the
    %next two slices . the result edges will be the strong prior for the next
    %slice ans so on.

    mat = load_untouch_nii_gzip(input_FileName);
    orig_im = mat.img;
    dim = size(orig_im);

    % dealing with lungs
    if organ_type < 3 
        %finding largest cut
        h = 1 : dim(3);
        cut_size = arrayfun(@(x) nnz(coarse_seg(:,:,x)) ,h);
        [M,ind]= max(cut_size);
        slice = coarse_seg(:,:,ind);
        left_lung = slice;
        CC = bwconncomp (slice,4);
        numPixels = cellfun(@numel,CC.PixelIdxList);
        [M,m_idx] = max(numPixels);
        left_lung(CC.PixelIdxList{m_idx}) = 0;
        right_lung = slice-left_lung;
       
        if organ_type == 1 
            seed = left_lung;
        else
            seed = right_lung;
        end
        
        %passing on all the rest of the image
        p = cat(2,ind+1:dim(3),1:ind-1);
        for i = p
            
        %cent = regionprops(CC,'Centroid');
        %seed = cent(L_ind);    
        end

    end

%'wline = 0.005 ,term = 0.5 ,sigma 2 = 8 ,Mu = 0, Alpha=0.05')
%'wline = 0.005 ,term = 0.5 ,sigma 2 = 8 ,Mu = 0, Alpha=0.05 ,Beta =0.01 , kappa=17, Delta = -0.5'
%'wline = 0.005 ,term = 0.5 ,sigma 2 = 8 ,Mu = 0, Alpha=0.05 ,Beta =0 , kappa=4, Delta = -0.1')
%'wline = 0 ,term = 0.5 ,sigma 2 = 8 ,Mu = 0, Alpha=0.05 ,Beta =0.01 , kappa=4, Delta = -0.1')
%'wline = 0 ,term = 0.5 , sigma1 =4 sigma 2 = 5 ,Mu = 0, Alpha=0.05 ,Beta =0.01 , kappa=4, Delta = -0.1')