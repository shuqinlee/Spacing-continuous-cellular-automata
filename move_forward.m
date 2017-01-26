%%
function [complete]=move_forward()
    global plazeLen;        % length of path  
    global plaza;           % all car on this cell
    global acc;             % acceleation
    global dacc;            % decrease acceleration (negative)
    global vmax;            % speed limit
    global dt;              % time step
    global prob_slow;       % probability of random slow

    W = size(plaza, 1);
    complete = [];
    % Step1: change all cars' acceleration and new velocity
    % Step2: random slow
    % Step3: change all cars' position
    for lanes = 1:W
        cars = cell2mat(plaza(lanes)); % eg: 5 cars should be 5*4 matrix
        num = size(cars,1);
        
        if size(cars,1) == 0 
            continue;
        end
        % store all velocity
        pre = cars(:,1:2);
        
        i = 1;
        i_ = 1;
        while i <= num
            if i ~= 1
%                 if i == 13
%                     cars
%                     num
%                 end
                type = cars(i,3);
                if type == 1
                    del_d = cars(i-1,2) - cars(i,2);
                    v_pre = cars(i-1,1);
                else
                    del_d = pre(i_-1,2) - cars(i,2);
                    v_pre = pre(i_-1,1);
                end
                smax = del_d - safe_distance(cars(i,1), v_pre,type);
                v_new = min([vmax, cars(i,1)+acc*dt, (2*smax/dt - cars(i,1))]);
                if smax < 0
                    smax = 0;
                end
                if v_new < 0
                    v_new = 0;
                end
                % random slow
                if type == 0 && rand < prob_slow
                    v_new = max([pre(i_,1) + dacc*dt, 0]);
                end
                
                cars(i,1) = v_new;
                cars(i,2) = pre(i_,2) + (pre(i_,1) + v_new)*dt/2;
            else % the first car
                cars(1,1) = min([pre(i_,1) + acc * dt, vmax]);
                cars(1,2) = pre(i_,2) + (pre(i_,1) + cars(1,1))*dt/2;
                if cars(1,2) >= plazeLen
                    complete = [complete; [cars(1, :) lanes]];
                    % delete the car out
                    cars(1,:) = [];
                   
                    i = i-1;
                    num = num-1;
                end
            end
            i = i+1;
            i_ = i_+1;
            plaza(lanes) = mat2cell(cars,size(cars,1),4);
        end
    end
end