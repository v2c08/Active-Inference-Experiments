function [MDP] = reset_environment(MDP, client, instance_id)

    ob = client.env_reset(instance_id);           % Reset the game
    try 
        ob_c = ob{1};
        ob = [ob_c{1} ob_c{2} ob_c{3}];         % linux
    catch 
        ob = [ob{1} ob{2}(end) ob{3}];         % windows
    end

    if ob(1) > 21
        ob(1) = 22;
    end
    
    ob
    
    % Level 3
    MDP.D{1} = zeros(22,1);                   % Reset prior on F1
    MDP.D{2} = zeros(22,1);                   % Reset prior on F2
    MDP.D{1}(ob(1))    = 1;                   % Update prior on F1
    MDP.D{2}(ob(2))    = 1;                   % Update prior on F2
    
   % MDP.s(F,T) - vector of true states - for each hidden factor
    MDP.s(1,1) = ob(1);
    MDP.s(2,1) = ob(2);
    %MDP.s(3,1) = 1; % Draw outcome
    
    % MDP.o(G,T)  - vector of outcome     - for each outcome modality
    MDP.o(1,1) = 1; % Draw outcome
    MDP.o(2,1) = ob(1);
    MDP.o(3,1) = ob(2);    
    
    % Level 2
    
    MDP.MDP.D{1} = zeros(22,1);                   % Reset prior on F1
    MDP.MDP.D{2} = zeros(22,1);                   % Reset prior on F2
    
    MDP.MDP.D{1}(ob(1))    = 1;                      % Update prior on F1
    MDP.MDP.D{2}(ob(2))    = 1;                      % Update prior on F2    

   % MDP.s(F,T)            - vector of true states - for each hidden factor
    MDP.MDP.s(1,1) = ob(1);
    MDP.MDP.s(2,1) = ob(2);    
    
    % MDP.o(G,T)            - vector of outcome     - for each outcome modality
    MDP.MDP.o(1,1) = ob(1);
    MDP.MDP.o(2,1) = ob(2);
    
    % Level 3
    
    MDP.MDP.MDP.D{1} = zeros(22,1);                   % Reset prior on F1
    MDP.MDP.MDP.D{2} = zeros(22,1);                   % Reset prior on F2    
    MDP.MDP.MDP.D{1}(ob(1))    = 1;                      % Update prior on F1
    MDP.MDP.MDP.D{2}(ob(2))    = 1;                      % Update prior on F2    

   % MDP.s(F,T)            - vector of true states - for each hidden factor
    MDP.MDP.MDP.s(1,1) = ob(1);
    MDP.MDP.MDP.s(2,1) = ob(2);    
    MDP.MDP.MDP.s(3,1) = ob(3)+1;    
    
    % MDP.o(G,T)            - vector of outcome     - for each outcome modality
    MDP.MDP.MDP.o(1,1) = ob(1);
    MDP.MDP.MDP.o(2,1) = ob(2);


end