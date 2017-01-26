function switch_lane()
    global plaza;           % all car on this cell
    global sd_lane;         % self_driving lanes chosen

    W = size(plaza,1); 
    switch_ = 0;
    
    for lanes = 1:W
        cars = cell2mat(plaza(lanes)); 
        num = size(cars,1);
        if num == 0
            continue;
        end
        car_ind = 1;
        %for car_ind = 1: num
        while car_ind <= num
            type = cars(car_ind,3);
            pos = cars(car_ind,2);
            if car_ind ~= 1
                dist = cars(car_ind-1,2)-pos;
            else 
                car_ind = car_ind + 1;
                continue;
            end
            cars_l = [];
            cars_r = [];
            
            if lanes ~= 1 && lanes ~= W % not left most or right most

                cars_l = cell2mat(plaza(lanes-1));
                cars_r = cell2mat(plaza(lanes+1));
                
                % check nearest car and car after index
                [la, lb] = find_nearest_car(pos, cars_l);
                [ra, rb] = find_nearest_car(pos, cars_r);
                
                % compute safe distance
                if la ~= 0
                    safe_l = safe_distance(cars(car_ind,1), cars_l(la,1), type);
                end
                if ra ~= 0
                    safe_r = safe_distance(cars(car_ind,1), cars_r(ra,1), type);
                end

                % check car after distance
                % 1. no pre car la = 0  2. no post car lb = 0
                if la == 0
                    l_dist = inf;
                    if lb ~= 0 && (after_dist_available(cars(car_ind,:), cars_l(lb,:)) ~= 1)
                        l_dist = 0;
                    end
                else 
                    l_dist = pre_available(cars_l(la,2), pos, safe_l);
                    if lb ~= 0 && (after_dist_available(cars(car_ind,:), cars_l(lb,:)) ~= 1) 
                        l_dist = 0;
                    end
                    if (size(find(lanes-1 == sd_lane),2) ~= 0) && type == 0
                        l_dist = 0;
                    end 
                end
                if ra == 0
                    r_dist = inf;
                    if rb ~= 0 && (after_dist_available(cars(car_ind,:), cars_r(rb,:)) ~= 1)
                        r_dist = 0;
                    end
                else
                    r_dist = pre_available(cars_r(ra,2), pos, safe_r);
                    if rb ~= 0 && (after_dist_available(cars(car_ind,:), cars_r(rb,:)) ~= 1) 
                        r_dist = 0;
                    end
                    if (size(find(lanes+1 == sd_lane),2) ~= 0) && type == 0
                        r_dist = 0;
                    end
                end    
                
                % find smallest in dist, l_dist, r_dist
                [d, ind] = max([dist l_dist r_dist]);
                
                if (ind == 2 && (r_dist ~= l_dist)) ||... % left is better and not draw
                   (r_dist == l_dist &&... % draw
                   type == 1 &&... % self-driving car
                   la ~= 0 && cars_l(la,3) == 1) % front is self-driving car
                           
                   % switch to left lane
                   switch_ = 1;
                   if la ~= 0
                       if lb ~= 0
                            cars_l = [cars_l(1:la, :); ...
                                  cars(car_ind, :);...
                                  cars_l(lb:size(cars_l,1),:)];% 插入
                       else
                           cars_l = [cars_l(:,:); cars(car_ind,:)];
                       end
                   else
                       cars_l = [cars(car_ind,:);cars_l(:,:)];
                   end
                   cars(car_ind, :) = [];
                elseif ind == 3 
                   switch_ = 1;
                   % switch to right lane
                   if ra ~= 0
                       if rb ~= 0
                            cars_r = [cars_r(1:ra, :); ...
                                  cars(car_ind, :);...
                                  cars_r(rb:size(cars_r,1),:)];% 插入
                       else
                           cars_r = [cars_r(:,:); cars(car_ind,:)];
                       end
                   else
                       cars_r = [cars(car_ind,:);cars_r(:,:)];
                   end
                   cars(car_ind, :) = [];
                end
            elseif lanes == 1
                cars_r = cell2mat(plaza(lanes+1));
                % check nearest car and car after index
                [ra, rb] = find_nearest_car(pos, cars_r);

                if ra == 0
                    r_dist = inf;
                    if rb ~= 0 && (after_dist_available(cars(car_ind,:), cars_r(rb,:)) ~= 1)
                        r_dist = 0;
                    end
                else
                    
                    safe_r = safe_distance(cars(car_ind,1), cars_r(ra,1), type);
                    r_dist = pre_available(cars_r(ra,2), pos, safe_r);
                    if rb ~= 0 && (after_dist_available(cars(car_ind,:), cars_r(rb,:)) ~= 1) 
                        r_dist = 0;
                    end
                    if (size(find(lanes+1 == sd_lane),2) ~= 0) && type == 0
                        r_dist = 0;
                    end
                end 
                
                % find smallest in dist, l_dist, r_dist
                [d, ind] = max([dist r_dist]);
                
                if ind == 2
                  switch_ = 1;
                  if ra ~= 0
                       if rb ~= 0
                            cars_r = [cars_r(1:ra, :); ...
                                  cars(car_ind, :);...
                                  cars_r(rb:size(cars_r,1),:)];% 插入
                       else
                           cars_r = [cars_r(:,:); cars(car_ind,:)];
                       end
                   else
                       cars_r = [cars(car_ind,:);cars_r(:,:)];
                   end
                   cars(car_ind, :) = [];
                end
             elseif lanes == W
                cars_l = cell2mat(plaza(lanes-1));
                % check nearest car and car after index
                [la, lb] = find_nearest_car(pos, cars_l);

                if la == 0
                    l_dist = inf;
                    if lb ~= 0 && (after_dist_available(cars(car_ind,:), cars_l(lb,:)) ~= 1)
                        l_dist = 0;
                    end
                else
                    safe_l = safe_distance(cars(car_ind,1), cars_l(la,1), type);
                    l_dist = pre_available(cars_l(la,2), pos, safe_l);
                    if lb ~= 0 && (after_dist_available(cars(car_ind,:), cars_l(lb,:)) ~= 1) 
                        l_dist = 0;
                    end
                    if (size(find(lanes-1 == sd_lane),2) ~= 0) && type == 0
                        l_dist = 0;
                    end 
                end
                
                % find smallest in dist, l_dist, r_dist
                [d, ind] = max([dist l_dist]);
                
                if ind == 2
                    switch_ = 1;
                   % switch to left lane
                   if la ~= 0
                       if lb ~= 0
                            cars_l = [cars_l(1:la, :); ...
                                  cars(car_ind, :);...
                                  cars_l(lb:size(cars_l,1),:)];% 插入
                       else
                           cars_l = [cars_l(:,:); cars(car_ind,:)];
                       end
                   else
                       cars_l = [cars(car_ind,:);cars_l(:,:)];
                   end
                   cars(car_ind, :) = [];

                end
            end
            if lanes ~= 1
%                 cars_l
                plaza(lanes-1) = mat2cell(cars_l, size(cars_l,1), 4);
            end
            if lanes ~= W
%                 cars_r
                plaza(lanes+1) = mat2cell(cars_r, size(cars_r,1), 4);
            end
            plaza(lanes) = mat2cell(cars, size(cars,1), 4);
            num = size(cars,1);           
            if switch_ == 1
                car_ind = car_ind-1;
            end
            switch_ = 0;
            car_ind = car_ind + 1;
        end
    end           
end