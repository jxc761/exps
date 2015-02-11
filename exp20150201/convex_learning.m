function [c,fval,exitflag,output,lambda,grad,hessian]  = convex_learning(s, B)
s = s(:);
[L, M] = size(B);


fun = @(x)obj_c(x, s, B);

c0 = rand(M, 1);

%ub = zeros(M, 1);
%lb = zeros(M, 1);
%for i = 1 : M
%    pos =  B(:, i) > 0;
%    neg =  B(:, i) < 0;
%    ub(i) = min( s ./ B(pos, i) );
%    lb(i) = max( s ./ B(neg, i) );
%end
%ub = min(repmat(s, [1, M]) ./ (abs(B)-0.001), [], 1);
%lb = -ub;
ub = 2;
lb = -2;
A = zeros(L*M, M);
b = repmat(s, [M, 1]);
for i = 1 : M
    A( ((i-1)*L + 1) : i* L, i) = B(:, i);
end

hessianfcn = @(x, y)hessian_interior(x, y, s, B);
nonlcon = @(x)confun(x, s, B);
options = optimset('Hessian','user-supplied', 'GradConstr', 'on', 'GradObj', 'on', 'Algorithm', 'interior-point', 'HessFcn', hessianfcn);
[c,fval,exitflag,output,lambda,grad,hessian] = fmincon(fun, c0, [], [], [],[], [], [], nonlcon, options);
%c = simulannealbnd(fun,c0,lb,ub);

%  = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);


%opts = optimset('Algorithm','interior-point', 'GradObj','on', 'Hessian','user-supplied', 'HessFcn', hessianfcn);
%problem = createOptimProblem('fmincon','objective',...
% fun,'x0', c0,'lb', 0.5, 'ub', 2, 'nonlcon', nonlcon,'options',options);
%gs = MultiStart;
%[c,f] = run(gs,problem, 50);