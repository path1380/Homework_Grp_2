function [x_pts,y_pts] = rs2xy(xp,yp,n_elems, disc_flag)
%Maps the reference square [-1,1]^2 to a quad on the x-y plane
% Inputs: xp, yp - x and y coordinates of the corners, number as below
%         n_pts  - number of points to discretize an edge
%         disc_flag - discretization flag; 1 = uniform, 2 = LGL
% Outputs: The x and y coordinates of the output points
%% Bilinear mapping
% Find a bilinear mapping from (r,s) e [-1,1]^2 into a straight sided quad
% Assume bilinear eqn of the form
%   f(r,s) = k1 + k2*r + k3*s + k4*r*s
%   f(r,s) = A*k

% 4 _ _ _ 3
%  |     |
%  |     |
%  |_ _ _|
% 1       2

% Find A by evaluating f(r,s) at all corners
A = [1 -1 -1 1; 1 1 -1 -1; 1 1 1 1; 1 -1 1 -1];

%% Map reference domain to x-y plane
% x and y coordinates of the quadrilateral
x_coeffs = inv(A)*xp';
y_coeffs = inv(A)*yp';

% Discretize rs square
n_pts = n_elems+1;

if disc_flag == 1
    r12 = linspace(-1,1,n_pts);
    s12 = linspace(-1,-1,n_pts);
    r23 = linspace(1,1,n_pts);
    s23 = linspace(-1,1,n_pts);
    r34 = linspace(1,-1,n_pts);
    s34 = linspace(1,1,n_pts);
    r41 = linspace(-1,-1,n_pts);
    s41 = linspace(1,-1,n_pts);
elseif disc_flag == 2
    [lgl_x, lgl_w, lgl_P] = lglnodes(n_elems);   % LGL discretization

    r12 = fliplr(lgl_x');
    s12 = -1*ones(1,n_pts);
    r23 = 1*ones(1,n_pts);
    s23 = fliplr(lgl_x');
    r34 = lgl_x';
    s34 = 1*ones(1,n_pts);
    r41 = -1*ones(1,n_pts);
    s41 = lgl_x';
else
    disp('Invalid disc_flag!')
end

% Discretize xy quadrilateral
x12 = zeros(numel(r12), 1);
y12 = zeros(numel(r12), 1);
x23 = zeros(numel(r23), 1);
y23 = zeros(numel(r23), 1);
x34 = zeros(numel(r34), 1);
y34 = zeros(numel(r34), 1);
x41 = zeros(numel(r41), 1);
y41 = zeros(numel(r41), 1);

for i = 1:n_pts
    x12(i) = x_coeffs(1) + x_coeffs(2)*r12(i) + x_coeffs(3)*s12(i) ...
                        + x_coeffs(4)*r12(i)*s12(i);
    y12(i) = y_coeffs(1) + y_coeffs(2)*r12(i) + y_coeffs(3)*s12(i) ...
                        + y_coeffs(4)*r12(i)*s12(i); 
    x23(i) = x_coeffs(1) + x_coeffs(2)*r23(i) + x_coeffs(3)*s23(i) ...
                        + x_coeffs(4)*r23(i)*s23(i);
    y23(i) = y_coeffs(1) + y_coeffs(2)*r23(i) + y_coeffs(3)*s23(i) ...
                        + y_coeffs(4)*r23(i)*s23(i);
    x34(i) = x_coeffs(1) + x_coeffs(2)*r34(i) + x_coeffs(3)*s34(i) ...
                        + x_coeffs(4)*r34(i)*s34(i);
    y34(i) = y_coeffs(1) + y_coeffs(2)*r34(i) + y_coeffs(3)*s34(i) ...
                        + y_coeffs(4)*r34(i)*s34(i);
    x41(i) = x_coeffs(1) + x_coeffs(2)*r41(i) + x_coeffs(3)*s41(i) ...
                        + x_coeffs(4)*r41(i)*s41(i);
    y41(i) = y_coeffs(1) + y_coeffs(2)*r41(i) + y_coeffs(3)*s41(i) ...
                        + y_coeffs(4)*r41(i)*s41(i);
end

x_pts = [x12'; x23'; x34'; x41'];
y_pts = [y12'; y23'; y34'; y41'];
