function question13()
iteration_times = 1000;

% Question 13
E_lin = 0;
for i = 1:iteration_times
    E_lin = E_lin + training(false);
end
E_lin = E_lin / iteration_times;

str = sprintf("Question 15: Ein of linear regression with 0/1 error = %f", E_lin);
disp(str);

end

function E = training(visualize)
% Generate training dataset
% D[:, 1]: x1
% D[:, 2]: x2
% D[:, 3]: y --> label with 10% of error
% D[:, 4]: f(x1, x2) --> true answer
D = zeros(1000, 4);

positives = [];
negatives = [];

for i = 1:1000
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
    
    if visualize == true
        if D(i, 3) > 0
            positives(i, 1:3) = [x1, x2, D(i, 3)];
        else
            negatives(i, 1:3) = [x1, x2, D(i, 3)];
        end
    end
end

% Linear regression
X = ones(size(D, 1), 3);
X(:, 2:3) = [D(:, 1:2)];
y = [D(:, 3)];
w_lin = inv(X.' * X) * X.' * y;
E = evaluate(D, w_lin);

if visualize == true
    hold on;
    scatter(positives(:, 1).', positives(:, 2).', '.');
    scatter(negatives(:, 1).', negatives(:, 2).', '.');
    
    disp("Press any key to leave.");
    pause;
    close all;
end

end

function result = sign(input)
if(input > 0)
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
    x = [1, D(i, 1:2)].'; % [1, x1, x2]
    y = D(i, 3);
    if sign(wt * x) ~= y
        error = error + 1;
    end
end
E = error / N;
end