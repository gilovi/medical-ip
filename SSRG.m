function [segmentation] = SSRG(input_FileName, coarse_seg, organ_type, output_fileName)
    %SSRG segments parts in the breathing system using coarse_seg
    
    %take the last segmented cut, and finds the intersection of it with the
    %next. the result  will used for creating seed to reigion grow for the next
    %slice ans so on.
    
%inputs,
%   input_FileName : the file to segment
%   coarse_seg : the coarse segmentation
%   organ_type : the organ to segment 1 for left lung 2 for right and 3 for
%   output_fileName : the name of the outputed segmented organ

    if isstruct(input_FileName)
        mat = input_FileName;
    else
        mat = load_untouch_nii_gzip(input_FileName);
    end
    %%
    orig_im = mat.img;
    dim = size(orig_im);
    
    h = 1 : dim(3);
    cut_size = arrayfun(@(x) nnz(coarse_seg(:,:,x)) ,h);
 %%     
    % dealing with lungs
    if organ_type < 3 
% finding largest cut
  %%      
        [M,ind]= max(cut_size);
        seg_slice = coarse_seg(:,:,ind);
        orig_slice = orig_im(:,:,ind);
        
        [left, right] = lungs_clean_sep(seg_slice);
        
        %fix lung merge problems (serches a place the lungs are separated)
        while(sum(left(:)) < 2000)
            ind = ind + 1 ;
            seg_slice = coarse_seg(:,:,ind); 
            [left, right] = lungs_clean_sep(seg_slice);
        end
%%      
       if organ_type == 1 
            mask = left;
        else
            mask = right;
       end
       
   
    end
    
    if organ_type == 3
%  
        [M,ind]= min(cut_size);
        seg_slice = coarse_seg(:,:,ind);
        
        
        %TODO 
        mask = seg_slice;
        
    end
    
 %%
 % first slice
    SEG = zeros(size(orig_im));
    mask = imfill(mask,'holes');
    SEG(:,:,ind) = mask;
    
    
%    the rest slices
%%    
    disp ('going up') %TODO
    for i = ind+1:dim(3)
%%      
        mask = coarse_seg(:,:,i);
        if ~any(mask(:))
            break
        end
        seg = get_seg( SEG(:,:,i-1), mask);
        %if added a component ,discard it.
        if organ_type <3 
            CC_seg = bwconncomp(seg,4);
            if length(CC_seg.PixelIdxList) > 1
                numPixels = cellfun(@numel,CC_seg.PixelIdxList);  
                [M,m_idx] = max(numPixels);
                seg=zeros(size(mask));
                seg(CC_seg.PixelIdxList{m_idx}) = 1;
            end
        end
        
        SEG(:,:,i) = seg;
       
    end
    disp ('going down') %TODO
    for i = ind-1:-1:1
        mask = coarse_seg(:,:,i);
        if ~any(mask(:))
            break
        end
        seg = get_seg(SEG(:,:,i+1), mask);
        if organ_type ==3
            CC_seg = bwconncomp(seg,4);
            if length(CC_seg.PixelIdxList) > 1
                break
            end
        end
        SEG(:,:,i) = seg;
        
    end
   
    mat.img=SEG;
    %save_untouch_nii(mat , output_fileName); TODO
    segmentation = SEG;%TODO remove

end
%RegionGrowing(dImg, 0.07, [c r])
%'wline = 0.005 ,term = 0.5 ,sigma 2 = 8 ,Mu = 0, Alpha=0.05')
%'wline = 0.005 ,term = 0.5 ,sigma 2 = 8 ,Mu = 0, Alpha=0.05 ,Beta =0.01 , kappa=17, Delta = -0.5'
%'wline = 0.005 ,term = 0.5 ,sigma 2 = 8 ,Mu = 0, Alpha=0.05 ,Beta =0 , kappa=4, Delta = -0.1')
%'wline = 0 ,term = 0.5 ,sigma 2 = 8 ,Mu = 0, Alpha=0.05 ,Beta =0.01 , kappa=4, Delta = -0.1')
%'wline = 0 ,term = 0.5 , sigma1 =4 sigma 2 = 5 ,Mu = 0, Alpha=0.05 ,Beta =0.01 , kappa=4, Delta = -0.1')