function d = compareFrames(a, b, weights)
    %d = sqeuclidean(normalizeFrame(a), normalizeFrame(b));
    c = normalizeFrame(a) - normalizeFrame(b);
    d = weights .* c .* c;
end
