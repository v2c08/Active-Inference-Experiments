function f = rec(x,v,a,P,ext)

max_speed=8;
max_torque=2.;

if nargin == 3
    P    = a;
    a    = 0;
end

a = tansig(a) * 2;

th = atan2(x(2),x(1)); % cos(t) = x & sin(t) = y

thdot     = x(3);

dt = 0.05;
g  = P.g;
m  = P.m;
l  = P.l;

newthdot = thdot + (-3*g/(2*l) * sin(th + pi)  + 3./(m*l.^2)*a) * dt;
newth = th + newthdot * dt;

if newthdot > max_speed
    newthdot = max_speed;
end
if newthdot < -max_speed
    newthdot = -max_speed;
end

f(1) = cos(newth);
f(2) = sin(newth);
f(3) = newthdot;


end
