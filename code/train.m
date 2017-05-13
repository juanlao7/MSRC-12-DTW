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
                            samples{nSamples, 2} = errorMap(end, end);
                            
                            if false
                                model = struct('sequence', modelSequence, 'threshold', errorMap(end, end), 'gesture', gesture);
                                [realGestures, detectedGestures, errorMap, backtrackingMap, realGesturesSequence] = test(model, sequence, Y(last:i,:), true, 'all');
                                plotTestResult(errorMap, backtrackingMap, realGesturesSequence);
                                pause();
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
    threshold = samples{end, 2};
    
    % Generating the model.
    model = struct('sequence', modelSequence, 'threshold', threshold, 'gesture', gesture);
end

