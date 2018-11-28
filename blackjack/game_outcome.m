function MDP = game_outcome(MDP, outcome, state)

    % level 3
    
    % Outcomes 
    % --------
    % 1 - Draw / In play - not possible
    % 2 - Draw / Same Sum  x
    % 3 - Win  / Dealer Bust  x
    % 4 - Win  / Player Win x
    % 5 - Lose / Player Bust x
    % 6 - Lose / Dealer Win x
    % MDP.o(G,T)            - vector of outcome     - for each outcome modality

    switch outcome(end)
        
        case 1 %blackjack
            
            MDP.o(1,2) = 4; 
            
        case 2 % win 
            
            if ((state(1) > state(2)) && (state(2) < 21)) || state(2) == 21 % Player Win
                MDP.o(1,2) = 4;
            elseif (state(2) > 21) && (state(1) < 21) % Dealer Bust
                MDP.o(1,2) = 3;
            end
            
        case 3  % lose 

            if state(1) > 21 % Player Bust 
                MDP.o(1,2) = 5;
            elseif ((state(1) < state(2)) &&  (state(1) < 21 && state(2) < 21)) || state(2) == 21 % Dealer Win
                MDP.o(1,2) = 6;
            end
            
        case 4 % draw

            if (state(1) == state(2)) && (state(1) < 21 && state(2) < 21) % Same Sum
               MDP.o(1,2) = 2; 
            end
            
    end
    
    
    MDP.o(2,2) = state(1);
    MDP.o(3,2) = state(2);
    MDP.o
    assert(all(all(MDP.o)))

    % MDP.s(F,T)            - vector of true states - for each hidden factor
    MDP.s(1,2) = state(1);
    MDP.s(2,2) = state(2);

end
