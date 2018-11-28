% Set-up
% Define intiial states of both hierarchal levels

% base = 'http://127.0.0.1:5000';
% client = gym_http_client(base);
% env_id = 'Blackjack-v0';
% instance_id = client.env_create(env_id);

clear all
base = 'http://127.0.0.1:5000';
client = gym_http_client(base);
env_id = 'Blackjack-v0';
instance_id = client.env_create(env_id);

MDP = level_3();
MDP = spm_MDP_check(MDP);
MDP.MDP = level_2();
           %C P D
MDP.link = [0 1 0; 0 0 1]; % Dealer HAnd
           
MDP = spm_MDP_check(MDP);
MDP.MDP.MDP = level_1();
MDP.MDP.link = [0 1];
            

MDP = spm_MDP_check(MDP);


nE = 50000; % Number of games
for i = 1:nE
    
    done  = 0;
    action_index = 0;
        
    MDP = reset_environment(MDP, client, instance_id);
    
    MDP = spm_MDP_VB_X(MDP);
    
    save('after_reset.mat', 'MDP')
    
    while ~done  % Play
        action_index = action_index + 1;
        action = MDP.mdp(1).mdp.u;
        [MDP, state, outcome, done] = step(MDP, client, instance_id, action, action_index);       

        actions(action_index) = action + 1;
        MDP = spm_MDP_VB_X(MDP);
        save('after_state.mat', 'MDP')
    end
    
    MDP = game_outcome(MDP, outcome, state);
    
    save('after_outcome.mat', 'MDP')
    
    save('done', 'MDP')
    MDP = spm_MDP_VB_X(MDP); % Learn
    state

    
    if mod(i, 1000) == 0
       save(['done_' num2str(i)], 'MDP') 
    end
    clearvars outcome state actions MDP.mdp
    
end
        
        
