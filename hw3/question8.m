function question8()
disp("Question8:");
buu = buu_evaluate(0, 0)
bvv = bvv_evaluate(0, 0)
buv = buv_evaluate(0, 0)
bu = bu_evaluate(0, 0)
bv = bv_evaluate(0, 0)
b = b_evaluate(0, 0)
end

function result = b_evaluate(u, v)
result = exp(u) + exp(2*v) + exp(u*v) - 2*u*v + 2*v^2 - 3*u -2*v;
end

function result = bu_evaluate(u, v)
result = exp(u) + v*exp(u*v) + 2*u - 2*v -3;
end

function result = bv_evaluate(u, v)
result = 2*exp(2*v) + u*exp(u*v) - 2*u + 4*v -2;
end

function result = buu_evaluate(u, v)
result = 1/2*(exp(u) + v^2*exp(u*v) + 2);
end

function result = bvv_evaluate(u, v)
result = 1/2*(4*exp(2*v) + u^2*exp(u*v) + 4);
end

function result = buv_evaluate(u, v)
result = exp(u*v) + u*v*exp(u*v) - 2;
end