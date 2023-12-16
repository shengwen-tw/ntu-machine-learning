function pla_hw
% Read dataset
dataset = dlmread('hw1_15_train.dat',' ', 1, 0);

% Question 15
ans_15 = pla(dataset, false, 1);
str = sprintf("Question 15: %f steps used", ans_15);
disp(str)

% Execute 2000 times for question 16 and 17
run_time = 2000;

% Question 16
ans_16 = 0;
for i = 1:run_time
    ans_16 = ans_16 + pla(dataset, true, 1);
end
ans_16 = ans_16 / run_time;
str = sprintf("Question 16: %f steps used avergly", ans_16);
disp(str)

% Question 17
ans_17 = 0;
for i = 1:run_time
    ans_17 = ans_17 + pla(dataset, true, 0.5);
end
ans_17 = ans_17 / run_time;
str = sprintf("Question 17: %f steps used avergly", ans_17);
disp(str)
end

function iterations = pla(dataset, ramdom_pick, learning_rate)
D = dataset;
row_size = size(D, 1);

w = [0; 0; 0; 0; 0];

% Randomize the dataset
% https://www.mathworks.com/matlabcentral/answers/30345-swap-matrix-row-randomly
if ramdom_pick
    D = D(randperm(row_size), :);
end

% Main loop of the perceptron learning algorithm
iterations = 0;
i = 1;
while evaluate(D, w)
    x = [1, D(i, 1:4)].';
    y =  D(i, 5);
    
    % Learn from the error
    if sign(w.' * x) ~= y
        % Calculate new hypothesis
        w = w + (learning_rate * y * x);
        
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

% Check if all data is clasified correctly by the PLA
% return 0 = learning finished; 1 = need more training
function result = evaluate(D, w)
row_size = size(D, 1);

for i = 1:row_size
    x = [1, D(i, 1:4)].';
    y =  D(i, 5);
    if sign(w.' * x) ~= y
        result = 1;
        return;
    end
end

result = 0;
end