% Demo 2: train and test a model for gesture detection.
% Just execute this script. It is interactive, no previous configuration is needed.

clear;

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
gesture = input('What gesture do you want to detect? (1-12): ');

tic
disp('Training...');
[model, samples] = train(gesture);
disp('Training finished!');
disp([num2str(length(samples)) ' samples found (model sequence not included).']);
disp(['Optimal DTW threshold to avoid false negatives: ' num2str(model.threshold)]);
toc
disp(' ');

if strcmpi(input('Do you want to visualize the model sequence? (Y/N) [N]: ', 's'), 'y') == 1
    animate(model.sequence);
end

disp(' ');
disp('You can visualize the samples. They are sorted in ascending order by the error obtained');
disp('after comparing them against the choosen model sequence with DTW.');
disp(' ');

while true
    sampleIndex = input(['Type the number of the sample you want to visualize, or 0 to cancel (0-' num2str(length(samples)) '): ']);
    
    if sampleIndex == 0
        break;
    end
    
    disp(['This sample got an error of ' num2str(samples{sampleIndex, 2})]);
    animate(samples{sampleIndex, 1});
    disp('Visualization finished.');
    disp(' ');
end

disp('Now the model can be tested against files that contain several gestures.');
disp(' ');

while true
    file = input('What file do you want to test? [P1_1_1_p06]: ', 's');
    
    if isempty(file)
        file = 'P1_1_1_p06';
    end
    
    [X, Y, ~] = load_file(file);
    [realGestures, detectedGestures, errorMap, backtrackingMap, realGesturesSequence] = test(model, X, Y, true, 'all');
    disp(['File ' file ' contains ' num2str(realGestures) ' gestures of type ' num2str(gesture)]);
    disp(['Our model detects ' num2str(detectedGestures) ' gestures of type ' num2str(gesture) ' in file ' file]);
    plotTestResult(errorMap, backtrackingMap, realGesturesSequence);
    
    if strcmpi(input('Do you want to continue testing another file? (Y/N) [N]: ', 's'), 'y') ~= 1
        break;
    end
    
    disp(' ');
end
