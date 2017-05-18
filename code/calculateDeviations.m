function deviations = calculateDeviations(realIndexes, detectedIndexes)
    % First we create a difference matrix where columns represent each
    % real index and rows represent each detected index.
    n = size(detectedIndexes, 2);
    m = size(realIndexes, 2);
    differenceMatrix = zeros(n, m);
    
    for i = 1:n
        for j = 1:m
            differenceMatrix(i, j) = detectedIndexes(i) - realIndexes(j);
        end
    end
    
    % Now, during min(n, m) iterations, we:
    %   - Find the minimum absolute value of the matrix, that is placed in row r and column c.
    %   - This minimum value is a match between a real and a detected gesture, and the cell is the deviation in frames between them.
    %   - We remove the row r and column c from the difference matrix.
    deviations = zeros(1, m);
    
    for i = 1:min(n, m)
        [~, minIndex] = min(abs(differenceMatrix(:)));
        deviations(i) = differenceMatrix(minIndex);
        [r, c] = find(differenceMatrix == deviations(i));
        differenceMatrix(r(1), :) = [];
        differenceMatrix(:, c(1)) = [];
    end
end

