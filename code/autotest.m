function result = autotest(config)
    resultsF1 = table(0, 0, 0, 0);
    resultsF1.Properties.VariableNames = {'GestureType', 'Precision', 'Recall', 'FScore'};
    resultsF1(1, :) = [];      % Deleting the dummy row

    [trainingFiles, testingFiles] = getFiles(config.trainingParts, config.testingParts);
    
    if strcmp(config.mode, 'online')
        config.mode = 'first';
    elseif strcmp(config.mode, 'offline')
        config.mode = 'last';
    else
        config.mode = 'all';
    end

    for gesture = 1:12
        disp(['### Gesture ' num2str(gesture) ' ###']);
        
        tic
        disp('Training...');
        samples = getSamples(trainingFiles, gesture);
        [model, ~] = train(gesture, samples, config.modelIndex);
        disp('Training finished.');
        toc
        
        tic
        disp('Testing...');
        
        truePositives = 0;
        falsePositives = 0;
        falseNegatives = 0;
        
        for testFile = testingFiles'
            disp(['    File ' testFile{1}]);
            [X, Y, ~] = load_file(testFile{1});
            
            if isempty(X)
                disp('        This file is empty!');
                continue;
            end
            
            [X, Y] = sanitizeFile(X, Y);
            
            [realGestures, detectedGestures, ~, ~, ~] = test(model, X, Y, true, config.mode);
            disp(['        ' num2str(realGestures) ' real gestures']);
            disp(['        ' num2str(detectedGestures) ' detected gestures']);
            
            truePositives = truePositives + min(realGestures, detectedGestures);
            falsePositives = falsePositives + max(0, detectedGestures - realGestures);
            falseNegatives = falseNegatives + max(0, realGestures - detectedGestures);
        end
        
        disp('Testing finished.');
        
        disp(['    True positives: ' num2str(truePositives)]);
        disp(['    False positives: ' num2str(falsePositives)]);
        disp(['    False negatives: ' num2str(falseNegatives)]);
        
        toc
        
        precision = truePositives / (truePositives + falsePositives);
        recall = truePositives / (truePositives + falseNegatives);
        fscore = 2 * precision * recall / (precision + recall);
        
        disp(['Precision: ' num2str(precision)]);
        disp(['Recall: ' num2str(recall)]);
        disp(['F-Score: ' num2str(fscore)]);
        
        resultsF1(end + 1, :) = {gesture, precision, recall, fscore};
    end
end

