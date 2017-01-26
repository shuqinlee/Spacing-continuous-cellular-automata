%% Note:
%  If all lanes are not available, then enter no car
%%
function tmp_lane = add_car(in_car)

global plaza;           % all car on this cell
global vmax;            % speed limit
global sd_lane;         % self_driving lanes chosen
global prob_self_car;   % proportion of self-driving car 
global t;               % time


if nargin < 1
    W = size(plaza,1);
    success = 0;
    visited = zeros(1,W); %!!
    while success == 0 && (size(find(visited == 1),2) ~= W) 
        tmp_lane = floor(rand*W)+1;
        if visited(tmp_lane) == 1
           continue;
        end
        visited(tmp_lane) = 1;
    
        cars = cell2mat(plaza(tmp_lane)); % eg. 5 cars should be 5*3 matrix
        num = size(cars,1);
        tmp_ty = (rand < prob_self_car); % 1£ºnormal, 0£ºself-driving
        tmp_v = rand * vmax;

        % distance to the last car in chosen lane should be larger than
        % safe distance
        if num ~= 0
            if cars(num,2) >= safe_distance(tmp_v, cars(num,1), tmp_ty)
                success = 1;
          
                % if a normal car initiated at self-driving lane
                if tmp_ty == 1 && size(find(sd_lane == tmp_lane),2) ~= 0 
                    success = 0;
                else
                plaza(tmp_lane) = mat2cell([cars; [tmp_v 0 tmp_ty t]], num+1, 4);
                end
            end
        else
            plaza(tmp_lane) = mat2cell([tmp_v 0 tmp_ty t], 1, 4);
            success = 1;
        end
    end
    if size(find(visited == 1),2) == W
        tmp_lane = 0;
    end
else
    tmp_lane = in_car(5);
    cars = cell2mat(plaza(tmp_lane));
    num = size(cars,1);
    type = in_car(3);
    v = in_car(1);
    in_car(2) = 0;
    in_car(4) = t;
    in_car = in_car(1:4);
    
    if size(cars,1) == 0 || ...
        (cars(num,2) >= safe_distance(v, cars(num,1), type))
        plaza(tmp_lane) = mat2cell([cars; in_car], num+1, 4);
    else
        tmp_lanes = 0;
    end
end
end