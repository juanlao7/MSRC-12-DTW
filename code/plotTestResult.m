function plotTestResult(errorMap, backtrackingMap, realGesturePositions)
    errorMap(find(errorMap == inf)) = 0;
    errorImg = mat2gray(errorMap);
    
    redChannel = errorImg;
    greenChannel = errorImg;
    blueChannel = errorImg;
    
    redChannel(find(backtrackingMap)) = 1;
    greenChannel(:, find([0 realGesturePositions])) = 1;
    
    rgbImage = cat(3, redChannel, greenChannel, blueChannel);
    imshow(rgbImage);
end

