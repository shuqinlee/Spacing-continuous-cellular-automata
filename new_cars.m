% enter a car randomly
function cars = new_cars(in)
    global probc;           % probability to generate a car
    cars = 0;
    
    in_num = size(in,1);
    success = 0;
    if in_num ~= 0
        while success == 0
            in_car = floor(in_num * rand)+1;
            success = add_car(in(in_car,:));
            if success
                cars = cars + 1;
            end
        end
    end
    if probc < 1 && success == 0
        if rand <= probc
            if add_car() ~= 0
                cars = cars + 1;
            end
        end
    else
        for i = 1:ceil(probc)-1
            if add_car() ~= 0
                cars = cars + 1;
            end
        end
    end
end