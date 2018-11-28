function v = gx_sample_image(x,v)

% v = colour image from roboschool 

% v.h = object of interest
% x(1:2) = occulomotor angle [xy]
% x(3)  = acuity 

% This is the observation function for both G & M
% justification for calc_likelihood happening here is that this sort of 
% simple obect detection occurs early in the visual pathway -- 
% any unsupervised/realtime/variational updates to the mvgaussians /
% inference model should be done in fx 

% redux & wavedec
pixel_data = rgb2gray(fl.image);
[c, s] = wavedec2(pixel_data,5,'haar');

% may produce nans, if this becomes a problem check get_coefficients.m
for h = 1:5
    [ho, ve, ob] = detcoef2('all',c,s,h);    
    for y = 1:size(ho,1)
        for x = 1:size(ho,2)
            obs{h}{y,x} = [ho(y, x) ob(y,x) ve(y,x)];    
        end 
    end
end 


x = STIM.FOCUS(x);
% (x == 0) =  1;
v.x = STIM.SAMPLE(obs,x);

end