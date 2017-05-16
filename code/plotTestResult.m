function plotTestResult(errorMap, backtrackingMap, realGesturePositions)
    errorMap(find(errorMap == inf)) = 1;
    errorImg = mat2gray(errorMap);
    rgbImage = cat(3, errorImg, errorImg, errorImg);
    
    redChannel = rgbImage(:, :, 1);
    greenChannel = rgbImage(:, :, 2);
    blueChannel = rgbImage(:, :, 3);
    
    redChannel(find(backtrackingMap)) = 1;
    greenChannel(:, find(realGesturePositions)) = 1;
    
    rgbImage = cat(3, redChannel, greenChannel, blueChannel);
    imshow(rgbImage);
end
