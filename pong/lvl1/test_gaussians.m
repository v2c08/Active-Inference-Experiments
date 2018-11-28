close all
clear all

load('trained.mat');

for c = 1:3

    mu{c} = {};
    sigma{c} = {};
    rho{c} = {};

    for h = 1:5

        mu{c}{h} = {};
        sigma{c}{h} = {};
        rho{c}{h} = {};
      
        for y = 1:size(Data_Train{c}{h},1)
            for x = 1:size(Data_Train{c}{h},2)
                if ~isempty(Data_Train{c}{h}{y,x})
                    data = [];
                    cpt  = 0;
                    for v = 1:size(Data_Train{c}{h}{y,x},1)
                        if norm(v) < 1e-16 
                            cpt = cpt + 1;
                        else
                            data = [data;Data_Train{c}{h}{y,x}(v,:)];
                        end
                    end
                    
                    if size(data,1) > 1
                        %mu{c}{h}{y,x} = mean(data,2);
                        mu{c}{h}{y,x} = mean(data);
                        sigma{c}{h}{y,x} = cov(data);
                        rho{c}{h}{y,x} = cpt / size(Data_Train{c}{h}{y, x},1);
                    else 
                        mu{c}{h}{y,x} = zeros(1,3);
                        sigma{c}{h}{y,x} = zeros(1,3);
                        rho{c}{h}{y,x} = 1;    
                    end
                    
                else
                    mu{c}{h}{y,x} = zeros(1,3);
                    sigma{c}{h}{y,x} = zeros(1,3);
                    rho{c}{h}{y,x} = 1;  
                end
                
            end
        end
    end
end
save('gaussians.mat', 'mu', 'sigma', 'rho')
