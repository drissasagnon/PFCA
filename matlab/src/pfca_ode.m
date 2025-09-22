
function dx = pfca_ode(t, x, p, ref_fun)
%PFCA_ODE  Nonlinear PFCA ODE (EHSV + cylinder + mechanics).
% x = [pA pB x v xv vv]'
pA = x(1); pB = x(2); xp = x(3); vp = x(4); xv = x(5); vv = x(6);

% Fault scheduling
Ps = p.Ps; Cip = p.C_ip; Kv = p.Kv; bias = p.sensor.bias;
if p.faults.supply_drop_time >= 0 && t >= p.faults.supply_drop_time, Ps = p.faults.supply_drop_factor * Ps; end
if p.faults.leak_increase_time >= 0 && t >= p.faults.leak_increase_time, Cip = p.faults.leak_increase_factor * Cip; end
if p.faults.jam_time >= 0 && t >= p.faults.jam_time, Kv = 0.0; end
if p.faults.sensor_bias_time >= 0 && t >= p.faults.sensor_bias_time, bias = bias + p.faults.sensor_bias_value; end

% Sensor & ref
y_meas = xp + bias; ydot_meas = vp; r = ref_fun(t);

% Controller
u = pfca_controller(t, y_meas, ydot_meas, r, p);

% Spool servo
xv_dd = p.wv^2*(Kv*u - xv) - 2*p.zv*p.wv*vv;
xv_dot = vv;
if xv_dot >  p.dxv_max, xv_dot = p.dxv_max; end
if xv_dot < -p.dxv_max, xv_dot = -p.dxv_max; end
if xv >  p.xv_max && xv_dot > 0, xv_dd = xv_dd - 5e4*(xv - p.xv_max) - 1e3*vv; end
if xv < -p.xv_max && xv_dot < 0, xv_dd = xv_dd - 5e4*(xv + p.xv_max) - 1e3*vv; end

% Valve flows
QL = p.Kq*xv - p.Kc*(pA - pB); QA = QL; QB = -QL;

% Volumes
VA = p.V_dead + p.A_p*(xp - p.x_min);
VB = p.V_dead + p.A_r*(p.x_max - xp);
VA = max(VA, 0.1*p.V_dead); VB = max(VB, 0.1*p.V_dead);

% Continuity
pA_dot = (p.beta_e/VA) * ( QA - p.A_p*vp - Cip*(pA - pB) );
pB_dot = (p.beta_e/VB) * ( QB + p.A_r*vp - Cip*(pB - pA) );

% Mechanics
F_hyd = p.A_p*pA - p.A_r*pB;
F_fric = p.Bv*vp + p.Fc*tanh(vp/(p.v_stribeck + 1e-6));
F_end = 0;
if xp > p.x_max, F_end = p.k_end*(xp - p.x_max) + p.c_end*vp; end
if xp < p.x_min, F_end = p.k_end*(xp - p.x_min) + p.c_end*vp; end
F_load = p.Fload_fun(t,xp,vp);
vp_dot = (F_hyd - F_fric - p.Kx*xp - F_end - F_load) / p.m;

dx = [pA_dot; pB_dot; vp; vp_dot; xv_dot; xv_dd];
end
