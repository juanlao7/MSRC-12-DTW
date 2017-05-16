function d = compareFrames(a, b)
    d = sqeuclidean(normalizeFrame(a), normalizeFrame(b));
end
