% Demo 2: user-interactive demo of the project. The user can train and test models.
% Just execute this script. No previous configuration is needed.

clear;

while true
    disp('Gestures:');
    disp('     1) Start Music/Raise Volume (of music)');
    disp('     2) Crouch or hide');
    disp('     3) Navigate to next menu');
    disp('     4) Put on night vision goggles');
    disp('     5) Wind up the music');
    disp('     6) Shoot a pistol');
    disp('     7) Take a Bow to end music session');
    disp('     8) Throw an object');
    disp('     9) Protest the music');
    disp('    10) Change a weapon');
    disp('    11) Move up the tempo of the song');
    disp('    12) Kick');
    disp(' ');
    gesture = input('What gesture do you want to detect? (1-12) [1]: ');
    
    if isempty(gesture)
        gesture = 1;
    end
    
    disp('Reading the dataset...');
    [trainingFiles, ~] = getFiles(1, 0);            % In this demo we do not perform a testing analysis.
    samples = getSamples(trainingFiles, gesture);
    disp([num2str(size(samples, 1)) ' samples of gesture of type ' num2str(gesture) ' found']);
    modelIndex = input(['What sample do you want to use as model? (1-' num2str(size(samples, 1)) ') [1]: ']);
    
    if isempty(modelIndex)
        modelIndex = 1;
    end

    tic
    disp('Training...');
    [model, samples] = train(gesture, samples, modelIndex);
    disp('Training finished!');
    disp(['Optimal maximum DTW error threshold: ' num2str(model.maxErrorThreshold)]);
    disp(['Optimal maximum last insertion threshold: ' num2str(model.lastInsertionThreshold)]);
    disp(['Optimal maximum number of insertions threshold: ' num2str(model.maxInsertions)]);
    toc

    while true
        disp('Actions:');
        disp('     1) Visualize the model sequence');
        disp('     2) Visualize a sample of the training set of the gesture');
        disp('     3) Test the model against a file');
        disp('     4) Go back and train another gesture');
        disp(' ');
        action = input('What do you want to do? (1-4) [3]: ');
        disp(' ');
        
        if isempty(action)
            action = 3;
        end
        
        if action == 1
            animate(model.sequence);
            continue;
        end

        if action == 2
            disp('The samples are sorted in ascending order by the error obtained');
            disp('after comparing them against the choosen model sequence with DTW.');
            disp(' ');
            sampleIndex = input(['Type the number of the sample you want to visualize (1-' num2str(size(samples, 1)) ') [1]: ']);
            
            if isempty(sampleIndex)
                sampleIndex = 1;
            end

            disp(['This sample got a DTW error of ' num2str(samples{sampleIndex, 2})]);
            disp(' ');
            animate(samples{sampleIndex, 1});

            continue;
        end

        if action == 3
            file = input('What file do you want to test? [P1_1_1_p06]: ', 's');

            if isempty(file)
                file = 'P1_1_1_p06';
            end
            
            disp(' ');
            disp('When we perform DTW, we detect several positives that come from the same root,');
            disp('but we have to choose only one as the correct positive.');
            disp('You can execute the algorithm in different modes:');
            disp('     - "online": the algorithm detects the first positive it finds,');
            disp('                 and discards the rest of the branches.');
            disp('     - "offline": the algorithm detects all the branches and returns');
            disp('                  the one it considers the best.');
            disp('     - "all": only for analysis purposes, returns all the branches.');
            disp(' ');
            mode = input('What mode do you want to use? (online|offline|all) [offline]: ', 's');
            
            if isempty(mode)
                mode = 'offline';
            end
            
            if strcmp(mode, 'online')
                mode = 'first';
            elseif strcmp(mode, 'offline')
                mode = 'last';
            else
                mode = 'all';
            end

            [X, Y, ~] = load_file(file);
            
            if isempty(X)
                disp('This file is empty!');
                continue;
            end
            
            [X, Y] = sanitizeFile(X, Y);
            
            [realGestures, detectedGestures, errorMap, backtrackingMap, realGesturePositions] = test(model, X, Y, true, mode);
            [beginningDeviations, endingDeviations] = getDeviations(backtrackingMap, realGesturePositions);
            
            disp(['File ' file ' contains ' num2str(realGestures) ' gestures of type ' num2str(gesture)]);
            disp(['Our model detects ' num2str(detectedGestures) ' gestures of type ' num2str(gesture) ' in file ' file]);
            disp('True positive detections have:');
            disp('     For the gesture beginnings:');
            disp(['          A Mean Deviation of ' num2str(mean(beginningDeviations)) ' frames']);
            disp(['          A Mean Absolute Deviation of ' num2str(mean(abs(beginningDeviations))) ' frames']);
            disp('     For the gesture endings:');
            disp(['          A Mean Deviation of ' num2str(mean(endingDeviations)) ' frames']);
            disp(['          A Mean Absolute Deviation of ' num2str(mean(abs(endingDeviations))) ' frames']);
            disp(' ');
            plotTestResult(errorMap, backtrackingMap, realGesturePositions);
            
            while true
                disp('Actions:');
                disp('     1) Visualize a real sample of the file');
                disp('     2) Visualize a detection');
                disp('     3) Visualize the entire file');
                disp('     4) Go back');
                disp(' ');
                action = input('What do you want to do? (1-4) [4]: ');
                disp(' ');
                
                if action == 1
                    index = input(['From left to right, what sample do you want to visualize? (1-' num2str(realGestures) ') [1]: ']);
                    
                    if isempty(index)
                        index = 1;
                    end
                    
                    points = find(realGesturePositions);
                    animate(X(points(index):points(index + 1), :));
                    continue;
                end
                
                if action == 2
                    index = input(['From left to right, what detection do you want to visualize? (1-' num2str(detectedGestures) ') [1]: ']);
                    
                    if isempty(index)
                        index = 1;
                    end
                    
                    backtrackingStartingPoints = find(backtrackingMap(1, :));
                    startPoint = backtrackingStartingPoints(index);
                    
                    backtrackingEndingPoints = find(backtrackingMap(end, :));
                    endPoint = backtrackingEndingPoints(index);
                    
                    animate(X(startPoint:endPoint, :));
                    continue;
                end
                
                if action == 3
                    animate(X);
                    continue;
                end
                
                break;
            end
            
            continue;
        end

        if action == 4
            break;
        end
    end
end
