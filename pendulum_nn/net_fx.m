function f = net_fx(x,v,P)


load net
wb = spm_vec(P);
wb = wb(1:25)';

net = setwb(net,wb); % set weights/biases using DEM estimates
f(1) = x(1) + x(3);
f(2) = x(2) + x(3);
f(3) = net(x);

end