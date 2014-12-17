function [coarse_seg] = findByThreshold(inputFileName , i_min , i_max , outputFilename )
%‫‪findByThreshold 

mat = load_untouch_nii_gzip(inputFileName);
Ts_im =  (i_min < mat.img) .* (mat.img < i_max);
dim = size(Ts_im);
aprox_lat = round(dim(3)/4);
samp = Ts_im(:, : , end-aprox_lat);

[r, c] = find(samp);
ref = [r,c]';
model = round(dim(1:2)/2)';
%find the closest non zero to the lungs area
cp = ref(:, nearestneighbour(model,ref))';
cp = sub2ind(dim, cp(1), cp(2), dim(3)-aprox_lat);

CC = bwconncomp(Ts_im ,6);
ind = cellfun(@(v) any(v==cp), CC.PixelIdxList);
idx = find(ind,1);

coarse_seg = zeros(dim);
coarse_seg(CC.PixelIdxList{idx})=1;

mat.img = coarse_seg;
save_untouch_nii(mat , outputFilename);
end
 

%'10000404_1_CTce_ThAb.nii.gz'