function question13_15()
train_dataset = dlmread('hw4_train.dat',' ', 1, 0);
verify_dataset = dlmread('hw4_test.dat',' ', 1, 0);

question13(train_dataset, verify_dataset);
question14_15(train_dataset, verify_dataset);
end

function question13(train_dataset, verify_dataset)
w = ridge_regression(train_dataset, 10);
Ein = evaluate(train_dataset, w);
Eout = evaluate(verify_dataset, w);
fprintf("Question 13: Ridge regression (lambda=10) Ein = %f, Eout = %f\n", Ein, Eout);
end

function question14_15(train_dataset, verify_dataset)
% Generate lamda test sets
lambda_sets = [2, 1, 0, -1, -2, -3, -4, -5, -6, -7, -8, -9, -10];
lambda_cnt = size(lambda_sets, 2);

disp("Running for Question 14 and 15:");
Ein_best = 1e20;
Eout_best = 1e20;
log_lambda_best_Ein = 0;
log_lambda_best_Eout = 0;
for i = 1:lambda_cnt
    % Run ridge regression with different lambda values
    log_lambda = lambda_sets(i);
    w = ridge_regression(train_dataset, 10^log_lambda);
    Ein = evaluate(train_dataset, w);
    Eout = evaluate(verify_dataset, w);
    
    fprintf("lambda=10^%d -> Ein=%f, Eout=%f\n", log_lambda, Ein, Eout);
    
    % Find lambda with minimal Ein
    if Ein < Ein_best
        Ein_best = Ein;
        log_lambda_best_Ein = log_lambda;
    end
    
    % Find lambda with minimal Eout
    if Eout < Eout_best
        Eout_best = Eout;
        log_lambda_best_Eout = log_lambda;
    end
end
fprintf("Question 14: Ridge regression with lamda=10^%d has lowest Ein=%f\n", ...
    log_lambda_best_Ein, Ein_best);
fprintf("Question 15: Ridge regression with lamda=10^%d has lowest Eout=%f\n", ...
    log_lambda_best_Eout, Ein_best);
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