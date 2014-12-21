function [ VD, VOD ] = evaluateSegmentation (segmentationFilename, groundTruthFilename‬‬)
%   evals the segmentation error
   seg_mat = load_untouch_nii_gzip(segmentationFilename); 
   seg = seg_mat.img;
   
   GT_mat = load_untouch_nii_gzip(groundTruthFilename‬‬);
   GT = GT_mat.img;
   
   ovetlap = (GT-seg);
   
   segprops =regionprops(seg_mat.img ,'Area')

end

