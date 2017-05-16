function weights = calculateWeights(sequence)
    d = zeros(1, 80);
    unitaryWeights = ones(1, 80);
    
    for i = 2:size(sequence, 1)
        d = d + compareFrames(sequence(i - 1, :), sequence(i, :), unitaryWeights);
    end
    
    %weights = ones(1, 80) - d / max(d);
    weights = d / max(d);
end

