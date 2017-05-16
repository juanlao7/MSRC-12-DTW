function [realGestures, detectedGestures, errorMap, backtrackingMap, realGesturePositions] = test(model, X, Y, onlyValleys, ramifications)
    realGesturePositions = Y(:, model.gesture)';
    realGestures = sum(realGesturePositions) - 1;

    errorMap = dtw(model.sequence, X, 'find', model.weights);
    
    if onlyValleys
        [~, candidates] = find_peaks(errorMap(end, :) * -1);
    else
        candidates = 2:size(errorMap, 2);
    end
    
    if strcmp(ramifications, 'last') == 1
        candidates = fliplr(candidates);
    end
    
    backtrackingMap = zeros(size(errorMap));
    n = size(errorMap, 1);
    
    for candidate = candidates
        if errorMap(end, candidate) > model.maxErrorThreshold
            continue;
        end
        
        buffer = zeros(size(errorMap));
        
        i = n;
        j = candidate;
        insertions = 0;
        buffer(i, j) = 1;
        
        while i > 1
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
            
            if chosenJ == candidate && n - i >= model.lastInsertionThreshold    % COMPROBAR ESTA CONDICION
                break;
            end
            
            if chosenJ == j
                insertions = insertions + 1;
                
                if insertions > model.maxInsertions
                    break;
                end
            end
            
            i = chosenI;
            j = chosenJ;
            
            if strcmp(ramifications, 'all') == 0 && backtrackingMap(chosenI, chosenJ) == 1
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
