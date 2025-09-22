
function out = run_pfca_faults()
%RUN_PFCA_FAULTS  Supply drop, leakage increase, valve jam.
p = pfca_params();
p.faults.supply_drop_time   = 1.2;
p.faults.leak_increase_time = 1.6;
p.faults.jam_time           = 2.0;
ref_fun = @(t) (t>=0.1)*0.05;
x0 = zeros(6,1); x0(1)=p.Pr; x0(2)=p.Pr;
opts = odeset('RelTol',1e-6,'AbsTol',1e-8,'MaxStep',1e-3);
[t, x] = ode15s(@(tt,xx) pfca_ode(tt,xx,p,ref_fun), [0 3], x0, opts);
out = pack_out(t,x,ref_fun,p);
end
