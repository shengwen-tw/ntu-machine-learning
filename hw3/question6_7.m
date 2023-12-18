function question6_7()
vec = gradient(0, 0);
str = sprintf("Question6: Gradient E(u, v) around (0, 0) = (%f, %f)", vec(1), vec(2));
disp(str);

E = gradient_descent(5, 0.01, 0, 0);
str = sprintf("Question7: E(u5, v5) = %f", E);
disp(str);
end

function result = evaluate(u, v)
result = exp(u) + exp(2*v) + exp(u*v) + u^2 - 2*u*v + 2*v^2 - 3*u - 2*v;
end

function vec = gradient(u, v)
vec = [exp(u) + v*exp(u*v) + 2*u - 2*v - 3; ...
    2*exp(u*v) + u*exp(u*v) - 2*u + 2*v - 2];
end

function E = gradient_descent(steps, learning_rate, u0, v0)
vec = [u0; v0];
for i = 1:steps
    vec = vec - learning_rate * gradient(vec(1), vec(2));
end
E = evaluate(vec(1), vec(2));
end
