
function u = pfca_controller(~, y, ydot, r, p)
%PFCA_CONTROLLER  PD inner-loop with saturation.
e = r - y;
u = p.ctrl.Kp*e - p.ctrl.Kd*ydot;
u = max(min(u, p.ctrl.umax), -p.ctrl.umax);
end
