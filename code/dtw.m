function E = dtw(modelSequence, testSequence, mode, weights)
    % Initializing the matrix
    rows = size(modelSequence, 1) + 1;
    cols = size(testSequence, 1) + 1;
    E = zeros(rows, cols);
    E(:, 1) = inf;
    
    if strcmp(mode, 'match') == 1
        E(1, :) = inf;
        E(1, 1) = 0;
    elseif strcmp(mode, 'find') == 1
        E(1, :) = 0;
    end

    % Filling the matrix

    for i = 2:rows
        for j = 2:cols
            cost = sum(compareFrames(modelSequence(i - 1, :), testSequence(j - 1, :), weights));
            E(i, j) = cost + min([E(i - 1, j), E(i, j - 1), E(i - 1, j - 1)]);     % With potential. Generates too many positives before arriving to the target.
            %E(i, j) = E(i - 1, j - 1) + cost;       % Pretty good. Almost always generates just 1 positive per gesture. The only problem is that the detected ending of the gesture is a bit displaced to the right respecting the real.
            %E(i, j) = min([E(i - 1, j), E(i, j - 1), E(i - 1, j - 1) + cost]);      % It does not work. Everything is a positive.
            %E(i, j) = min([E(i - 1, j) + cost * 2, E(i, j - 1) + cost * 2, E(i - 1, j - 1) + cost]);        % Pretty good too. An intermediate between 1 and 2
            %E(i, j) = cost + min([E(i, j - 1), E(i - 1, j - 1)]);       % Nice try, but we have the same problem as 2
            %E(i, j) = min([E(i - 1, j) + cost * 3, E(i, j - 1) + cost, E(i - 1, j - 1) + cost]);      % It does not work. Everything is a positive.
            %E(i, j) = min([E(i - 1, j) + cost / i, E(i, j - 1) + cost, E(i - 1, j - 1) + cost]);      % There is no way of making this work.
        end
    end
end

