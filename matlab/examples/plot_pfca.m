
function plot_pfca(out)
%PLOT_PFCA  Plots: position, pressures, spool, flow proxy.
t = out.t;
figure('Name','Position'); plot(t,out.xp*1e3,'LineWidth',1.4); hold on; plot(t,out.r*1e3,'--','LineWidth',1.2);
grid on; xlabel('Time [s]'); ylabel('Position [mm]'); legend('x','r');

figure('Name','Pressures'); plot(t,(out.pA-out.p.Pr)*1e-5,'LineWidth',1.4); hold on; plot(t,(out.pB-out.p.Pr)*1e-5,'LineWidth',1.4);
grid on; xlabel('Time [s]'); ylabel('Gauge Pressure [bar]'); legend('p_A','p_B');

figure('Name','Valve Spool'); plot(t,out.xv*1e3,'LineWidth',1.4); grid on; xlabel('Time [s]'); ylabel('x_v [mm]');

QL = out.p.Kq*out.xv - out.p.Kc*(out.pA - out.pB);
figure('Name','Load Flow Proxy'); plot(t,QL*1e6,'LineWidth',1.4);
grid on; xlabel('Time [s]'); ylabel('Q_L [cm^3/s]');
end
