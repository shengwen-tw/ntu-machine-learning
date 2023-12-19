function question10()
E5 = newtons_method(5);
str = sprintf("Question10: Netwon's method after 5 iterations = %f", E5);
disp(str);
end

function result = E(x)
u = x(1);
v = x(2);
result = exp(u) + exp(2*v) + exp(u*v) + u^2 - 2*u*v + 2*v^2 - 3*u -2*v;
end

function result = newtons_method(iterations)
x = [0; 0];
for i = 1:iterations
    dir = newtons_direction(x);
    x = x + dir;
end
result = E(x);
end

function dir = newtons_direction(x)
u = x(1);
v = x(2);

% Hession matrix
puu = exp(u) + v^2*exp(u*v) + 2;
puv = exp(u*v) + u*v*exp(u*v) - 2;
pvv = 4*exp(2*v) + u^2*exp(u*v) + 4;
H = [puu puv; ...
    puv pvv];

% Gradient
pu = exp(u) + v*exp(u*v) + 2*u - 2*v -3;
pv = 2*exp(2*v) + u*exp(u*v) - 2*u + 4*v -2;
J = [pu; pv];

% Newton's direction
dir = -inv(H) * J;
end