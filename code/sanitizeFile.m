function [X, Y] = sanitizeFile(fileX, fileY)
    % Deleting the beginning and the end of the file, since it is not well labeled.
    cutsY = find(sum(fileY, 2));
    X = fileX(cutsY(1):cutsY(end), :);
    Y = fileY(cutsY(1):cutsY(end), :);
end
