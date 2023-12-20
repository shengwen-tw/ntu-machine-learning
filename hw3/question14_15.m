function question14_15()
iteration_times = 1000;
visualize = false;

E = 0;
w_average = zeros(6, 1);
for i = 1:iteration_times
    [w_now ,E_now] = training(visualize);
    E = E + E_now;
    w_average = w_average + w_now;
end
E = E / iteration_times;
w_average = w_average / iteration_times;

str = sprintf("Question 14: Nonlinear regression w = (%f, %f, %f, %f, %f, %f)", ...
    w_average(1), w_average(2), w_average(3), w_average(4), w_average(5), w_average(6));
disp(str);

str = sprintf("Question 15: Eout of nonlinear regression with 0/1 error = %f", E);
disp(str);

end

function [D, positives, negatives] = generate_dataset(N)
% Generate dataset
% D[:, 1]: x1
% D[:, 2]: x2
% D[:, 3]: y --> label with 10% of error
% D[:, 4]: f(x1, x2) --> true answer
D = zeros(N, 4);

positives = [];
negatives = [];

for i = 1:N
    % Generate 2D point in range of [-1, 1]
    D(i, 1) = -1 + 2 * rand();
    D(i, 2) = -1 + 2 * rand();
    
    % Target function
    x1 = D(i, 1);
    x2 = D(i, 2);
    D(i, 4) = sign(x1^2 + x2^2 - 0.6);
    
    % Flip the sign of the training dataset in a random 10%
    if(rand() < 0.1)
        D(i, 3) = D(i, 4) * -1;
    else
        D(i, 3) = D(i, 4);
    end
    
    if D(i, 3) > 0
        positives(i, 1:3) = [x1, x2, D(i, 3)];
    else
        negatives(i, 1:3) = [x1, x2, D(i, 3)];
    end
end
end

function [w, E] = training(visualize)
N = 1000;
[D_training, positives, negatives] = generate_dataset(N);

% Feature transform
X = zeros(N, 6);
for i = 1: N
    x = D_training(i, 1:2);
    z = feature_transform(x);
    X(i, :) = z;
end

% Linear regression
y = D_training(:, 3);
w_nonlin = inv(X.' * X) * X.' * y;
w = w_nonlin;

% Validation
[D_validate, dummy1, dummy2] = generate_dataset(N);
E = evaluate(D_validate, w_nonlin);

% Visualization
if visualize == true
    xlim([-1, 1]);
    ylim([-1,1]);
    
    hold on;
    scatter(positives(:, 1).', positives(:, 2).', '.');
    scatter(negatives(:, 1).', negatives(:, 2).', '.');
    
    fx = @(x1, x2)(w(1) + w(2)*x1 + w(3)*x2 + w(4)*x1*x2 + w(5)*x1^2 + w(6)*x2^2);
    ezplot(fx);
    
    disp("Press any key to leave.");
    pause;
    close all;
end

end

function z = feature_transform(x)
z = [1, x(1), x(2), x(1)*x(2), x(1)^2, x(2)^2];
end

function result = sign(input)
if(input >= 0)
    result = 1;
else
    result = -1;
end
end

function E = evaluate(D, w)
N = size(D, 1);
wt = w.';
error = 0;
for i = 1:N
    x = D(i, 1:2);
    y = D(i, 3);
    z = feature_transform(x).'; % [1, x1, x2, x1x2, x1^2, x2^2]
    if sign(wt * z) ~= y
        error = error + 1;
    end
end
E = error / N;
end