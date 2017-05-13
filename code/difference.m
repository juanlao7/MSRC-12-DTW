function d = difference(a, b)
    d = sqeuclidean(normalizeFrame(a), normalizeFrame(b));
end
