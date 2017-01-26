## Spacing continuous cellular automata

This is a spacing automata mainly written for simulation of cars on highways. The parameters you can change are specified as below. Specifically, these automata contains self-driving cars and non-self driving cars.

### main.m

You can change these parameters in main.m

```matlab
B=5;                    % The number of the lanes
iterations=2000;        
 
global plazeLen;        % length of path  
global acc;             % acceleation
global dacc;            % decrease acceleration (negative)
global vmax;            % speed limit
global dt;              % time step
global sd_lane;         % self_driving lanes chosen
global probc;           % probability to generate a car
global prob_self_car;   % proportion of self-driving car   
global prob_slow;       % probability of random slow
global slow_acc;        % decrease acceleration of random slow 
global carLen;          % length of car
global stream;          % average daily traffic counts  
global t;               % current time
```

### test.m

Set simulation times in test.m. Output is stored in data, which contains equibria point of runtime of cars and average time of each simlation. 

```matlab
data = zeros(10,2);
for i = 1:10
    [a,b] = main();
    data(i,:) = [a,b];
end
```

