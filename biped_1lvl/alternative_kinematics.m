function f = alternative_kinematics(x,v,P)


%https://github.com/openai/gym/wiki/BipedalWalker-v2

%  state = [
%            self.hull.angle,        # Normal angles up to 0.5 here, but sure more is possible.
%            2.0*self.hull.angularVelocity/FPS,
%            0.3*vel.x*(VIEWPORT_W/SCALE)/FPS,  # Normalized to get -1..1 range
%            0.3*vel.y*(VIEWPORT_H/SCALE)/FPS,
%            self.joints[0].angle,   # This will give 1.1 on high up, but it's still OK (and there should be spikes on hiting the ground, that's normal too)
%            self.joints[0].speed / SPEED_HIP,
%            self.joints[1].angle + 1.0,
%            self.joints[1].speed / SPEED_KNEE,
%            1.0 if self.legs[1].ground_contact else 0.0,
%            self.joints[2].angle,
%            self.joints[2].speed / SPEED_HIP,
%            self.joints[3].angle + 1.0,
%            self.joints[3].speed / SPEED_KNEE,
%            1.0 if self.legs[3].ground_contact else 0.0,
%
%            hull_position_x,
%            hull_position_y,
%            hull_linvel_x,
%            hull_linvel_y,
%            l0_pos_x,
%            l0_pos_y,
%            l0_linvel_x,
%            l0_linvel_y,
%            l1_pos_x,
%            l1_pos_y,
%            l1_linvel_x,
%            l1_linvel_y,
%            l2_pos_x,
%            l2_pos_y,
%            l2_linvel_x,
%            l2_linvel_y,
%            l3_pos_x,
%            l3_pos_y,
%            l3_linvel_x,
%            l3_linvel_y,
%            real_gravity,
%            velocity_iterations,
%            position_iterations
%            ]



alpha                = x(1,1);
alphadot             = x(2,1);
torso_xvel           = x(3,1);
torso_yvel           = x(4,1);
beta_l               = x(5,1);
betadot_l            = x(6,1);
gamma_l              = x(7,1);
gammadot_l           = x(8,1);
Flx                  = x(9,1);
Fly                  = x(9,1);
beta_r               = x(10,1);
betadot_r            = x(11,1);
gamma_r              = x(12,1);
gammadot_r           = x(13,1);
Frx                  = x(14,1);
Fry                  = x(14,1);

ML1 = v(1);
MR1 = v(2);
ML2 = v(3);
MR2 = v(4);



% might need to use rad2deg()
femur_upper_angle = 1.1;
femur_lower_angle = -0.8;

tibia_upper_angle = -0.1;
tibia_lower_angle = -1.6;



if beta_l > femur_upper_angle
    beta_l = femur_upper_angle;
end

if beta_r > femur_upper_angle
    beta_r = femur_upper_angle;
end

if gamma_l >  tibia_lower_angle
    gamma_l = tibia_lower_angle;
end

if gamma_r >  tibia_lower_angle
    gamma_r = tibia_lower_angle;
end

learn_ = -10;

scale = 30;
leg_w = 8/scale;
leg_h  = P.leg_h;


% link lengths
torso_length = 17 / scale;
femur_length   = leg_h /2;
tibia_length   = leg_h /2;

% link masses
hull_density = 5;
torso_mass = P.torso_mass;
femur_mass = leg_w / 2 * leg_h / 2; % density = 1;
tibia_mass = (0.8*leg_w /2) * leg_h / 2;

M_fem = femur_mass;
M_tib = tibia_mass;

% link inertias
MY_torso  = 2.5; % probably wrong
MZ_torso  = 2.5; % probably wrong
MZ_fem    = 2.5; % probably wrong
MZ_tib    = 2.5; % probably wrong

m0 = learn_; % body mass
m1 = femur_mass;
m2 = tibia_mass;

r0 = torso_length  / 2; % body_cg
r1 = femur_length  / 2;
r2 = tibia_length  / 2;

l0 = torso_length;
l1 = femur_length;
l2 = tibia_length;

g = -10;

a11 = m0 + 2 * m1 + 2 * m2;
a12 = 0;
a13 = (-2 * m1 * r0 - 2 * m2 * r0) * cos(alpha) + (-l1 * m2 - m1 * r1) * ...
      cos(alpha - beta_l) - l1 * m2 * cos(alpha - beta_r);
a14 = (l1 * m2 + m1 * r1) * cos(alpha - beta_l) + m2 * r2 * cos(alpha - beta_l + gamma_l);
a15 = (l1 * m2 + m1 * r1) * cos(alpha - beta_r) + m2 * r2 * cos(alpha - beta_l + gamma_r);
a16 = -m2 * r2 * cos(alpha - beta_l + gamma_l);
a17 = -m2 * r2 * cos(alpha - beta_r + gamma_r);

a21 = 0;
a22 = m0 + 2 * m1 + 2 * m2;
a23 = (2 * m1 * r0 + 2 * m2 * r0) * sin(alpha) + (l1 * m2 + m1 * r1) * sin(alpha - beta_l) + ...
      l1 * m2 * sin(alpha - beta_r) + m1 * r1 * sin(alpha - beta_r) + m2 * r2 * sin(alpha - beta_l + gamma_l) + ...
      m2 * r2 * sin(alpha - beta_r + gamma_r);
a24 = (-l1 * m2 - m1 * r1) * sin(alpha - beta_l) - m2 * r2 * sin(alpha - beta_l + gamma_l);
a25 = (-l1 * m2 - m1 * r1) * sin(alpha - beta_r) - m2 * r2 * sin(alpha - beta_r + gamma_r);
a26 = m2 * r2 * sin(alpha - beta_l + gamma_l);
a27 = m2 * r2 * sin(alpha - beta_r + gamma_r);

a31 = (-2 * m1 * r0 - 2 * m2 * r0) * cos(alpha) + (-l1 * m2 - m1 * r1) * cos(alpha - beta_l) - l1 * m2 * cos(alpha - beta_r) ...
       -m1 * r1 * cos(alpha - beta_r) - m2 * r2 * cos(alpha - beta_l + gamma_l) - m2 * r2 * cos(alpha - beta_r + gamma_r);

a32 = (2 * m1 * r0 + 2 * m2 * r0) * sin(alpha) + (l1 * m2 + m1 * r1) * sin(alpha - beta_l) + l1 * m2 * sin(alpha - beta_r) ...
      + m1 * r1 * sin(alpha - beta_r) + m2 * r2 * sin(alpha - beta_l + gamma_l) + m2 * r2 * sin(alpha - beta_r + gamma_r);

a33 = 2*l1^2*m2 + 2*m1*r0^2 + 2*m2*r0^2 + 2*m1*r1^2 + 2*m2*r2^2 + (2*l1*m2*r0 + ...
      2*m1*r0*r1) * cos(beta_l) + (2*l1*m2*r0 + 2*m1*r0*r1) * cos(beta_r) + ...
      2*m2*r0*r2 * cos(beta_l - gamma_l) + 2*l1*m2*r2*cos(gamma_l) + 2*m2*r0*r2*cos(beta_r ...
      - gamma_r) + 2*l1*m2*r2*cos(gamma_r);

a34 = -l1^2*m2 - m1*r1^2 - m2*r2^2 + (-l1*m2*r0 - m1*r0*r1) * cos(beta_l) ...
      -m2*r0*r2*cos(beta_l - gamma_l) - 2*l1*m2*r2*cos(gamma_l);

a35 = -l1^2*m2-m1*r1^2-m2*r2^2 + (-l1*m2*r0-m1*r0*r1) * cos(beta_r) ...
       -m2*r0*r2*cos(beta_r - gamma_r) - 2*l1*m2*r2*cos(gamma_r);

a36 = m2*r2*(r2 + r0*cos(beta_l-gamma_l)+l1*cos(beta_l));
a37 = m2*r2*(r2 + r0*cos(beta_r-gamma_r)+l1*cos(beta_r));

a41 = (l1*m2+m1*r1)*cos(alpha-beta_l)+m2*r2*cos(alpha-beta_l+gamma_l);
a42 = (-l1*m2-m1*r1)*sin(alpha-beta_l)-m2*r2*cos(alpha-beta_l+gamma_l);
a43 = -l1^2*m2-m1*r1^2-m2*r2^2+r0*(-l1*m2-m1*r1)*cos(beta_l)-m2*r0*r2*cos(beta_l - gamma_l)-2*l1*m2*r2*cos(gamma_l);
a44 = l1^2*m2+m1*r1^2+m2*r2^2+2*l1*m2*r2*cos(gamma_l);
a45 = 0;
a46 = m2*r2*(-r2-l1*cos(gamma_l));
a47 = 0;

a51 = (l1*m2+m1*r1)*cos(alpha-beta_r)+m2*r2*cos(alpha-beta_r+gamma_r);
a52 = (-l1*m2+m1*r1)*sin(alpha-beta_r)-m2*r2*cos(alpha-beta_r+gamma_r);
a53 = -l1^2*m2-m1*r1^2-m2*r2^2+r0*(-l1*m2-m1*r1)*cos(beta_r)-m2*r0*r2*cos(beta_r-gamma_r)-2*l1*m2*r2*cos(gamma_r);
a54 = 0;
a55 = l1^2*m2+m1*r1^2+m2*r2^2+2*l1*m2*r2*cos(gamma_r);
a56 = 0;
a57 = m2*r2*(-r2-l2*cos(gamma_r));

a61 = -m2*r2*cos(alpha-beta_l+gamma_l);
a62 =  m2*r2*sin(alpha-beta_l+gamma_l);
a63 = m2*r2*(r2+r0*cos(beta_l-gamma_l) + l1*cos(gamma_l));
a64 = m2*r2*(-r2-l1*cos(gamma_l));
a65 = 0;
a66 = m2*r2^2;
a67 = 0;

a71 = -m2*r2*cos(alpha-beta_r+gamma_r);
a72 =  m2*r2*sin(alpha-beta_r+gamma_r);
a73 = m2*r2*(r2+r0*cos(beta_r-gamma_r)+l1*cos(gamma_r));
a74 = 0;
a75 = m2*r2*(-r2-l1*cos(gamma_r));
a76 = 0;
a77 = m2*r2^2;

A = [a11 a12 a13 a14 a15 a16 a17;
     a21 a22 a23 a24 a25 a26 a27;
     a31 a32 a33 a34 a35 a36 a37;
     a41 a42 a43 a44 a45 a46 a47;
     a51 a52 a53 a54 a55 a56 a57;
     a61 a62 a63 a64 a65 a66 a67;
     a71 a72 a73 a74 a75 a76 a77];

b1 = -2*alphadot^2*m1*r0*sin(alpha) + Frx - betadot_r^2*m1*r1*sin(alpha - beta_r)-alphadot^2*l1*m2*sin(alpha ...
     -beta_l) + Flx - gammadot_l^2*m2*r2*sin(alpha - beta_l+gamma_l)-alphadot^2*m1*r1*sin(alpha-beta_r) ...
     -betadot_r^2*l1*m2*sin(alpha-beta_r)-alphadot^2*l1*m2*sin(alpha-beta_r)-gammadot_r^2*m2*r2*sin(alpha ...
     -beta_r + gamma_r) - betadot_l^2*m2*r2*sin(alpha-beta_l+gamma_l)-betadot_l^2*m1*r1*sin(alpha-beta_l) ...
     -betadot_r^2*m2*r2*sin(alpha-beta_r+gamma_r)-alphadot^2*m1*r1*sin(alpha-beta_l) ...
     -betadot_l^2*l1*m2*sin(alpha-beta_l)-alphadot^2*m2*r2*sin(alpha - beta_r + gamma_r) ...
     -alphadot^2*m2*r2*sin(alpha-beta_l+gamma_l)+2*alphadot*betadot_r*l1*m2*sin(alpha-beta_r) ...
     +2*betadot_r*gammadot_r*m2*r2*sin(alpha-beta_r+gamma_r)-2*alphadot*gammadot_r*m2*r2*sin(alpha-beta_r+gamma_r) ...
     +2*alphadot*betadot_l*m2*r2*sin(alpha-beta_l+gamma_l)+2*alphadot*betadot_l*m1*r1*sin(alpha-beta_l) ...
     +2*alphadot*betadot_r*m2*r2*sin(alpha-beta_r+gamma_r)+2*alphadot*betadot_l*l1*m2*sin(alpha-beta_l) ...
     -2*alphadot^2 *m2*r0*sin(alpha)+2*alphadot*betadot_r*m1*r1*sin(alpha-beta_r) ...
     +2*betadot_l*gammadot_l*m2*r2*sin(alpha-beta_l+gamma_l)-2*alphadot*gammadot_l*m2*r2*sin(alpha-beta_l+gamma_l);

b2 = -betadot_l^2*m2*r2*cos(alpha-beta_l+gamma_l)+ Fry - 2*g*m2-gammadot_r^2*m2*r2*cos(alpha-beta_r+gamma_r) ...
     -betadot_r^2*m2*r2*cos(alpha-beta_r+gamma_r)-alphadot^2*m2*r2*cos(alpha-beta_r+gamma_r) ...
     -gammadot_l^2*m2*r2*cos(alpha-beta_l+gamma_l)-alphadot^2*m1*r1*cos(alpha-beta_r) ...
     -betadot_r^2*m1*r1*cos(alpha-beta_r) - alphadot^2*(2*m1+2*m2) *r0*cos(alpha)-alphadot^2*l1*m2*cos(alpha ...
     -beta_r) - betadot_r^2*l1*m2*cos(alpha-beta_r)+ Fly - alphadot^2*m2*r2*cos(alpha-beta_l+gamma_l)-2*g*m1 ...
     +2*alphadot*gammadot_r*l1*m2*cos(alpha-beta_r)+2*betadot_r*gammadot_r*m2*r2*cos(alpha-beta_r+gamma_r) ...
     -2*alphadot*gammadot_r*m2*r2*cos(alpha-beta_r+gamma_r)+2*alphadot*betadot_r*m2*r2*cos(alpha-beta_r+gamma_r) ...
     -2*alphadot*gammadot_l*m2*r2*cos(alpha-beta_l+gamma_l)+2*betadot_l*gammadot_l*m2*r2*cos(alpha-beta_l+gamma_l) ...
     +2*alphadot*betadot_l*m2*r2*cos(alpha-beta_l+gamma_l)+2*alphadot*betadot_r*m1*r1*cos(alpha-beta_r) ...
     -(alphadot*betadot_l*(-2*l1*m2-2*m1*r1)+alphadot^2*(l1*m2+m1*r1) + betadot_l^2*(l1*m2 ...
     + m1*r1))*cos(alpha-beta_l)-g*m0;

b3 = gammadot_r^2*l1*m2*r2*sin(gamma_r)+ Fry*l2*sin(alpha-beta_r+gamma_r)-Flx*l1*cos(alpha-beta_l) ...
    -Frx*l1*cos(alpha-beta_r)-Flx*l2*cos(alpha-beta_l+gamma_l)+Fly*r0*sin(alpha)+Fry*r0*sin(alpha) ...
    +Fly*l1*sin(alpha-beta_l)+Fly*l2*sin(alpha-beta_l+gamma_l)-g*m2*r2*sin(alpha-beta_r+gamma_r) ...
    -gammadot_r^2*m2*r0*r2*sin(beta_r-gamma_r)-betadot_r^2*m2*r0*r2*sin(beta_r-gamma_r) ...
    -g*m2*r2*sin(alpha-beta_l+gamma_l)+gammadot_l^2*l1*m2*r2*sin(gamma_l) ...
    -gammadot_l^2*m2*r0*r2*sin(beta_l-gamma_l)-betadot_r^2*m1*r0*r1*sin(beta_r) ...
    -betadot_l^2*m2*r0*r2*sin(beta_l-gamma_l)-betadot_r^2*l1*m2*r0*sin(beta_r) ...
    -betadot_l^2*m1*r0*r1*sin(beta_l)-g*l1*m2*sin(alpha-beta_r)+Fry*l1*sin(alpha-beta_r)-g*m1*r1*sin(alpha * ...
    -beta_r)-g*l1*m2*sin(alpha-beta_l)-g*m1*r1*sin(alpha-beta_l) - betadot_l^2*l1*m2*r0*sin(beta_l) ...
    -(Flx * r0 + Frx*r0)*cos(alpha)-2*alphadot*betadot_l*m2*r0*r2*sin(beta_l-gamma_l) ...
    +2*betadot_l*gammadot_l*m2*r0*r2*sin(beta_l-gamma_l)+2*alphadot*betadot_l*m2*r0*r2*sin(beta_l ...
    -gamma_l) + 2 * alphadot*betadot_r*m1*r0*r1*sin(beta_r)-2*g*m2*r0*sin(alpha) ...
    +2*alphadot*gammadot_r*l1*m2*r2*sin(gamma_r)+2*alphadot*betadot_r*m2*r0*r2*sin(beta_r-gamma_r) ...
    -2*alphadot*gammadot_r*m2*r0*r2*sin(beta_r-gamma_r)+2*alphadot*gammadot_l*l1*m2*r2*sin(gamma_l) ...
    -2*betadot_l*gammadot_l*l1*m2*r2*sin(gamma_l)-2*g*m1*r0*sin(alpha) ...
    +2*alphadot*betadot_r*l1*m2*r0*sin(beta_r)+2*alphadot*betadot_l*l1*m2*r0*sin(beta_l) ...
    +2*alphadot*betadot_l*m1*r0*r1*sin(beta_l)-2*betadot_r*gammadot_r*l1*m2*r2*sin(gamma_r) ...
    +2*betadot_r*gammadot_r*m2*r0*r2*sin(beta_r-gamma_r)-Frx*l2*cos(alpha-beta_r+gamma_r);

b4 = ML1 + Flx*l1*cos(alpha-beta_l)+Flx*l2*cos(alpha-beta_l+gamma_l)-Fly*l1*sin(alpha-beta_l) ...
    +g*l1*m2*sin(alpha-beta_l)+g*m1*r1*sin(alpha-beta_l)-alphadot^2*l1*m2*r0*sin(beta_l) ...
    -alphadot^2*m1*r0*r1*sin(beta_l)-alphadot^2*m2*r0*r2*sin(beta_l-gamma_l) ...
    -2*alphadot*gammadot_l*l1*m2*r2*sin(gamma_l)+2*betadot_l*gammadot_l*l1*m2*r2*sin(gamma_l) ...
    -gammadot_l^2*l1*m2*r2*sin(gamma_l)-Fly*l2*sin(alpha-beta_l+gamma_l)+g*m2*r2*sin(alpha-beta_l+gamma_l);

b5 = MR1 + Frx*l1*cos(alpha-beta_r)+Frx*l2*cos(alpha-beta_r+gamma_r)-Fry*l1*sin(alpha-beta_r) ...
    +g*l1*m2*sin(alpha-beta_r)+g*m1*r1*sin(alpha-beta_r)-alphadot^2*l1*m2*r0*sin(beta_r) ...
    -alphadot^2*m1*r0*r1*sin(beta_r)-alphadot^2*m2*r0*r2*sin(beta_r-gamma_r) ...
    -2*alphadot*gammadot_r*l1*m2*r2*sin(gamma_r)+2*betadot_r*gammadot_r*l1*m2*r2*sin(gamma_r) ...
    -gammadot_r^2*l1*m2*r2*sin(gamma_r)-Fry*l2*sin(alpha-beta_r+gamma_r)+g*m2*r2*sin(alpha-beta_r+gamma_r);

b6 = ML2 - Flx*l2 *cos(alpha-beta_l+gamma_l)+alphadot^2*m2*r0*r2*sin(beta_l-gamma_l) ...
    -alphadot^2*l1*m2*r2*sin(gamma_l)+2*alphadot*betadot_l*l1*m2*r2*sin(gamma_l) ...
    -betadot_l^2*l1*m2*r2*sin(gamma_l)+Fly*l2*sin(alpha-beta_l+gamma_l)-g*m2*r2*sin(alpha-beta_l+gamma_l);

b7 = MR2 - Frx*l2*cos(alpha-beta_r+gamma_r)+alphadot^2*m2*r0*r2*sin(beta_r-gamma_r) ...
    -alphadot^2*l1*m2*r2*sin(gamma_r)+2*alphadot*betadot_r*l1*m2*r2*sin(gamma_r) ...
    -betadot_r^2*l1*m2*r2*sin(gamma_r)+Fry*l2*sin(alpha-beta_r+gamma_r)-g*m2*r2*sin(alpha-beta_r+gamma_r);


B = [b1;b2;b3;b4;b5;b6;b7];

R = A\B;

f(1) = x(1) + R(3);
f(2) = R(3);
f(3) = R(1);
f(4) = R(2);
f(5) = x(6) + R(4);
f(6) = R(4);
f(7) = x(8) + R(5);
f(8) = R(5);
f(9) = x(9);
f(10) = x(11) + R(6);
f(11) = R(6);
f(12) = x(13) + R(7);
f(13) = R(7);
f(14) = x(14);
f = f * 1 / 50;
