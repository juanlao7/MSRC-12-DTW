function normalizedFrame = normalizeFrame(frame)
    % Centering on the hip center
    normalizedFrame = frame - repmat(frame(1:4), 1, 20);
    
    % Scaling the skeleton forcing the distance between joint 1 and 2 to be
    % a constant number (0.005, to be able to animate it in a small
    % window).
    
    jointAIndex = getJointIndex(1);
    jointBIndex = getJointIndex(2);
    distance = sqeuclidean(frame(jointAIndex:jointAIndex + 3), frame(jointBIndex:jointBIndex + 3));
    
    normalizedFrame = normalizedFrame * 0.005 / distance;
end
