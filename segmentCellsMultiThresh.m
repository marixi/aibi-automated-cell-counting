% This function tries to segment the cells using multithresholding of the
% grayscale and removing the grid of the image.
function [centers, radii] = segmentCellsMultiThresh(input)

if(input == null)
    input = im2double(imread('train-images\train_images\20151115_172901.tiff'));
end

ROI = getROI(input, 3);

gray = rgb2gray(ROI);
gray = medfilt2(gray);

% Upon testing three levels of thresholding was found to be appropriate
thresh = multithresh(gray,3);
tsize = size(thresh);

% Used the 2 thresholds that were relevant, one that separated the grid and
% cells, and onde with the cells and the grid.
gray_lines = imbinarize(gray, thresh(3));
gray_cells = imbinarize(gray, thresh(2));

% Subctracted the grid to the cells and binarized the image.
gray_cells = gray_cells - gray_lines;
gray_cells = medfilt2(gray_cells);
gray_cells = imbinarize(gray_cells);
figure, imshow(gray_cells);

% Removed the remains of the lines subtracted
SE = strel('disk', 2);
gray_cells_open = imopen(gray_cells, SE);
figure, imshow(gray_cells_open);

[centers, radii] = imfindcircles (gray_cells_open, [11 70],'ObjectPolarity','dark', 'Sensitivity', 0.85, 'EdgeThreshold', 0.5);
viscircles(centers, radii, 'Color', 'b');

end