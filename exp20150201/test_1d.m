clc
close all
clear

x  = 0.1 : 0.1 : 2;
b1 = x;
b2 = x.^2;

y1 = max(b1, b2);
y2 = max(b1, 1.5 * b2);
y3 = max(b1*1.5, b2);




data  = [y1; y2; y3]';
basis = [b1; b2]';


coeff = [1, 1, 1.5; 1, 1.5, 1];
c = convex_learning(y3, basis);
my_display_current(c, y3, basis);



% cx = [-2:0.2:2];
% n = size(cx(:));
% fVal = zeros(n, n);
% for i = 1 : n
%     for j = 1 : n
%         fVal(i, j) =  obj_c([cx(i); 1], y1, basis);
%     end
%     
% end
% plot(cx, fVal(:, 1));
% [~, grad]= obj_c(c, y1, basis);

%[x,fval,exitflag] = qp_learning_c(basis, data(:, 1));
%[x,fval,exitflag] = lp_learning_c(basis, data(:, 1));
% params_coeff.Method = 'bb';
%params_coeff.MaxIter= 10;
%params_coeff.lambda = ones( 2 * 3, 1);

% C0 = zeros(size(coeff));
% C0 = coeff + rand(size(coeff)) *0.1;
% anonFunc = @(x)obj_coeff(x, data, basis);
% C = minFunc(anonFunc, C0(:), params_coeff);
% C = reshape(C, [2, 3]);
% 
% 
% % plot basis
% figure(1)
% hold on
% plot(x, b1, 'g', 'LineWidth', 2);
% plot(x, b2, 'b', 'LineWidth', 2);
% legend('f(x)=x^2','g(x)=x', 'Location', 'NorthWest');
% hold off
% 
% 
% % plot y1
% figure(2)
% hold on
% yhat1 =max(C(1, 1) * b1, C(2, 1) * b2);
% plot(x, y1, 'black', 'LineWidth', 2);
% plot(x, yhat1, 'red', 'LineWidth', 2);
% 
% legend('max(f(x), g(x))', [num2str(C(1, 1), '%.3f') 'f(x),  ' num2str(C(2, 1), '%.3f') 'g(x)'])
% hold off
% 
% figure(3)
% hold on
% yhat2 =max(C(1, 2) * b1, C(2, 2) * b2);
% plot(x, y2, 'black', 'LineWidth', 2);
% plot(x, yhat2, 'red', 'LineWidth', 2);
% 
% legend('max(f(x), 1.5g(x))', [num2str(C(1, 2), '%.3f') 'f(x),  ' num2str(C(2, 2), '%.3f') 'g(x)'])
% hold off
% 
% figure(4)
% hold on
% yhat3 =max(C(1, 3) * b1, C(2, 3) * b2);
% plot(x, y3, 'black', 'LineWidth', 2);
% plot(x, yhat3, 'red', 'LineWidth', 2);
% 
% legend('max(1.5f(x), g(x))', [num2str(C(1, 3), '%.3f') 'f(x),  ' num2str(C(2, 3), '%.3f') 'g(x)'])
% hold off

% 
% hold off
% figure
% hold on
% y1 = max(b1, b2);
% y2 = max(b1, 1.5 * b2);
% y3 = max(b1*1.5, b2);
% plot(x, y1, 'r', 'LineWidth', 3);
% plot(x, y2, 'b', 'LineWidth', 3);
% plot(x, y3, 'g', 'LineWidth', 3);
% legend('max(f(x), g(x))', 'max(f(x), 1.5g(x))', 'max(1.5f(x), g(x))')
% 
% hold off

