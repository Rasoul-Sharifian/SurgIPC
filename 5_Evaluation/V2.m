clc
clear
close all

frame_ind = 30;
[v, f] = readOBJ('Mesh_fram_82_3d_masked.obj') ;

figure , plot_mesh(v,f)
title('3d mesh')
shading faceted; axis tight;
pause(1)
M = Construct_M(v , f);

% % Define optimization problem
% fun = @(x) norm(M*x);
% x0 = randn(size(M, 2), 1);
% Aeq = [];
% beq = [];
% A = [];
% b = [];
% lb = -Inf(size(x0));
% ub = Inf(size(x0));
% options = optimoptions('fmincon', 'Display', 'iter','MaxFunctionEvaluations',1000000 , 'MaxIterations',1000);
% 
% % Solve optimization problem subject to norm(x) = 1 constraint
% [x, fval] = fmincon(fun, x0, A, b, Aeq, beq, lb, ub, @unit_constraint, options);
% x_show = [x(1:2:end) , x(2:2:end)];
% figure , plot_mesh(x_show,f)
% title('flat mesh')
% shading faceted; axis tight;
% pause(1)

% Solve it with svd decomposition
[U, S, V] = svd(M); % compute the SVD of A
tol = 1e-10; % set a tolerance for determining zero singular values
null_inds = find(diag(S) < tol); % find indices of zero singular values
null_space = V(:, null_inds); % extract the corresponding right singular vectors
x_svd = null_space(:, 1); % choose the first vector in the null space
% x_svd = x_svd / norm(x_svd); % normalize x to have norm 1

x_show_svd = [x_svd(1:2:end) , x_svd(2:2:end)];
figure , plot_mesh(x_show_svd* 1000000,f)
title('flat mesh svd')
shading faceted; axis tight;
pause(1)


% Check solution
if norm(M*x) > eps * 1000000000
    error('x is not a solution of Mx=0');
end

function [c, ceq] = unit_constraint(x)
    ceq = norm(x) - 1;
    c = [];
end

