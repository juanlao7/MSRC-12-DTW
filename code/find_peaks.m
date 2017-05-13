% From http://stackoverflow.com/a/15497015
function [peaks,peak_indices] = find_peaks(row_vector)
    A = [min(row_vector)-1 row_vector min(row_vector)-1];
    j = 1;
    for i=1:length(A)-2
        temp=A(i:i+2);
        if(max(temp)==temp(2))
            peaks(j) = row_vector(i);
            peak_indices(j) = i;
            j = j+1;
        end
    end
end
