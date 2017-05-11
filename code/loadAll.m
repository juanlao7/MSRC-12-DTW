function [data] = loadAll()
    data = [];
    files = dir('../data/*.csv');
    
    for file = files'
        [pathstr, name, ext] = fileparts(file.name);
        [X, Y, tagset] = load_file(name);
        data = [data struct('X', X, 'Y', Y)];
        break
    end
end

