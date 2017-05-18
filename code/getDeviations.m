function [beginningDeviations, endingDeviations] = getDeviations(backtrackingMap, realGesturePositions)
    realIndexes = find(realGesturePositions);
    
    beginnings = realIndexes(1:end - 1);
    detectedBeginnings = find(backtrackingMap(1, :)) - 1;
    beginningDeviations = calculateDeviations(beginnings, detectedBeginnings);
    
    endings = realIndexes(2:end);
    detectedEndings = find(backtrackingMap(end, :)) - 1;
    endingDeviations = calculateDeviations(endings, detectedEndings);
end

