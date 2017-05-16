function samples = getSamples(gesture)
    samples = {};
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
                        samples{end + 1, 1} = sequence;
                    end
                    
                    last = i;
                end
            end
        end
    end
end

