function d = compareFrames(a, b, weights)
    c = normalizeFrame(a) - normalizeFrame(b);
    d = weights .* c .* c;
end
