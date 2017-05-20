function [model, trainingSet] = train(gesture, samples, modelIndex)
    % Selecting the model sequence.
    modelSequence = samples{modelIndex, 1};
    samples(modelIndex, :) = [];        % Deleting the model from the samples.
    
    % Calculating the weights for the cost function.
    %weights = ones(1, 80);
    weights = calculateWeights(modelSequence);
    
    % Comparing the model with all the samples.
    lastInsertionThreshold = 0;
    
    for i = 1:size(samples, 1)
        errorMap = dtw(modelSequence, samples{i, 1}, 'match', weights);
        samples{i, 2} = errorMap(end, end);
        samples{i, 3} = errorMap;
        samples{i, 4} = 0;           % Insertions

        [r, c] = size(errorMap);
        lastColumn = c;
        currentLastInsertion = 0;

        while r > 1 && c > 1
            chosenR = r;
            chosenC = c - 1;

            if errorMap(r - 1, c) <= errorMap(chosenR, chosenC)
                chosenR = r - 1;
                chosenC = c;
            end

            if errorMap(r - 1, c - 1) <= errorMap(chosenR, chosenC)
                chosenR = r - 1;
                chosenC = c - 1;
            end

            if chosenC == c
                if c == lastColumn
                    currentLastInsertion = currentLastInsertion + 1;
                end
                
                samples{i, 4} = samples{i, 4} + 1;
            end

            r = chosenR;
            c = chosenC;
        end
        
        if currentLastInsertion > lastInsertionThreshold
            lastInsertionThreshold = currentLastInsertion;
        end
    end
    
    % Sorting the samples by error (for future analysis).
    [~, idx] = sort([samples{:, 2}], 'ascend');
    samples = samples(idx, :);
    
    % Calculating other thresholds.
    %maxErrorThreshold = samples{end, 2};
    maxErrorThreshold = mean([samples{:,2}]) + 2 * std([samples{:,2}]);         % Removing outliers
    %maxInsertions = max([samples{:, 4}]);
    maxInsertions = mean([samples{:, 4}]) + 2 * std([samples{:, 4}]);           % Removing outliers
    
    % Generating the model.
    model = struct('sequence', modelSequence, 'weights', weights, 'maxErrorThreshold', maxErrorThreshold, 'maxInsertions', maxInsertions, 'lastInsertionThreshold', lastInsertionThreshold, 'gesture', gesture);
    trainingSet = samples;
end

