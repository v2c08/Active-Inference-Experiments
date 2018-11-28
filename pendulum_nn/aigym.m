function f = gen(x,v,a,P)

a = tansig(a) * 2;
[f, reward, done, info] = P.client.env_step(P.instance_id, a, 0);

if done || any(isnan(a))
   f = P.client.env_reset(P.instance_id); %gross
end

newth = atan2(f(2), f(1));

f(1) = cos(newth);
f(2) = sin(newth);



end