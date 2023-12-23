function question13_20()
whole_dataset = dlmread('hw4_train.dat',' ', 1, 0);
test_dataset = dlmread('hw4_test.dat',' ', 1, 0);

% Cross validation setting
cv_cnt = 5; % Mumber of the cross-validation sets
cv_size = 200 / cv_cnt; % Size of the cross validation dataset

% Generate lamda test sets
lambda_sets = [2, 1, 0, -1, -2, -3, -4, -5, -6, -7, -8, -9, -10];
lambda_cnt = size(lambda_sets, 2);

Ecv_best = 1e20;
log_lambda_best_Ecv = 0;
for i = 1:lambda_cnt
    % Intialize Ecv for current fixed lambda value
    Ecv = 0;
    
    for j = 1:cv_cnt
        fprintf("Cross validation #%d:\n", j);
        
        % Generate training and validation datasets
        validate_dataset = whole_dataset((j-1)*cv_size+1:j*cv_size, :);
        fprintf("validate_dataset = D[%d:%d]\n", (j-1)*cv_size+1, j*cv_size);
        
        if(j == 1)
            fprintf("train_dataset = D[%d:%d]\n", 1*cv_size+1, 200);
            train_dataset = whole_dataset(1*cv_size+1:end, :);
        elseif(j == 5)
            fprintf("train_dataset = D[%d:%d]\n", 1,4*cv_size);
            train_dataset = whole_dataset(1:4*cv_size, :);
        else % i = 3, 4, 5
            fprintf("train_dataset = D[%d:%d] and D[%d:%d]\n", 1 , (j-1)*cv_size, (j*cv_size+1), 200);
            train_dataset = ...
                [whole_dataset(1:(j-1)*cv_size, :); ...
                whole_dataset(j*cv_size+1:end, :)];
        end
        fprintf("---------------------------------------\n");
        
        % Run ridge regression with cross validation
        log_lambda = lambda_sets(i);
        w = ridge_regression(train_dataset, 10^log_lambda);
        Ecv_now = evaluate(validate_dataset, w);
        
        % Accumulate Ecv and do averaging;
        Ecv = Ecv + (Ecv_now / cv_cnt);
    end
    
    % Find the optimal lambda with the minimal Ecv
    if Ecv < Ecv_best
        Ecv_best = Ecv;
        log_lambda_best_Ecv = log_lambda;
    end
end

% Question 19
fprintf("Question 19: Cross-validated ridge regression with lamda=10^%d has Ecv=%f\n", ...
    log_lambda_best_Ecv, Ecv_best);

% Question 20
w = ridge_regression(train_dataset, 10^log_lambda_best_Ecv);
E_in = evaluate(whole_dataset, w);
E_out = evaluate(test_dataset, w);
fprintf("Question 20: Cross-validated ridge regression with lamda=10^%d has Ein=%f and Eout=%f\n", ...
    log_lambda_best_Ecv, E_in, E_out);
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
if(input > 0)
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