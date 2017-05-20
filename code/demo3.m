% Demo 3: trains and tests the model using cross-validation.
% Requires a prior configuration. At the end of the execution variables "onlineResults" and "offlineResults" contain the test results.

clear;

% CONFIGURATION
config.trainingParts = 3;               % Parts of the dataset destinated to training.
config.testingParts = 1;                % Parts of the dataset destinated to testing.
config.modelIndex = 1;                  % Sample of the training dataset to be used as a model.

% DO NOT MODIFY AFTER THIS LINE
config.mode = 'online';
onlineResults = autotest(config);

config.mode = 'offline';
offlineResults = autotest(config);

disp('Finished!');
