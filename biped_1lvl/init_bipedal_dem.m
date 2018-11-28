function init_bipedal_dem(Y, v, a, nY, nV, nA, nT, vnoise, x1, x2)

% sanitize inputs
Y  =  reshape(Y,  [nY,nT]); % x
v  =  reshape(v,  [nV,nT]); % v
a  =  reshape(a,  [nA,nT]); % v
x1 =  reshape(x1, [8, nT]);
x2 =  reshape(x2, [4, nT]);

save('real_data.mat', 'Y', 'v', 'a')
P = struct;
M = struct;
G = struct;

% generative model
%==========================================================================
clear P
M(1).E.n = 4;
M(1).E.d = 2;
M(1).E.dt = 1/50;

% parameters of generative model
%--------------------------------------------------------------------------

P.leg_h = 1;
P.g     = 1;
P.torso_mass = 1;
P.M31 = 1;
P.M52 = 1;
P.lc1 = 1;

np      = length(spm_vec(P));
ip      = find(spm_vec(P));                  % free param ind
%ip = [7]
pC      = sparse(ip,ip,exp(8),np,np);
%pC      = speye(np);
M(1).pE = P;
M(1).pC = pC;

pP.leg_h = 1;
pP.g     = 1;
pP.torso_mass = 1;
pP.M31 = 1;
pP.M52 = 1;
pP.lc1 = 1;
pP.hull_density = 5;

DEM.pP.P = pP;

% level 1
%--------------------------------------------------------------------------
M(1).x  = Y(:,1);
M(1).f  = 'alternative_kinematics';
M(1).g  = 'bipedal_gx';
M(1).V  = exp(8);                           % error precision
M(1).W  = exp(8);                           % error precision

% level 2
%--------------------------------------------------------------------------
M(2).v  = Y(:,1);                                % inputs
M(2).V  = exp(16);
M       = spm_DEM_M_set(M);


C = load('walking_data.mat');
C = C.obs';
C = C(1:14,:);
DEM.U   = C;
DEM.C   = C;
DEM.Y   = Y;
DEM.M   = M;

DEM = spm_DEM(DEM);
DEM.pU.v  = v(:,1);
DEM.pU.x  = Y(:,1);


%spm_DEM_qU(DEM.qU,DEM.pU);
figure
subplot(2,2,1)
plot(Y')
title('True States')
subplot(2,2,3)
plot(DEM.qU.x{1}')
title('Hidden States')
subplot(2,2,2)
plot(a')
title('True Causes')
subplot(2,2,4)
plot(DEM.qU.v{1}')
title('Hidden Causes')

figure
spm_DEM_qU(DEM.qU)
% parameters
%--------------------------------------------------------------------------

qP    = spm_vec(DEM.qP.P);
qP    = qP(ip);
tP    = spm_vec(DEM.pP.P);
tP    = tP(ip);
subplot(2,2,4)
bar([tP qP])
axis square
legend('true','DEM')
title('parameters','FontSize',16)


figure
for i = 1:length(Y(:,1))

  real = Y(i,:);
  predicted = DEM.qU.x{1};
  predicted = predicted(i,:);
  pmse(i) = 1 / length(Y) * sum((real - predicted).^2);
end

bar(pmse)

end
