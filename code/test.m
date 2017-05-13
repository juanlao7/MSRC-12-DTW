function [realGestures, detectedGestures, errorMap, errorMapWithBacktracking] = test(model, X, Y)
    realGestures = sum(Y(:, model.gesture));
    errorMap = dtw(model.sequence, X, 'find');
    [valleys, valleyIndices] = find_peaks(errorMap(end, :) * -1);
    detectedGestures = sum(valleys <= model.threshold);
    
    errorMapWithBacktracking = errorMap;
    
    for valleyIndex = valleyIndices
        i = size(errorMap, 1);
        j = valleyIndex;
        errorMapWithBacktracking(i, j) = -inf;
        
        while i > 1
            chosenI = i;
            chosenJ = j - 1;
            
            if errorMap(i - 1, j) < errorMap(chosenI, chosenJ)
                chosenI = i - 1;
                chosenJ = j;
            end
            
            if errorMap(i - 1, j - 1) < errorMap(chosenI, chosenJ)
                chosenI = i - 1;
                chosenJ = j - 1;
            end
            
            i = chosenI;
            j = chosenJ;
            errorMapWithBacktracking(i, j) = -inf;
        end
    end
end
