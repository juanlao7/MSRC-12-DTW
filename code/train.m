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
                        % TODO: normalize
                        
                        if isnan(modelSequence)
                            modelSequence = sequence;   % We choose the first sequence as model
                        else
                            nSamples = nSamples + 1;
                            samples{nSamples, 1} = sequence;
                            samples{nSamples, 2} = dtw(modelSequence, sequence, 'match');
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
    model = struct('sequence', modelSequence, 'threshold', threshold);
end

