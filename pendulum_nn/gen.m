function f = gen(x,v,a,P)

max_speed=8;
max_torque=2.;

a = tanh(a) * max_torque;

ct        = x(1);
st        = x(2);
th        = atan2(st, ct);
thdot     = x(3);

dt=.05;
g = 10;
m = 1.;
l = 1.;

newthdot = thdot + (-3*g/(2*l) * sin(th + pi) + 3./(m*l^2)*a) * dt;

if newthdot > max_speed
    newthdot = max_speed;
end
if newthdot < -max_speed 
    newthdot = -max_speed;
end

newth = th + newthdot*dt;
f(1) = cos(newth) - x(1);
f(2) = sin(newth) - x(2);
f(3) = newthdot - thdot;

end