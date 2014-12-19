function [seg] = get_seg( mask , orig )
% returns a segmentes slice of orig form a given mask image
%ths function uses Region Growing algo to extract the segmentation 

    RG_pram = 0.07;
    CC = bwconncomp(mask,4);
    
    SEG = zeros(size(orig));
    orig_size = size(orig);
 
    %clean noise
    for i =1:length(CC.PixelIdxList)
        if length(CC.PixelIdxList{i}) < 20
            continue;
        end
        compo = zeros(size(mask));
        compo(CC.PixelIdxList{i})=1;
        props = regionprops(compo,'centroid','EquivDiameter');
        center = round(props.Centroid); 
        dia = round(props.EquivDiameter/20);
        %creating mask to search for the seed inside
        M = ones(orig_size);
        r_range = (center(2)-dia):(center(2)+dia);
         r_range(r_range < 1)=1;
        r_range(r_range > orig_size(1)) = orig_size(1);
        
        c_range = (center(1)-dia):(center(1)+dia);
        c_range(c_range < 1) = 1;
        c_range(c_range > orig_size(2)) = orig_size(2);
        
        M (r_range, c_range) = 0;
        M = mat2gray(orig) + M;
        % taking minimum val to guarentee a 'good' seed
        [val,ind] = min(M(:));
        [r,c] = ind2sub(size(M),ind);

        seg = (RegionGrowing(mat2gray(orig),RG_pram,[r,c]));
        seg = imfill(seg,'holes');
        SEG = SEG + seg;
        
       % imshow(SEG)%%%
    end

end

