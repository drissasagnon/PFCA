
function out = run_pfca_nominal()
%RUN_PFCA_NOMINAL  Step response (0 -> +50 mm).
p = pfca_params();
ref_fun = @(t) (t>=0.1)*0.05;   % [m]
x0 = zeros(6,1); x0(1)=p.Pr; x0(2)=p.Pr;
opts = odeset('RelTol',1e-6,'AbsTol',1e-8,'MaxStep',1e-3);
[t, x] = ode15s(@(tt,xx) pfca_ode(tt,xx,p,ref_fun), [0 3], x0, opts);
out = pack_out(t,x,ref_fun,p);
end

function out = pack_out(t,x,ref_fun,p)
out.t=t; out.pA=x(:,1); out.pB=x(:,2); out.xp=x(:,3); out.vp=x(:,4); out.xv=x(:,5); out.vv=x(:,6);
out.r = arrayfun(ref_fun,t); out.p=p;
end
