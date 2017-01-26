function random_slow()
    global plaza;           % all car on this cell
    global dt;              % time step
    global slow_acc;        % decrease acceleration of random slow

    W = size(plaza, 1);
    for lanes=1:W
        cars = cell2mat(plaza(lanes)); 
        num = size(cars,2);
        for i = 1:num
            if rand <= probslow
                cars(i,1) = cars(i,1) - slow_acc*dt;
            end
        end
    end
end