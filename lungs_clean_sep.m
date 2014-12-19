function [ left , right ] = lungs_clean_sep(seg)
%lungs_clean_sep: cleans and saperates a slice to extract left and right lungs
% 
% inputs,
%   orig : the original image slice
%   seg : the segmented slice
%   
% outputs,
%   right_ind : the segmented slice conaining only the right lung
%   left_ind : the segmented slice conaining only the left lung


    CC = bwconncomp (seg,4);
    numPixels = cellfun(@numel,CC.PixelIdxList);   
  
    %the biggest component should be the right lung
    right = zeros(size(seg));
    left = right;
    [M,m_idx] = max(numPixels);
    right(CC.PixelIdxList{m_idx}) = 1;
    %the next biggest component should be the left lung
    numPixels(m_idx)= 0;
    [M,m_idx] = max(numPixels);
    left(CC.PixelIdxList{m_idx}) = 1;
end

