function result = autotest(config)
    results = table(0, 0, 0, 0, 0, 0, 0, 0);
    results.Properties.VariableNames = {'GestureType', 'Precision', 'Recall', 'FScore', 'BeginningMD', 'BeginningMAD', 'EndingMD', 'EndingMAD'};
    results(1, :) = [];      % Deleting the dummy row

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
        
        beginningDeviations = [];
        endingDeviations = [];
        
        for testFile = testingFiles'
            disp(['    File ' testFile{1}]);
            [X, Y, ~] = load_file(testFile{1});
            
            if isempty(X)
                disp('        This file is empty!');
                continue;
            end
            
            [X, Y] = sanitizeFile(X, Y);
            
            [realGestures, detectedGestures, ~, backtrackingMap, realGesturePositions] = test(model, X, Y, true, config.mode);
            [currentBeginningDeviations, currentEndingDeviations] = getDeviations(backtrackingMap, realGesturePositions);
            beginningDeviations = [beginningDeviations currentBeginningDeviations];
            endingDeviations = [endingDeviations currentEndingDeviations];
            
            disp(['        ' num2str(realGestures) ' real gestures']);
            disp(['        ' num2str(detectedGestures) ' detected gestures']);
            
            truePositives = truePositives + min(realGestures, detectedGestures);
            falsePositives = falsePositives + max(0, detectedGestures - realGestures);
            falseNegatives = falseNegatives + max(0, realGestures - detectedGestures);
        end
        
        disp('Testing finished.');
        
        toc
        
        precision = truePositives / (truePositives + falsePositives);
        recall = truePositives / (truePositives + falseNegatives);
        fscore = 2 * precision * recall / (precision + recall);
        
        beginningMD = mean(beginningDeviations);
        beginningMAD = mean(abs(beginningDeviations));
        endingMD = mean(endingDeviations);
        endingMAD = mean(abs(endingDeviations));
        
        disp(['True positives: ' num2str(truePositives)]);
        disp(['False positives: ' num2str(falsePositives)]);
        disp(['False negatives: ' num2str(falseNegatives)]);
        
        disp(['Precision: ' num2str(precision)]);
        disp(['Recall: ' num2str(recall)]);
        disp(['F-Score: ' num2str(fscore)]);
        
        disp(['Beginning MD: ' num2str(beginningMD)]);
        disp(['Beginning MAD: ' num2str(beginningMAD)]);
        disp(['Ending MD: ' num2str(endingMD)]);
        disp(['Ending MAD: ' num2str(endingMAD)]);
        
        results(end + 1, :) = {gesture, precision, recall, fscore, beginningMD, beginningMAD, endingMD, endingMAD};
    end
end

