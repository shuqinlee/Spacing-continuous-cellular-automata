%% find_nearest_car(dist,cars)
 
% 1. No car .ok ind_a = 0, ind_b = 0 ok
% 2. No pre car, but has post car:  ind_a = 0  ind_b = 1 ok
% 3. No post car, but has pre car:  ind_a not 0, ind_b = 0 ok
% 4. Normal .ok ind_a != 0, ind_b != 0 ok
%%
function [ind_a,ind_b] = find_nearest_car(dist,cars)
    num = size(cars,1);
    ind_a = 0;
    ind_b = 0;
    if num ~= 0
        for ind = 1:size(cars,1)
            if dist >= cars(ind,2)
                ind_a = ind-1;
                ind_b = ind;
            else
                ind_a = ind;
            end
        end
    end
end
