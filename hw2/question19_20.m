function question17_18()
iteration_times = 5000;

Ein_average = 0;
Eout_average = 0;
for i = 1:iteration_times
    % Generate random dataset with size of 20
    D = generate_dataset();
    
    % Run decision stump algorithm and calculate Ein
    [Ein, theta, s] = decision_stump(D);
    Ein_average = Ein_average + Ein;
    
    % Calculate Eout
    Eout_now = 0.5 + 0.3*s*(abs(theta) - 1);
    Eout_average = Eout_average + Eout_now;
end
Ein_average = Ein_average / iteration_times;
Eout_average = Eout_average / iteration_times;

fprintf("Question 17: Average Ein of decision stump = %f\n", Ein_average);
fprintf("Question 17: Average Eout of decision stump = %f\n", Eout_average);
end

function D = generate_dataset()
D = zeros(20, 2);
for i = 1:20
    x = -1+2*rand(1);
    y = sign(x);
    
    if(rand(1) < 0.2)
        y = -y;
    end
    D(i, 1) = x;
    D(i, 2) = y;
end
end

function [Ein, theta, s] = decision_stump(D)
% Find optimal theta = x_i and s = 1 or -1 with lowest Ein
N = size(D, 1);
s = 1;
Ein = 1e20;
for i = 1:N-1
    x = D(i, 1);
    theta_now = x;
    
    % Test theta = x_i and s = 1
    Ein_now = evaluate(1, theta_now, D);
    if(Ein_now < Ein)
        Ein = Ein_now;
        theta = theta_now;
        s = 1;
    end
    
    % Test theta = x_i and s = -1
    Ein_now = evaluate(-1, theta_now, D);
    if(Ein_now < Ein)
        Ein = Ein_now;
        theta = theta_now;
        s = -1;
    end
end
end

function result = sign(input)
if(input >= 0)
    result = 1;
else
    result = -1;
end
end

function Ein = evaluate(s, theta, D)
Ein = 0;
N = size(D, 1);
for i = 1:N
    x = D(i, 1);
    y = D(i, 2);
    h = s * sign(x - theta);
    if h ~= y
        Ein = Ein + 1;
    end
end
Ein = Ein / N;
end