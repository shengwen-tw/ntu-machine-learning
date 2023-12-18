function question4
figure('Name','y = 1');
plot_bounds(1, -3, 4);
figure('Name','y = -1');
plot_bounds(-1, -4, 3);
disp("Press any key to leave");
pause;
close all;
end

function plot_bounds(y, range_min, range_max)
s = [range_min:0.01:range_max];
[dummy, seq_size] = size(s);
target_seq = zeros(1, seq_size);
err1_seq = zeros(1, seq_size);
err2_seq = zeros(1, seq_size);
err3_seq = zeros(1, seq_size);
err4_seq = zeros(1, seq_size);
for i = 1:seq_size
    target_seq(i) = target(y, s(i));
    err1_seq(i) = err1(y, s(i));
    err2_seq(i) = err2(y, s(i));
    err3_seq(i) = err3(y, s(i));
    err4_seq(i) = err4(y, s(i));
end
hold on
plot(s, target_seq);
plot(s, err1_seq)
plot(s, err2_seq)
plot(s, err3_seq)
plot(s, err4_seq)
legend('[sign(s) != y]', 'max(0, 1-s)', '[s >= y]', 'max(0, -ys)', '1/2*exp(-ys)');
end

function result = sign(input)
if(input > 0)
    result = 1;
else
    result = -1;
end
end

function result = target(y, s)
if(sign(s) ~= y)
    result = 1;
else
    result = 0;
end
end

% y = 1 or -1
function result = err1(y, s)
value = 1 - y * s;
result = max(0, value);
end

function result = err2(y, s)
if s >= y
    result = 1;
else
    result = 0;
end
end

function result = err3(y, s)
value = -y * s;
result = max(0, value);
end

function result = err4(y, s)
result = 1 / 2 * exp(-y * s);
end

function result = max(value1, value2)
if value1 > value2
    result = value1;
elseif value1 < value2
    result = value2;
else
    result = value1;
end
end