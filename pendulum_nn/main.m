close all
base = 'http://127.0.0.1:5000';
client = gym_http_client(base);
env_id = 'Pendulum-v0';

game_instance_id = client.env_create(env_id);  % possible to create multiple instance id's here
test_instance_id = client.env_create(env_id);  % server has been seeded - these instances should be equivalent

x = client.env_reset(test_instance_id);
target = client.env_step(test_instance_id, 0, 0);

net = simplenet();
save net

wb = getwb(net);  % P = weights & biases

for i = 1:length(wb)

    P.(['wb_' int2str(i)]) = wb(i);

end

P.render      = false;
P.instance_id = game_instance_id;
P.client      = client;

np = length(spm_vec(P));
ip = 1:25;
pE      = P;
pC      = sparse(ip,ip,exp(2),np,np);
M(1).pE = pE;
M(1).pC = pC;

G(1).pE = pE;
G(1).pC = pC;


% Recognition model
%==========================================================================
% level 1
%--------------------------------------------------------------------------
M(1).f  = 'net_fx';
M(1).g  = @(x,v,P) x;
M(1).E.nE = 16;
M(1).E.nM = 24;
%M(1).xP = exp([0.02 0.02 1]);
%M(1).E.linear = 4;  % let P be dynamic
M(1).E.dt = 0.05;
M(1).E.n = 1;

% level 2
%--------------------------------------------------------------------------

% Generative model
%==========================================================================
% level 1
%--------------------------------------------------------------------------
G(1).f  = 'gen';
G(1).g  = @(x,v,a,P) x;


% level 2
%--------------------------------------------------------------------------
G(2).a = 0;                             % action forces

DEM.G   = G;
DEM.M   = M;

% Learn parameters
nT = 100;
U(1,1:nT) = 1; %cos(theta)
U(2,1:nT) = 0; %sin(theta) - balancing verticaly
U(3,1:nT) = 0; %theta_dot  - no movement
DEM.U     = U;
DEM.C     = sparse(3,nT); %%% C SHOULD BE REDUNDANT IF WE REMOVE G...


% Random starting points
for i = 1:5
    x  = client.env_reset(game_instance_id);
    DEM.G(1).x = x+ randn();
    DEM.M(1).x = x+ randn();
    DEM.G(2).v = x;
    DEM.M(2).v = x;

    %DEM = spm_ADEM(DEM, game_instance_id, client);
    DEM = spm_ADEM(DEM);
    for j = 1:length(DEM.qU.a{2})
        x = client.env_step(test_instance_id, DEM.qU.a{2}(j), 1);
    end
    DEM = spm_ADEM_update(DEM);
end


% Loosen priors & maintain balance with AI
DEM.G(1).U = exp(8);
DEM.G(1).x = [1; 0; 0.001];
DEM.M(1).x = [1; 0; 0.001];
DEM.M(1).pE = DEM.qP.P{1};
DEM.M(1).pC = [];

W     = [4 8 16 32];
for i = 1:4

    % active inference
    %----------------------------------------------------------------------
    DEM.M(1).W = exp(W(i));
    DEM        = spm_ADEM(DEM, game_instance_id);

    % true and inferred position
    %----------------------------------------------------------------------
    spm_figure('GetWin','Figure 3');
    subplot(2,2,i)
    plot(1,0,'c.','MarkerSize',64), hold on
    plot(DEM.pU.x{1}(1,:),DEM.pU.x{1}(3,:))
    plot(DEM.qU.x{1}(1,:),DEM.qU.x{1}(3,:),':'),hold off
    xlabel('position','Fontsize',14)
    ylabel('velocity','Fontsize',14)
    title(sprintf('%s (%i)','trajectories',W(i)),'Fontsize',16)
    %axis([-1 1 -1 1]*2), shading interp
    axis square

end
save('DEM', 'DEM')


% plotting
qP    = spm_vec(DEM.qP.P);
qP    = qP(ip);
tP    = spm_vec(DEM.pP.P);
tP    = tP(ip);
figure
bar([tP qP])
axis square
legend('true','DEM')
title('parameters','FontSize',16)

action = DEM.qU.a{2};

figure
subplot(1,2,1)
plot(1:1:nT,DEM.qU.x{1})
subplot(1,2,2)
plot(1:1:nT,action)
