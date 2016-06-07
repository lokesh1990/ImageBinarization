function [ stokeVal ] = CalcStrokeWidth( input_image )
% This function finds the estimated stroke width M of text in the input
% image (constrast image, text = 1 and bg = 0)

% image size
[im_h, im_w] = size(input_image);

%% Stroke width detection %%

%# Create the average filter with hsize = 3
F_avg = fspecial('average', 3);
%# Filter it
I_avg = imfilter(input_image, F_avg);

%# Create the gaussian filter with hsize = [5 5] and sigma = 1
F_gaussian = fspecial('gaussian',[5 5], 1);
%# Filter it
I_g = imfilter(I_avg, F_gaussian, 'same');

%# Otsu's global thresholding
level = graythresh(I_g);
BW = im2bw(I_g, level);

%# Compute stroke width w
count = cell(im_w, 1);

for l = 1:im_w
    count{l} = 0;
end

for i = 1:im_h
    
    l = 1;
    len = 0;
    while(l <= im_w)
        if(BW(i, l) == 0)            
            if(len ~= 0)
                count{len} = count{len} + 1;
            end
            
            l = l + 1;        
            len = 0;            
            
        elseif(BW(i, l) == 1)
            len = len + 1;
            l = l + 1;
        end
    end
end

wSum = 0;
aSum = 0;
for l = 1:im_w
    wSum = wSum + (count{l} * l);
    aSum = aSum + count{l};
end

% stroke width M
stokeVal = floor(wSum / aSum);

end

