function [model, samples] = train(gesture)
    % Loading and extracting all the sequences of the given gesture
    samples = {};
    nSamples = 0;
    modelSequence = NaN;
    files = dir('../data/*.csv');

    for file = files'
        [~, name, ~] = fileparts(file.name);

        % We load only the files for the desired gesture.
        if regexp(name, ['P._._' num2str(gesture) 'A?_p.*']) == 1
            [X, Y, ~] = load_file(name);
            last = 1;

            for i = 2:length(X)
                if Y(i, gesture) == 1
                    if last ~= 1            % We discard the first gesture of the file
                        sequence = X(last:i, :);
                        
                        if isnan(modelSequence)
                            modelSequence = sequence;   % We choose the first sequence as model
                        else
                            errorMap = dtw(modelSequence, sequence, 'match');
                            nSamples = nSamples + 1;
                            samples{nSamples, 1} = sequence;
                            %samples{nSamples, 2} = min(errorMap(end, round(19/20 * end):end));
                            samples{nSamples, 2} = errorMap(end, end);
                            samples{nSamples, 3} = errorMap;
                            samples{nSamples, 4} = 0;           % Insertions
                            
                            [r, c] = size(errorMap);
                            
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
                                    samples{nSamples, 4} = samples{nSamples, 4} + 1;
                                end

                                r = chosenR;
                                c = chosenC;
                            end
                        end
                    end
                    
                    last = i;
                end
            end
        end
    end
    
    % Sorting the samples by error (for future analysis).
    [~, idx] = sort([samples{:, 2}], 'ascend');
    samples = samples(idx, :);
    
    % Calculating thresholds.
    %maxErrorThreshold = samples{end, 2};
    maxErrorThreshold = mean([samples{:,2}]) + 3 * std([samples{:,2}]);
    %maxInsertions = max([samples{:, 4}]);
    maxInsertions = mean([samples{:, 4}]) + 3 * std([samples{:, 4}]);
    
    lastInsertionThreshold = 0;
    n = size(modelSequence, 1);
    
    for i = 1:size(samples, 1)
        errorMap = samples{i, 3};
        currentLastInsertion = 1;
        
        while currentLastInsertion < n
            if errorMap(n - currentLastInsertion, end - 1) <= errorMap(n - currentLastInsertion, end)
                break;
            end
            
            currentLastInsertion = currentLastInsertion + 1;
        end
        
        if currentLastInsertion > lastInsertionThreshold
            lastInsertionThreshold = currentLastInsertion;
        end
    end
    
    % Generating the model.
    model = struct('sequence', modelSequence, 'maxErrorThreshold', maxErrorThreshold, 'maxInsertions', maxInsertions, 'lastInsertionThreshold', lastInsertionThreshold, 'gesture', gesture);
end

