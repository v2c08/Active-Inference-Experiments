function test_models()

gaus  = load('gaussians.mat');
mu    = gaus.mu;
sigma = gaus.sigma;
rho   = gaus.rho;

init_height = 240; % 128
init_width  = 384; % 256

Data_Test = {{} {} {}}; % every c
for c = 1:3
   Data_Test{c} = {{} {} {} {} {}} ; % every h 
   for h=1:length(Data_Test{c})
       scale = 2^h;
       Data_Test{c}{h}   = cell(round([init_height init_width] * 1/scale));
       location_init{h}  = cell(round([init_height init_width] * 1/scale));
       v_init{h}         = cell(round([init_height init_width] * 1/scale));
   end
end

test_cases = 240;

ball   = zeros(2,test_cases);
p0     = zeros(2,test_cases);
p1     = zeros(2,test_cases);
h_     = zeros(1,test_cases);
u_     = zeros(2,test_cases);
height = zeros(1, test_cases);
width  = zeros(1,test_cases);

for mf = 1:test_cases

    fl = load(['test_images/' num2str(mf) '.mat']);


    % randomly select h and get appriate u 
    h = randi([1 5],1);
    

    u1 = randi([1 round(init_height * (1 / (2^h)))],1);
    u2 = randi([1 round(init_width  * (1 / (2^h)))],1);
    u  = [u1 u2];

    % empty & preallocate
    locations = location_init;
    v         = v_init;
    % load actual locations from mats
    [v, locations] = get_locations(fl, v, locations);


    % this works - just commented out to grab random data
%     % get ball location 
%     [p1y, p1x] = find((cell2mat(locations{h}) == 3));
%     u = [p1y(ceil(end/2),:), p1x(ceil(end/2),:)];

    
    % x/y index of physical location of xyh=1for each h 
    w = round([[u(1),    u(2)]
               [u(1)/2,  u(2)/2]
               [u(1)/4,  u(2)/4]   
               [u(1)/8,  u(2)/8]   
               [u(1)/16, u(2)/16]]);

    w(w==0) =  1;
    % haar pyramid
    obs =     [[v{1}{w(1)}]
               [v{2}{w(2)}]
               [v{3}{w(3)}]
               [v{4}{w(4)}]
               [v{5}{w(5)}]];

    % pass v, h, u to calc_likelihoods
    [mvdensity, l] = calc_likelihood(obs, h, u, mu, sigma, rho);
    
    % For Blender 
    ball(1,mf) = fl.by;
    ball(2,mf) = fl.bx;
    p0(1,mf)   = fl.p0y;
    p0(2,mf)   = fl.p0x;
    p1(1,mf)   = fl.p1y;
    p1(2,mf)   = fl.p1x;
    u_(1,mf)   = u(1);
    u_(2,mf)   = u(2);

    % plot likelihood 
end 

save('test_data.mat', 'ball', 'p0', 'p1', 'h_', 'u_')