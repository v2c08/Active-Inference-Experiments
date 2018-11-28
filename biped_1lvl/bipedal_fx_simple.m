function f = bipedal_fx_simple(x,v,a,P)
learn_ = 0.1;
g = 0.98 % learn;

scale = 30;
leg_w = 8/scale;
leg_h = 34/scale;

% link lengths
L_torso = 17 / scale;
L_fem   = leg_h /2;
L_tib   = leg_h /2;

% link masses
torso_mass = learn_;
femur_mass = leg_w / 2 * leg_h / 2 % dentisy = 1;
tibia_mass = (0.8*leg_w /2) * leg_h / 2;

M_fem = femur_mass;
M_tib = tibia_mass;

% link inertias
MY_torso  = 2.5; % probably wrong
MZ_torso  = 2.5; % probably wrong
MZ_fem    = 2.5; % probably wrong
MZ_tib    = 2.5; % probably wrong


q  = [x(5) x(7) x(9)  x(11) x(1)]';%'
dq = [v(1) v(2) v(3) v(4) x(2)]';%'

T = [ 1   0   0   0   1;
      0   1   0   0   1;
      1   0   1   0   1;
      0   1   0   1   1;
      0   0   0   0   1];

% old absolute coordinates in terms of relative coords
q_new  = inv(T)*q;
dq_new = inv(T)*dq;

q_fem1  = q_new(1);
q_fem2  = q_new(2);
q_tib1  = q_new(3);
q_tib2  = q_new(4);
q_torso = q_new(5);
dq_fem1  = dq_new(1);
dq_fem2  = dq_new(2);
dq_tib1  = dq_new(3);
dq_tib2  = dq_new(4);
dq_torso = dq_new(5);

% hip and knee positions
p_hip  = L_fem*[sin(q_fem1); -cos(q_fem1)] + L_tib*[sin(q_tib1); -cos(q_tib1)]';%'
p_knee1 = p_hip + L_fem*[-sin(q_fem1); cos(q_fem1)];
p_knee2 = p_hip + L_fem*[-sin(q_fem2); cos(q_fem2)];

% hip and knee velocities
v_hip   = 1;
v_knee1 = p_knee1 * v(1);
v_knee2 = p_knee2 * v(2);

f(1) = x(1);
f(2) = x(2);
f(3) = x(3);
f(4) = x(4);
f(5)  = x(6);
f(6)  = v_hip;
f(7)  = x(8);
f(8)  = v_knee1;
f(9)  = x(10);
f(10) = v_hip;
f(11) = x(12);
f(12) = v_knee2;

f = f' * 1/2;
