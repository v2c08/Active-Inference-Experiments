clear all
base = 'http://127.0.0.1:5000';
client = gym_http_client(base);
env_id = 'Blackjack-v0';
instance_id = client.env_create(env_id);
MDP = load('done_3000.mat');
MDP = MDP.MDP;
nE = 100; % Number of games
outcomes = zeros(1,nE);
for i = 1:nE
    
    action_index = 0;    
    [MDP, state, outcome] = reset_environment(MDP, client, instance_id);
    MDP.T = 2;    
    done = 0;
    while ~done
        MDP = spm_MDP_VB_X(MDP);
        actions = MDP.u(1,:);
        for k = 1:length(actions)
            action_index = action_index + 1;
            action = client.env_action_space_sample(instance_id);
            [MDP, state, outcome, done] = step(MDP, client, instance_id, action, action_index, state, outcome);
            actions(action_index) = action + 1 ;
        end
    end
    
    outcomes(i) = outcome(end);
    if mod(i, 1000) == 0
       save(['done_' num2str(i)], 'MDP') 
    end
    clearvars outcome state actions
    
end
histogram(outcomes);