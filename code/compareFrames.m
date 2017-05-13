function d = compareFrames(a, b)
    d = sqrt(sqeuclidean(normalizeFrame(a), normalizeFrame(b)));
end
