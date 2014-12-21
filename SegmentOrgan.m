function [seg] = SegmentOrgan (inputFileName, organ_type, outputFileName)
% 
disp('loading mat')
mat = load_untouch_nii_gzip(inputFileName);
im = mat.img;
disp('calculating threshold')
his = histc(im(:),min(im(:)):max(im(:)));

pixn = numel(im)/10000;
t_s = find (his<pixn,1,'first')-abs(min(im(:)));
disp('finding by threshold...')
coarse = findByThreshold(mat , min(im(:))-1 , t_s , 'coarse' );
disp('SSRG')
seg = SSRG(mat, coarse, organ_type , outputFileName);


%seg= %TODO remove
end
