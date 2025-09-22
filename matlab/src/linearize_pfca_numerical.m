
function [A,B,C,D,x_eq,u_eq] = linearize_pfca_numerical(p, x_eq, u_eq)
%LINEARIZE_PFCA_NUMERICAL  Finite-difference Jacobian of pfca_ode around equilibrium.
if nargin<1 || isempty(p), p = pfca_params(); end
if nargin<2 || isempty(x_eq), x_eq = [p.Pr; p.Pr; 0; 0; 0; 0]; end
if nargin<3 || isempty(u_eq), u_eq = 0; end
ref_fun = @(t) 0;   % hold position at 0
f = @(x,u) pfca_ode(0, x, setfield(p,'Kv',p.Kv), @(t) 0); %#ok<SFLD> (ref 0)
% We need to feed u through controller; for linearization, bypass controller:
% Use valve input directly: implement variant of ode with 'u' input if needed.
% Here we approximate by nudging xv reference via u in Kv*u, so we emulate input through Kv.
% Numerical Jacobian in states:
nx = numel(x_eq);
A = zeros(nx); epsx = 1e-6;
fx = pfca_ode(0, x_eq, p, @(t) 0);
for i=1:nx
    dx = zeros(nx,1); dx(i) = epsx; %#ok<*NBRAK>
    f1 = pfca_ode(0, x_eq+dx, p, @(t) 0);
    A(:,i) = (f1 - fx)/epsx;
end

% Input Jacobian: approximate via small change in u propagated through Kv
epsu = 1e-4; p2 = p; p2.Kv = p.Kv*(1+epsu);
f1 = pfca_ode(0, x_eq, p2, @(t) 0);
B = (f1 - fx)/(p.Kv*epsu);  % du maps via Kv
% Output: y = x (position), select C:
C = [0 0 1 0 0 0];
D = 0;
end
