function level_2_MDP()


where = 1;
what  = 2;

nh = 5;

nF1 = npixels_x;
nF2 = npixels_y;
nF3 = nh;

O = {1, 2, 3};

U(1,:,1) = 1:nF1;
U(1,:,2) = 1:nF2;
U(1,:,3) = 1:nF3;

for o = 1:numel(O)
    for f3 = 1:nF3
        A{where}(o,:,:,f3) = eye(nF1(f3), nF2(f3));
    end
end

B{1}(:,:,1) = eye(nF1,nF1);
B{2}(:,:,2) = eye(nF2,nF2);
B{3}(:,:,3) = eye(nF3,nF3);

C{where} = repmat([1 1 1] * 1/3,nT)';


D{F1} = nF1/2;
D{F2} = nF2/2;
D{F3} = nF3/2;


end