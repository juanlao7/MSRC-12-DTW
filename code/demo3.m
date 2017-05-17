% Demo 3: trains and tests the model using cross-validation.
% Requires a prior configuration. At the end of the execution the variable "result" contains the F-score of each gesture.

clear;

% CONFIGURATION
config.trainingParts = 3;               % Parts of the dataset destinated to training.
config.testingParts = 1;                % Parts of the dataset destinated to testing.
config.modelIndex = 1;                  % Sample of the training dataset to be used as a model.
config.mode = 'offline';                % (online|offline), the detection mode. Offline is more precise, but in a real-time scenario we should use online, because it has no lag.

% DO NOT MODIFY AFTER THIS LINE
result = autotest(config);
disp(result);
