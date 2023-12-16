function pla_pocket_hw
% Read dataset
train_dataset = dlmread('hw1_18_train.dat',' ', 1, 0);
verify_dataset = dlmread('hw1_18_test.dat',' ', 1, 0);

% Execute 2000 times
run_time = 2000;

% Question 18
error_rate = 0;
for i = 1:run_time
    w = pla_pocket(train_dataset, 50);
    error_cnt = evaluate(verify_dataset, w);
    error_rate_now = error_cnt / size(verify_dataset, 1);
    error_rate = error_rate + error_rate_now;
end
str = sprintf("Question 18: Average error rate of Pocket PLA with 50 steps = %f", error_rate / run_time);
disp(str)

% Question 19
error_rate = 0;
for i = 1:run_time
    w = pla(train_dataset, 50);
    error_cnt = evaluate(verify_dataset, w);
    error_rate_now = error_cnt / size(verify_dataset, 1);
    error_rate = error_rate + error_rate_now;
end
str = sprintf("Question 19: Average error rate of PLA with 50 steps = %f", error_rate / run_time);
disp(str)

% Question 20
error_rate = 0;
for i = 1:run_time
    w = pla_pocket(train_dataset, 100);
    error_cnt = evaluate(verify_dataset, w);
    error_rate_now = error_cnt / size(verify_dataset, 1);
    error_rate = error_rate + error_rate_now;
end
str = sprintf("Question 20: Average error rate of Pocket PLA with 100 steps = %f", error_rate / run_time);
disp(str)
end

function w_optimal = pla_pocket(dataset, max_iterations)
D = dataset;
row_size = size(D, 1);

w = [0; 0; 0; 0; 0];
w_optimal = w;
error_cnt = evaluate(D, w);

% Randomize the dataset
% https://www.mathworks.com/matlabcentral/answers/30345-swap-matrix-row-randomly
D = D(randperm(row_size), :);

% Main loop of the pocket version perceptron learning algorithm
iterations = 0;
i = 1;
while error_cnt ~= 0 && iterations < max_iterations
    % Select one wrong data randomly
    x = [1, D(i, 1:4)].';
    y =  D(i, 5);
    
    % Learn from the error
    if sign(w.' * x) ~= y
        % Calculate new hypothesis
        w = w +  y * x;
        
        new_error_cnt = evaluate(D, w);
        
        if(new_error_cnt < error_cnt)
            w_optimal = w;
            error_cnt = new_error_cnt;
        end
        
        % Update the iteration counter
        iterations = iterations + 1;
    end
    
    % Pick next data
    i = i + 1;
    if i > row_size
        i = 1;
    end
end
end

function w = pla(dataset, max_iterations)
D = dataset;
row_size = size(D, 1);

w = [0; 0; 0; 0; 0];

% Randomize the dataset
% https://www.mathworks.com/matlabcentral/answers/30345-swap-matrix-row-randomly
D = D(randperm(row_size), :);

% Main loop of the perceptron learning algorithm
iterations = 0;
i = 1;
while evaluate(D, w) && iterations < max_iterations
    x = [1, D(i, 1:4)].';
    y =  D(i, 5);
    
    % Learn from the error
    if sign(w.' * x) ~= y
        % Calculate new hypothesis
        w = w + y * x;
        
        % Update the iteration counter
        iterations = iterations + 1;
    end
    
    % Pick next data
    i = i + 1;
    if i > row_size
        i = 1;
    end
end
end

function result = sign(input)
if(input > 0)
    result = 1;
else
    result = -1;
end
end

% Return number of failed classification by PLA
function error = evaluate(D, w)
row_size = size(D, 1);

error = 0;
for i = 1:row_size
    x = [1, D(i, 1:4)].';
    y =  D(i, 5);
    if sign(w.' * x) ~= y
        error = error + 1;
    end
end
end