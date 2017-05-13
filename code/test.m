function [realGestures, detectedGestures, errorMap, backtrackingMap, realGesturesSequence] = test(model, X, Y, onlyValleys, ramifications)
    realGesturesSequence = Y(:, model.gesture)';
    realGestures = sum(realGesturesSequence);

    errorMap = dtw(model.sequence, X, 'find');
    
    if onlyValleys
        [~, candidates] = find_peaks(errorMap(end, :) * -1);
    else
        candidates = 2:size(errorMap, 2);
    end
    
    backtrackingMap = zeros(size(errorMap));
    n = size(errorMap, 1);
    
    for candidate = candidates
        if errorMap(end, candidate) > model.errorThreshold
            continue;
        end
        
        buffer = zeros(size(errorMap));
        
        i = n;
        j = candidate;
        buffer(i, j) = 1;
        
        while i > 1 && j > 1
            chosenI = i;
            chosenJ = j - 1;
            
            if errorMap(i - 1, j) <= errorMap(chosenI, chosenJ)
                chosenI = i - 1;
                chosenJ = j;
            end
            
            if errorMap(i - 1, j - 1) <= errorMap(chosenI, chosenJ)
                chosenI = i - 1;
                chosenJ = j - 1;
            end
            
            i = chosenI;
            j = chosenJ;
            
            if j == candidate && n - i >= model.lastInsertionThreshold
                break;
            end
            
            if strcmp(ramifications, 'first') == 1 && backtrackingMap(chosenI, chosenJ) == 1
                break;
            end
            
            buffer(i, j) = 1;
        end
        
        if i == 1
            backtrackingMap = backtrackingMap + buffer;
        end
    end
    
    detectedGestures = sum(backtrackingMap(end, 2:end) == 1);
end
