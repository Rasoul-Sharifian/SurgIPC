% The whole optimisation problem
% Our barycentric conformal term + grid
% gengeral optimisation approach

clc
clear
% close all

frame_ind = 30;
[v, f] = readOBJ('Mesh_fram_30_3d_masked.obj') ;

figure , plot_mesh(v,f)
title('3d mesh')
shading faceted; axis tight;
pause(1)
M = Construct_M(v , f);

[v_img, f_img] = readOBJ('Mesh_fram_30_img_masked.obj') ;
p0 = zeros(size(v_img ,1) * 2 ,1);
p0(1:2:end) = v_img(:,1);
p0(2:2:end) = v_img(:,2);

figure , plot_mesh(v_img,f_img)
title('3d mesh')
shading faceted; axis tight;
pause(1)
c_angle = [];
c_grid = [];
x0 = randn(size(M, 2), 1);
counter = 1;
for lambda = 0
    mu_grid = 15;
    mu_angle = 222;
    % Define optimization problem
    epsilon = 0.00001;
    fun = @(x) lambda * mu_angle * (1/size(f,1)) * norm(M*x) + max((1-lambda),epsilon) * mu_grid * (1/size(v,1)) * norm(x - p0);
    Aeq = [];
    beq = [];
    A = [];
    b = [];
    lb = -Inf(size(x0));
    ub = Inf(size(x0));
    nonlcon = []; % no nonlinear constraints

    options = optimoptions('fmincon', 'Display', 'iter','MaxFunctionEvaluations',10000000 , 'MaxIterations',2000);

    % Solve optimization problem subject to norm(x) = 1 constraint
    [x, fval] = fmincon(fun, x0, A, b, Aeq, beq, lb, ub, nonlcon, options);
    x_show = [x(1:2:end) , x(2:2:end)];
    figure , plot_mesh(x_show,f)
    title('flat mesh')
    shading faceted; axis tight;
    pause(1)
    c_angle = [c_angle norm(M*x)];
    c_grid = [c_grid norm(x - p0)];
    x0 = x;
    writeOBJ(['out/' num2str(counter) '.obj'] , x_show/100,f)
    counter = counter +1;
end

figure , plot ( 0.01:.005:.99, c_angle * (1/size(f,1))*mu_angle)
hold on
plot ( 0.01:.005:.99, c_grid * (1/size(v,1))*mu_grid)
grid on
% Check solution
if norm(M*x) > eps * 1000000000
    error('x is not a solution of Mx=0');
end

function [c, ceq] = unit_constraint(x)
    ceq = [];%norm(x) - 11612;
    c = [];
end

