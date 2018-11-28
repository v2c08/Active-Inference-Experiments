function MDP = level_3()

    T = 1;

    % Categorization / Feedback
    A{1} = zeros(6,22,22);  % Outcome x Dealer Hand (row) x Player Hand (column)
    a{1} = zeros(6,22,22) + 1/6;
    % 1 - Draw / In play 
    A{1}(1,1:end-2,1:end-2) = eye(22 - 2);

    % 2 - Draw / Same Sum 
    A{1}(1,:,:) = eye(22);

    % 3 - Win  / Dealer Bust 
    A{1}(3,22,:) = 1;

    % 4 - Win  / Player Win
    A{1}(4,:,:)   = triu(ones(22),1);
    A{1}(4,end,:) = 0;   % no one bust 
    A{1}(4,:,  end) = 0; % no one bust

    % 5 - Lose / Player Bust
    A{1}(5,:,22) = 1;

    % 6 - Lose / Dealer Win 
    A{1}(6, :,   :)   = triu(ones(22),1)';
    A{1}(6, end, :) = 0;   % no one bust 
    A{1}(6, :,   end) = 0; % no one bust

    for i = 1:22
        A{2}(:,:,i) = eye(22); % Player Hand  (Obs == Hidden State)
        a{2}(:,:,i) = zeros(22) + 1/22;
        A{3}(:,:,i) = eye(22); % Dealer Hand (Obs == Hidden State)
        a{3}(:,:,i) = zeros(22) + 1/22;
    end
    
    B{1}(:,:) = eye(22);
    b{1}      = zeros(22) + 1/22;
    B{2}(:,:) = eye(22);
    b{2}      = zeros(22) + 1/22;
    
    C{1} = [0 1 2 5 -3 -1]';    
    C{2} = ones(22,1);
    C{3} = ones(22,1);
    
    D{1} = zeros(22,1);
    D{2} = zeros(22,1);
   


    MDP.A = A;
    MDP.a = A;
    MDP.B = B;
    MDP.b = B;
    MDP.C = C;
    MDP.D = D;
    MDP.T = T;

end