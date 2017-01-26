%% Spacing continuous Cellular automata 
%  By Shuqinlee @ Tongji University
%% Specifications
% Car's attribution£º 1*4 matrix
% velocity v;
% distance s;
% self-driving car / normal car:  1£ºself-driving car£¬0£ºnormal car;
% Entering time.
%% main
function [i,m] = main()
clc;
clear;
close all;


B=5;                    % The number of the lanes
iterations=2000;        % 
 
global plazeLen;        % length of path  
global plaza;           % all car on this cell
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
global t;               % time


plazeLen = 4336;
plaza = cell(B,1);       
acc = 8;                        
dacc = -14; 
vmax = 88;         
dt = 0.5;        
sd_lane = [0]; 
prob_self_car = 1; 
prob_slow=0.3;     
slow_acc = 0.8;
carLen = 16;
stream = 174540;
probc = stream/(24*2*7200);


out_flow = zeros(1, iterations/100);
in_flow = zeros(1, iterations/100);
cars = zeros(1000000,1);
car_ind = 1;

for t = 1: iterations
    fprintf('%d \n',t);
    
    % Step1: switch lane
    switch_lane();
    
    % Step2: move forward
    out = move_forward();
    out_flow(floor((t-1)/100)+1) =  out_flow(floor((t-1)/100)+1)+size(out,1);
    if size(out,1) ~= 0
        cars(car_ind:car_ind + size(out,1)-1) = t-out(:,4);
        car_ind = car_ind + size(out,1);
    end
    % Step3: enter new cars
    cars_num = new_cars(out);
    in_flow(floor((t-1)/100)+1) =  in_flow(floor((t-1)/100)+1)+cars_num;
end
fprintf('= = = = = = = = = = = = = = = = = = = \nSimulation finished!\n');
figure(1)
plot(out_flow);
title('Out-flow');
figure(2);
plot(cars(1:1000));
title('Cars time');
figure(3);
plot(in_flow);
title('In-flow');

% Note: 1:1000 should be ajusted according to the car generated within
% given iterations
[i, m] = find_equilibria(cars(1:car_ind-1));
fprintf('Equilibria point: %d\nMean: %f\n',i,m);
end