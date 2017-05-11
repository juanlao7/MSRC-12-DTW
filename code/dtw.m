function result = dtw(modelSequence, testSequence, mode)
    % Initializing the matrix
    rows = size(modelSequence, 1) + 1;
    cols = size(testSequence, 1) + 1;
    E = zeros(rows, cols);
    
    if strcmp(mode, 'match') == 1
        E(:, 1) = inf;
        E(1, :) = inf;
        E(1, 1) = 0;
    elseif strcmp(mode, 'find') == 1
        % We initialize the first cell of each row with +inf
        E(:, 1) = inf;

        % And the first cell of each column with 0
        E(1, :) = 0;
    end

    % Filling the matrix

    for i = 2:rows
        for j = 2:cols
            cost = difference(modelSequence(i - 1, :), testSequence(j - 1, :));
            E(i, j) = cost + min([E(i - 1, j), E(i, j - 1), E(i - 1, j - 1)]);
        end
    end

    % Finding the error
    result = NaN;
    
    if strcmp(mode, 'match') == 1
        result = E(end,end);
    elseif strcmp(mode, 'find') == 1
        % TODO: buscar minimos
    end
end

