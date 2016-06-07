% test image used in current case is H04.bmp
% read the grayscale image
im = imread('H04.bmp');
im = im(:, :, 1);
% do pre-processing on the image
im2 = contrastEstimate(im);
% apply double threshold binarization to obtain binary image
im3 = doubleThresholdBinarization(im2, im);
% apply post prcessing steps to remove noise in image
% strategy1: removing salt and pepper noise
im4 = applyShrinkSwellFilter(im3);
% strategy2: removing block noise
im5 = graphBuild(im4, im2);

% write the images to file
imwrite(im2, 'contrastEstimatedImage.jpg');
imwrite(im3, 'doubleThresholdedImage.jpg');
imwrite(im4, 'saltAndPprRemovedImage.jpg');
imwrite(im5, 'blockNoiseRemovedImage.jpg');
