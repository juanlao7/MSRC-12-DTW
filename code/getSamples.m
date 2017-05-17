function samples = getSamples(files, gesture)
    samples = {};
    
    for file = files'
        % We load only the files of the desired gesture.
        if regexp(file{1}, ['P._._' num2str(gesture) 'A?_p.*']) == 1
            [X, Y, ~] = load_file(file{1});
            last = 1;

            for i = 2:length(X)
                if Y(i, gesture) == 1
                    if last ~= 1            % We discard the first label of the file, we consider it incorrect
                        sequence = X(last:i, :);
                        samples{end + 1, 1} = sequence;
                    end
                    
                    last = i;
                end
            end
        end
    end
end

