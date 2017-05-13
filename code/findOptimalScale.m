% Little script to find the most invariant scale between joins.
clear;

tic

data = [];
files = dir('../data/*.csv');

for file = files'
    [~, name, ~] = fileparts(file.name);
    [X, ~, ~] = load_file(name);
    data = [data; X];
    break
end

bestJointA = NaN;
bestJointB = NaN;
lowestStdevDistance = inf;

for jointA = 1:19
    jointAIndex = getJointIndex(jointA);
    
    for jointB = jointA + 1:20
        jointBIndex = getJointIndex(jointB);
        distance = zeros(size(data, 1), 1);
        
        for i = 1:size(data, 1)
            distance(i) = sqeuclidean(data(i, jointAIndex:jointAIndex + 3), data(i, jointBIndex:jointBIndex + 3));
        end
        
        stdevDistance = std(distance);

        if stdevDistance < lowestStdevDistance
            bestJointA = jointA;
            bestJointB = jointB;
            lowestStdevDistance = stdevDistance;
        end
    end
end

disp(['Best joint A: ' num2str(bestJointA)]);
disp(['Best joint B: ' num2str(bestJointB)]);
disp(['Lowest stdev distance: ' num2str(lowestStdevDistance)]);
toc
