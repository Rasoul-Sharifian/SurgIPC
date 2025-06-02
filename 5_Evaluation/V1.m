clc
clear
close all

V0_3d = [1.484500000000000056e-02 -1.460849999999999926e-01 8.539999999999999813e-01];
V1_3d = [1.444600000000000051e-02 -9.643500000000000683e-02 8.309999999999999609e-01];
V2_3d = [-3.406700000000000006e-02 -1.053710000000000063e-01 9.080000000000000293e-01];

Xs_3d = [V0_3d(1) V1_3d(1) V2_3d(1) V0_3d(1)]; 
Ys_3d = [V0_3d(2) V1_3d(2) V2_3d(2) V0_3d(2)]; 
Zs_3d = [V0_3d(3) V1_3d(3) V2_3d(3) V0_3d(3)]; 

figure , plot3(Xs_3d,Ys_3d,Zs_3d)
grid on

% # construct an orthonormal 3d basis
X = V1_3d - V0_3d;
X = X/norm(X);
Z = cross(X, (V2_3d - V1_3d));
Z = Z/norm(Z);
Y = cross(Z , X);

% # project the triangle to the 2d basis (X,Y)
z0 = [0,0];
z1 = [norm(V1_3d - V0_3d) , 0];
z2 = [dot((V2_3d - V0_3d), X) , dot((V2_3d - V0_3d), Y)];

Xs_2d = [z0(1) z1(1) z2(1) z0(1)];
Ys_2d = [z0(2) z1(2) z2(2) z0(2)];

figure , plot(Xs_2d , Ys_2d)
grid on
axis equal

Q0 = z0;
Q2 = (z1 - z0)/2;
Q1 = [0 -1;1 0] * Q2';

hold on
plot(Q0(1) , Q0(2) ,'+')
text(Q0(1), Q0(2),'\leftarrow Q0')

plot(Q1(1) , Q1(2) ,'+')
text(Q1(1), Q1(2),'\leftarrow Q1')

plot(Q2(1) , Q2(2) ,'+')
text(Q2(1), Q2(2),'\leftarrow Q2')
axis equal

P = [z0;z1;z2];
T = [1 2 3];
TR = triangulation(T,P);
% figure , triplot(TR)

B0 = cartesianToBarycentric(TR,1,Q0)
B1 = cartesianToBarycentric(TR,1,Q1')
B2 = cartesianToBarycentric(TR,1,Q2)

%Building matrix M

gradB2 = B2 - B0;
gradB1 = B1 - B0;

M = [-gradB2(1) -gradB2(2) -gradB2(3) gradB1(1) gradB1(2) gradB1(3);
    -gradB1(1) -gradB1(2) -gradB1(3) -gradB2(1) -gradB2(2) -gradB2(3)];
% M = [gradB2(1) gradB1(1) gradB2(2) gradB1(2) gradB2(3) gradB1(3);
%     -gradB1(1) -gradB2(1) -gradB1(2) -gradB2(2) -gradB1(3) -gradB2(3)];

% b = [0;0];
% 
% x_pinv = pinv(M)*b;
% 
% figure , plot([x_pinv(1:3); x_pinv(1)], [x_pinv(4:end); x_pinv(4)])
% axis equal
% grid on


% Define matrix M
% M = ...

% Define optimization problem
fun = @(x) norm(M*x);
x0 = ones(size(M, 2), 1);
Aeq = [];
beq = [];
A = [];
b = [];
lb = -Inf(size(x0));
ub = Inf(size(x0));
options = optimoptions('fmincon', 'Display', 'iter');

% Solve optimization problem subject to norm(x) = 1 constraint
[x, fval] = fmincon(fun, x0, A, b, Aeq, beq, lb, ub, @unit_constraint, options);
% x = [0;0;1;1;x];
figure , plot([x(1:3); x(1)], [x(4:end); x(4)])
axis equal
grid on

P = [V0_3d;V1_3d;V2_3d];
T = [1 2 3];
TR = triangulation(T,P);
angles = 180 - rad2deg(compute_face_angles(P, T))
angles = 180 - rad2deg(compute_face_angles([x(1),x(4);x(2),x(5);x(3),x(6)], T))

% Check solution
if norm(M*x) > eps * 1000000000
    error('x is not a solution of Mx=0');
end

function [c, ceq] = unit_constraint(x)
    ceq = norm(x) - 1;
    c = [];
end

