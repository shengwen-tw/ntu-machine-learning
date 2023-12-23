function question16_18()
whole_dataset = dlmread('hw4_train.dat',' ', 1, 0);
test_dataset = dlmread('hw4_test.dat',' ', 1, 0);

% Generate lamda test sets
lambda_sets = [2, 1, 0, -1, -2, -3, -4, -5, -6, -7, -8, -9, -10];
lambda_cnt = size(lambda_sets, 2);

validate_dataset = whole_dataset(121:200, :);
train_dataset = whole_dataset(1:120, :);

% Question 16 and Question 17
disp("Running for Question 16 and 17:");
E_train_best = 1e20;
E_test_best = 1e20;
log_lambda_best_E_train = 0;
log_lambda_best_E_validate = 0;
for i = 1:lambda_cnt
    % Run ridge regression with different lambda values
    log_lambda = lambda_sets(i);
    w = ridge_regression(train_dataset, 10^log_lambda);
    E_train = evaluate(train_dataset, w);
    E_validate = evaluate(validate_dataset, w);
    E_test = evaluate(test_dataset, w);
    
    fprintf("lambda=10^%d -> E_train=%f, E_validate=%f, E_test=%f\n", ...
        log_lambda, E_train, E_validate, E_test);
    
    % Find lambda with minimal E_train
    if E_train < E_train_best
        E_train_best = E_train;
        log_lambda_best_E_train = log_lambda;
    end
    
    % Find lambda with minimal E_test
    if E_validate < E_test_best
        E_test_best = E_validate;
        log_lambda_best_E_validate = log_lambda;
    end
end
fprintf("Question 16: Ridge regression with lamda=10^%d has lowest E_train=%f\n", ...
    log_lambda_best_E_train, E_train_best);
fprintf("Question 17: Ridge regression with lamda=10^%d has lowest E_validate=%f\n", ...
    log_lambda_best_E_validate, E_train_best);

% Question 18
w = ridge_regression(train_dataset, 10^log_lambda_best_E_validate);
E_in = evaluate(whole_dataset, w);
E_out = evaluate(test_dataset, w);
fprintf("Question 18: Ridge regression with lamda=10^%d on the dataset D has Ein=%f and Eout=%f\n", ...
    log_lambda_best_E_validate, E_in, E_out);
end

function w = ridge_regression(D, lambda)
N = size(D, 1);
y = D(:, 3);
X = [ones(N, 1), D(:, 1:2)];
Xt = X.';
lambdaI = lambda * eye(size(X, 2));
w = inv(Xt*X + lambdaI)*Xt*y;
end

function result = sign(input)
if(input >= 0)
    result = 1;
else
    result = -1;
end
end

function E = evaluate(D, w)
wt = w.';
N = size(D, 1);
E = 0;
for i = 1:N
    x = [1, D(i, 1:2)].';
    y = D(i, 3);
    if(sign(wt*x) ~= y)
        E = E + 1;
    end
end
E = E / N;
end
