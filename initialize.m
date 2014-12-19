clear all;
imread('test_im1.png');
 %coarse_seg = findByThreshold('C:\Users\gilmor\Google Drive\courses\MIP\10000412_1_CTce_ThAb.nii.gz',-2500,-500,'seg1');
 %mat = load_untouch_nii_gzip('C:\Users\gilmor\Google Drive\courses\MIP\10000412_1_CTce_ThAb.nii.gz');
 coarse_seg = findByThreshold('/cs/casmip/public/mip_2015_ex1/data/10000412_1_CTce_ThAb.nii.gz',-2500,-700,'seg1');
 mat = load_untouch_nii_gzip('/cs/casmip/public/mip_2015_ex1/data/10000412_1_CTce_ThAb.nii.gz');
 
% orig_im = mat.img;
% dim = size(orig_im);
% h = 1 : dim(3);
% cut_size = arrayfun(@(x) nnz(coarse_seg(:,:,x)) ,h);
% [M,ind]= max(cut_size);
% slice = coarse_seg(:,:,ind);
% left_lung = slice;
% CC = bwconncomp (slice,4);
% numPixels = cellfun(@numel,CC.PixelIdxList);
% [M,m_idx] = max(numPixels);
% left_lung(CC.PixelIdxList{m_idx}) = 0;
% right_lung = slice-left_lung;