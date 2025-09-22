
# PFCA Modeling Theory (Hydraulic EHSV + Cylinder + Mechanics)

This note summarizes the modeling used in the project. The block diagram is in `docs/figures/pfca_block_diagram.png`.

## 1) Valve + Chambers (Hydraulics)

We use a linearized 4‑way valve relation around small spool excursions:
\[
Q_L = K_q\,x_v \;-\; K_c\,(p_A - p_B),
\]
with \(Q_A = Q_L\), \(Q_B = -Q_L\). Chamber volumes:
\[
V_A = V_\text{dead} + A_p(x - x_\min), \quad
V_B = V_\text{dead} + A_r(x_\max - x).
\]
Continuity (bulk modulus \(\beta_e\), cross‑port leakage \(C_{ip}\)):
\[
\dot p_A = \frac{\beta_e}{V_A}\big(Q_A - A_p \dot x - C_{ip}(p_A - p_B)\big),\quad
\dot p_B = \frac{\beta_e}{V_B}\big(Q_B + A_r \dot x - C_{ip}(p_B - p_A)\big).
\]

## 2) Valve Servo (Electro‑mechanical)

Spool dynamics are a 2nd‑order servo tracking the commanded position \(K_v u\):
\[
\ddot x_v + 2 \zeta_v \omega_v \dot x_v + \omega_v^2 x_v = \omega_v^2 K_v u,
\]
with rate and position limits.

## 3) Mechanics

Hydraulic force on the piston:
\[
F_h = A_p p_A - A_r p_B.
\]
Stribeck‑like friction:
\[
F_f = B_v \dot x + F_c \tanh\!\left(\frac{\dot x}{v_\text{stribeck}}\right).
\]
End‑stop bumpers act as stiff springs/dampers beyond limits. Translation dynamics:
\[
m \ddot x = F_h - F_f - K_x x - F_\text{end} - F_\text{load}(t,x,\dot x).
\]

## 4) State Vector and ODE

\[
\mathbf{x} = \begin{bmatrix} p_A & p_B & x & \dot x & x_v & \dot x_v \end{bmatrix}^\top,\quad
\dot{\mathbf{x}} = f(\mathbf{x}, u).
\]

## 5) Linearization for Simulink State‑Space

A numerical Jacobian around the nominal equilibrium \((\mathbf{x}_0,u_0)\) yields:
\[
\dot{\mathbf{x}} \approx A\,\mathbf{x} + B\,u,\quad y = C\,\mathbf{x} + D\,u,
\]
which can be deployed via a **State‑Space** block in Simulink for loop‑shaping and FRF analysis.
