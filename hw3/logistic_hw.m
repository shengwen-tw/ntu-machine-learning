function logistic_hw
% Read dataset
train_dataset = dlmread('hw3_train.dat',' ', 1, 0);
verify_dataset = dlmread('hw3_test.dat',' ', 1, 0);

% Question 18
w = logistic_regression(train_dataset, 0.001, 2000);
Eout = evaluate_binary(verify_dataset, w);
str = sprintf("Question 18: Eout with 0/1 error = %f", Eout);
disp(str);

% Question 19
w = logistic_regression(train_dataset, 0.01, 2000);
Eout = evaluate_binary(verify_dataset, w);
str = sprintf("Question 19: Eout with 0/1 error = %f", Eout);
disp(str);

% Question 20
w = logistic_regression_stochastic(train_dataset, 0.001, 2000);
Eout = evaluate_binary(verify_dataset, w);
str = sprintf("Question 20: Eout with 0/1 error = %f", Eout);
disp(str);

end

function w = logistic_regression(dataset, learning_rate, run_time)
D = dataset;
N = size(D, 1); % Size of the dataset

w = zeros(21, 1);

% Main loop of the logistic regression
for iteration = 1:run_time
    % Gradient descent
    gradient = 0; % Gradient of the Ein
    % Iteration thorugh the whole dataset to calcuate the gradient
    for i = 1:N
        x = [1, D(i, 1:20)].';
        y =  D(i, 21);
        theta = logistic_function(-y * w.' * x);
        gradient = gradient + theta * (-y * x);
    end
    gradient = gradient / N;
    w = w - learning_rate * gradient;  % Calculate the new hyoithesis
end
end

function w = logistic_regression_stochastic(dataset, learning_rate, run_time)
D = dataset;
N = size(D, 1); % Size of the dataset

w = zeros(21, 1);

% Main loop of the stochastic logistic regression
i = 1;
for iteration = 1:run_time
    % Schotastic gradient descent
    x = [1, D(i, 1:20)].';
    y =  D(i, 21);
    theta = logistic_function(-y * w.' * x);
    gradient = theta * (-y * x); % Gradient of the Ein
    w = w - learning_rate * gradient; % Calculate the new hyoithesis
    
    % Mimic the stochastic with cyclic selection
    i = i + 1;
    if i > N
        i = 1;
    end
end
end

function theta = logistic_function(s)
theta = 1 / (1 + exp(-s));
end

function result = sign(input)
if(input > 0)
    result = 1;
else
    result = -1;
end
end

% For calculating Eout with 0/1 error
function error = evaluate_binary(D, w)
N = size(D, 1);

error = 0;
for i = 1:N
    x = [1, D(i, 1:20)].';
    y =  D(i, 21);
    s = w.' * x;
    error_now = 0;
    if sign(y * s) ~= 1
        error_now = 1;
    end
    error = error + error_now;
end
error = error / N;
end

% For calculating Eout with cross entropy error
function error = evaluate_logistic(D, w)
N = size(D, 1);

error = 0;
for i = 1:N
    x = [1, D(i, 1:20)].';
    y =  D(i, 21);
    s = w.' * x;
    error = error + log(1 + exp(-y * s));
end
error = error / N;
end