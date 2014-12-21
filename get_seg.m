function [seg] = get_seg( prev_mask , mask)


    filled = imfill(mask,'holes');
    cc_mask = bwconncomp(filled,4);
    
    %last_area = sum(prev_mask(:));
    se = strel('disk',3);
    
    
    %throw unrelated components
    itrsct = (filled) .* prev_mask;
    itrsct = itrsct > 0;
    
    CC_itrsct = bwconncomp(itrsct,4);
    seg = zeros(size(mask));
    % restore accidently thrown parts
    for i = 1: length(CC_itrsct.PixelIdxList)
        i_seg = zeros(size(mask));
        Indexes = CC_itrsct.PixelIdxList{i};
        itrsct_area = sum(Indexes>0);
        
        %try to take the original mask componet that fits the intersection
        if numel(Indexes) < 5
            continue
        end
        compo_pos = cellfun(@(V) any(V==Indexes(5)) ,cc_mask.PixelIdxList);
        comp = zeros(size(mask)); 
        comp(cc_mask.PixelIdxList{compo_pos > 0})=1;
        comp_area = sum(comp(:));
        % verifies it dont takes a component that is not making sense
        if ~(comp_area < itrsct_area/3 || comp_area > itrsct_area * 1.5 )
            i_seg = imfill(comp,'holes');
            
        else
        % if the former method didnt worked , make a simple intersection based segmenting  
        i_itrsct = zeros(size(mask)); 
        i_itrsct(CC_itrsct.PixelIdxList{i}) = 1;
        
        thic = bwmorph(i_itrsct,'thicken',3) ;
        tmp = filled .* thic;
        %throw unwanted added components
        CC_thic = bwconncomp(tmp,4);
        numPixels = cellfun(@numel,CC_thic.PixelIdxList);   
        [M,m_idx] = max(numPixels);
        i_seg(CC_thic.PixelIdxList{m_idx}) = 1;
        %smoothen
        
        eroded = imerode(i_seg,se);
        i_seg = imdilate(eroded,se);
        
        end
        
        seg = seg + i_seg;
    
    end
% returns a segmentes slice of orig form a given mask image
%ths function uses Region Growing algo to extract the segmentation 
%     RG_pram = 0.07;
%     CC = bwconncomp(mask,4);
%     
%     SEG = zeros(size(orig));
%     orig_size = size(orig);
%  
%     %clean noise
%     for i =1:length(CC.PixelIdxList)
%         if length(CC.PixelIdxList{i}) < 20
%             continue;
%         end
%         compo = zeros(size(mask));
%         compo(CC.PixelIdxList{i})=1;
%         props = regionprops(compo,'centroid','EquivDiameter');
%         center = round(props.Centroid); 
%         dia = round(props.EquivDiameter/20);
%         %creating mask to search for the seed inside
%         M = ones(orig_size);
%         r_range = (center(2)-dia):(center(2)+dia);
%          r_range(r_range < 1)=1;
%         r_range(r_range > orig_size(1)) = orig_size(1);
%         
%         c_range = (center(1)-dia):(center(1)+dia);
%         c_range(c_range < 1) = 1;
%         c_range(c_range > orig_size(2)) = orig_size(2);
%         
%         M (r_range, c_range) = 0;
%         M = mat2gray(orig) + M;
%         % taking minimum val to guarentee a 'good' seed
%         [val,ind] = min(M(:));
%         [r,c] = ind2sub(size(M),ind);
% 
%         seg = (RegionGrowing(mat2gray(orig),RG_pram,[r,c]));
%         seg = imfill(seg,'holes');
%         SEG = SEG + seg;
%         
%        % imshow(SEG)%%%
%     end
    seg(seg>0) = 1;
    
   
end

