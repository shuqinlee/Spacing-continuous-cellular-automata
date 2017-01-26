%% find equilibria in cars, input argument should contain all valid numbers
function [i, m] = find_equilibria(cars) 
    num = size(cars);
    m = mean(cars);
    for i = 11:num
        if mean(cars(i-10:i+10)) > m
           break;
        end
        m = (m * (num-i+1) - cars(i))/(num-i);
    end
    m = mean(cars(i+1:num));
end