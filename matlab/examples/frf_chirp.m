
function [freq, G] = frf_chirp(u_ampl, t_end)
%FRF_CHIRP  Estimate FRF with a logarithmic chirp on reference input.
% Returns frequency vector and complex gain y/u at steady state (rough).
if nargin<1, u_ampl = 0.005; end  % 5 mm amplitude
if nargin<2, t_end = 3.0; end
p = pfca_params();
w1 = 2*pi*0.5;  w2 = 2*pi*50;
chirp_fun = @(t) u_ampl * chirp(t, w1/(2*pi), t_end, w2/(2*pi), 'logarithmic');
x0 = zeros(6,1); x0(1)=p.Pr; x0(2)=p.Pr;
opts = odeset('RelTol',1e-6,'AbsTol',1e-8,'MaxStep',1e-3);
[t, x] = ode15s(@(tt,xx) pfca_ode(tt,xx,p,chirp_fun), [0 t_end], x0, opts);
y = x(:,3);
% crude FRF via FFT
N = numel(t);
dt = mean(diff(t));
Y = fft(y); U = fft(arrayfun(chirp_fun, t));
f = (0:N-1)/(N*dt);
G = Y./(U+1e-12);
freq = f(:); G = G(:);
end
