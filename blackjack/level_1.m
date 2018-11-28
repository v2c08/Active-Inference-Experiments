function MDP = level_1()

T = 3;

% States - Control Factor 
B{1} = zeros(22,22,2);   % Player Hand under hit/stay actions

for i = 1:size(B{1},1)
    for j = 1:size(B{1},2)
        if i > j                                     % Only allow transitions that increase hand value
            B{1}(i ,j, 1) = 1 / (size(B{1},2) - j);  % Normalize pobability over remaining allowable states
        end
    end
end
B{1}(:,:,1) = eye(22); % Player hand under no action 
b{1} = zeros(22,22,2) + 1/22;


%B{2} = eye(22);     % Dealer Hand

U(1,1,1) = 1;
U(1,2,1) = 2;
U(1,1,2) = 1;
U(1,2,2) = 2;


A{1} = eye(22);   % Player Hand 
a{1} = zeros(22) + 1/22;
A{2} = eye(22);   % Dealer Hand
a{2} = zeros(22) + 1/22;

MDP.T = T;                      % Number of moves
MDP.U = U;                      % Allowable policies
MDP.A = A;                      % Observation model
MDP.a = A;                      % Concentration parameters for A
MDP.B = B;                      % Transition probabilities
MDP.b = B;                      % Concentration parameters for B

end
