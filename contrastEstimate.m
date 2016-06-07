function [ outImg ] = contrastEstimate( ipImg )
% This function is used to estimate the contrast of a given gray scale
% image
% It takes a grayscale image as input and does contrast estimation on it
% The output of this function is a contrast image

% contrast stretching 
currMinGrayVal = min(min(ipImg));
currMaxGrayVal = max(max(ipImg));
mulFac = 255/(currMaxGrayVal - currMinGrayVal);
% The negative image is taken for better projection of text area
cVal = 255 - mulFac * currMaxGrayVal;
imgContrstStrtch = ipImg * mulFac + cVal;

% morphological closing
se = strel('square', 7);
imgBground = imerode(imdilate(imgContrstStrtch, se), se);

% subtract original image from background image
outImg = imgBground - ipImg;

end

