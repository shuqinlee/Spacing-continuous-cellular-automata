function distance = safe_distance(v_cur, v_pre, type)
global acc;             % acceleation
global dacc;            % decrease acceleration (negative)
global vmax;            % speed limit
global dt;              % time step
global carLen;          % length of car

if type == 1 % self-driving car
    len = (v_cur.^ 2 - v_pre.^2)/(-2 * dacc);
    distance = max([carLen carLen + len]);
    
else % normal car
    v_rmax = min([v_cur + acc * dt, vmax]);
    len = (v_cur + v_rmax)*dt/2;
    distance = max([carLen, ...
                   carLen + len - (v_rmax.^2 - v_pre.^2)/(2*dacc), ...
                   carLen + len - v_pre*dt - dacc .* dt.^2/2]);
end
    
end



