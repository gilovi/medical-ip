function SegmentOrgan (inputFileName, organ_type, outputFileName)
% 
mat = load_untouch_nii_gzip(inputFileName);
im = mat.img;
his = histc(im(:),min(im(:)):max(im(:)));

pixn = numel(im)/10000;
t_s = find (his<pixn,1,'first')-abs(min(im(:)));


end
