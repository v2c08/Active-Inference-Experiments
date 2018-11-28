function MDP = level_2()

% Proprioceptive level - handles semantic beliefs about observations
% (available ace & potential dealer hand)

T = 3;

% States - Control Factor 
B{1} = zeros(22,22,2);   % Player Hand under hit/stay actions
B{1}(:,:,1) = eye(22); % no available ace
B{1}(:,:,2) = eye(22);
for i = 1:22
    if i > 13 
        B{1}(i, i,   2) = 0.5;
        B{1}(i, i-11,2) = 0.5; % Treat avaiable ace as 1 after 13 
    end
end

b{1} = zeros(22,22,2) + 1/22;


B{2} = zeros(22,22,2);
% This explicitly encodes the notion that if the dealer has >= 16, it will
% not increase
for i = 1:size(B{2},1)
    for j = 1:size(B{2},2)
        if i > j                                     % Only allow transitions that increase hand value
            B{2}(i ,j, 1) = 1 / (size(B{2},2) - j);  % Normalize pobability over remaining allowable states
        end
    end
end

B{2}(:,:,2) =  B{2}(:,:,1);
B{2}(16:end,16:end,2) = eye(22-15); % Stay at 16
B{2}(22,22,1) = 1;

b{2} = zeros(22,22,2) + 1/22;


U(1,1,:) = [1 1]';
U(1,2,:) = [1 2]';
U(1,3,:) = [2 1]';
U(1,4,:) = [2 2]';

for i = 1:22
    A{1}(:,:,i) = eye(22);   % Player Hand     (obs,hiddenstate there, hiddenstate here)
    a{1}(:,:,i) = zeros(22) + 1/22;
    A{2}(:,:,i) = eye(22);   % Dealer Hand     (obs,hiddenstate there, hiddenstate here)
    a{2}(:,:,i) = zeros(22) + 1/22;
end

MDP.T = T;                      % Number of moves
MDP.U = U;                      % Allowable policies
MDP.A = A;                      % Observation model
MDP.a = A;                      % Concentration parameters for A
MDP.B = B;                      % Transition probabilities
MDP.b = B;                      % Concentration parameters for B

end
