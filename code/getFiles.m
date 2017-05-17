function [trainingFiles, testingFiles] = getFiles(trainingParts, testingParts)
    trainingFiles = {};
    testingFiles = {};
    files = dir('../data/*.csv');
    i = 0;

    for file = files'
        [~, name, ~] = fileparts(file.name);
        
        if mod(i, trainingParts + testingParts) + 1 <= trainingParts
            trainingFiles{end + 1, 1} = name;
        else
            testingFiles{end + 1, 1} = name;
        end
        
        i = i + 1;
    end
end

