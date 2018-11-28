function [MDP, ob, outcome, done] = step(MDP, client, instance_id, action, action_index)
    
    [ob, reward, done, info] = client.env_step(instance_id, action, 0);
    try 
        ob_c = ob{1};
        ob = [ob_c{1} ob_c{2} ob_c{3}];         % linux
    catch 
        ob = [ob{1} ob{2}(end) ob{3}];         % windows
    end
    
    if ob(1) > 21
        ob(1) = 22;
    end
    
    if ob(2) > 21
        ob(2) = 22;
    end

    switch reward  % need this for lvl 3 
        case 1.5
            outcome(action_index + 1) = 1; % Blackjack 
        case -1
            outcome(action_index + 1) = 3; % Lose   
        case 0 
            outcome(action_index + 1) = 4; % Draw
        otherwise 
            outcome(action_index + 1) = 2; % Win - Difference between player & dealer hands. Will never be -1/0/1.5      
    end
    
    % Level 1
    % MDP.s(F,T) - vector of true states - for each hidden factor
    MDP.MDP.MDP.s(1,action_index+1)    = ob(1);
    MDP.MDP.MDP.s(2,action_index+1)    = ob(2);
    MDP.MDP.MDP.s(3,action_index+1)    = ob(3)+1;
    %MDP.MDP.MDP.u(1,action_index) = action+1;  
    
    % MDP.o(G,T) - vector of outcome     - for each outcome modality
    MDP.MDP.MDP.o(1,action_index+1) = ob(1);
    MDP.MDP.MDP.o(2,action_index+1) = ob(2);
    
    MDP.MDP.MDP.T = action_index+1;
    
    % Level 2
    
    MDP.MDP.s(1,action_index+1)    = ob(1);
    MDP.MDP.s(2,action_index+1)    = ob(2);
    
    MDP.MDP.o(1,action_index+1)    =  ob(1);
    MDP.MDP.o(2,action_index+1)    =  ob(2);
    MDP.MDP.T = action_index+1;
    
     if (ob(2) > MDP.MDP.MDP.s(2,action_index))
             MDP.MDP.u(2,action_index) = 2;
     else
             MDP.MDP.u(2,action_index) = 1;        
     end

    MDP.MDP.u(1,action_index)      = ob(3)+1;
   
    
   end 