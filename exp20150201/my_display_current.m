function my_display_current(x, c, s, B)
%x  = 0.1 : 0.1 : 2;
b1 = B(:, 1);
b2 = B(:, 2);


hold on
ymax = max(c(1) * b1, c(2) * b2);
yrec = log(exp( c(1) * b1)  + exp(c(2) *b2));
plot(x, s, 'black', 'LineWidth', 2);
plot(x, ymax, 'red', 'LineWidth', 2);
plot(x, yrec, 'blue', 'LineWidth', 2);
legend('ground truth', 'max', 'log');

hold off
% check
if sum( s(:) - yrec > 0) >  0
    disp('something wrong');
end