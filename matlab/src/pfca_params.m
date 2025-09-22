
function p = pfca_params()
%PFCA_PARAMS  Parameter set for a hydro-mechanical PFCA (EHSV + cylinder).
% See docs/theory/01_modeling_theory.md for equations.

p.stroke      = 0.100;           % [m]
p.x_min       = -p.stroke/2;
p.x_max       =  p.stroke/2;

p.d_bore      = 0.040;           % [m]
p.d_rod       = 0.020;           % [m]
p.A_p         = pi*(p.d_bore^2)/4;
p.A_rm        = pi*(p.d_rod^2)/4;
p.A_r         = p.A_p - p.A_rm;
p.V_dead      = 50e-6;           % [m^3]

p.Ps          = 207e5;           % [Pa]
p.Pr          = 0;               % [Pa]
p.beta_e      = 1.4e9;           % [Pa]
p.rho         = 850;             % [kg/m^3]
p.C_ip        = 5e-12;           % [m^3/(s*Pa)]

p.Kq          = 0.20;            % [m^3/(s*m)]
p.Kc          = 1.0e-11;         % [m^3/(s*Pa)]
p.xv_max      = 1e-3;            % [m]
p.dxv_max     = 0.04;            % [m/s]

p.wv          = 2*pi*200;        % [rad/s]
p.zv          = 0.7;
p.Kv          = 1.0e-4;          % [m/V]

p.m           = 6.0;             % [kg]
p.Bv          = 1200;            % [N*s/m]
p.Fc          = 200;             % [N]
p.v_stribeck  = 0.01;            % [m/s]
p.Kx          = 0.0;             % [N/m]
p.k_end       = 2e6;             % [N/m]
p.c_end       = 2e3;             % [N*s/m]

p.Fload_fun   = @(t,x,xd) 0.0;

p.ctrl.Kp     = 60.0;            % [V/m]
p.ctrl.Kd     = 10.0;            % [V/(m/s)]
p.ctrl.umax   = 10.0;            % [V]

p.sensor.bias = 0.0;
p.sensor.sigma= 0.0;

p.faults.supply_drop_time = -1;
p.faults.supply_drop_factor = 0.6;
p.faults.leak_increase_time = -1;
p.faults.leak_increase_factor = 8.0;
p.faults.jam_time = -1;
p.faults.sensor_bias_time = -1;
p.faults.sensor_bias_value = 1e-3;
end
