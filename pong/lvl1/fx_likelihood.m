function x = fx_likelihood(x, v, P)
    
    coefs = x;
    h     = v.h;
    y     = v.y;
    x     = v.x;
    
    rho   = P.rho;
    sigma = P.sigma;
    mu    = P.mu;
    
    L = zeros(1,3);
    mvdensity = cell(3,1);
    y = u(1);
    x = u(2);

    for c = 1:3
        if norm(coefs) < 1e-16
            if norm(mu{c}{h}{u}) > 1e-16
                mvdensity{c} = rho{c}{h}{y,x};
                L(c) = rho{c}{h}{y,x};
            else
                mvdensity{c} = 1;
                L(c) = 1;
            end
        else
            if norm(mu{c}{h}{y,x}) > 1e-16
                try
                    mvdensity{c} = (1-rho{c}{h}{y,x}) * mvnpdf(coefs, mu{c}{h}{y,x}, sigma{c}{h}{y,x} + 1e-10);
                    L(c)       = max(mvdensity{c});
                catch
                    mvdensity{c} = (1-rho{c}{h}{y,x}) * mvnpdf(coefs, mu{c}{h}{y,x}, sigma{c}{h}{y,x} + 1e-10 * eye(3)); 
                    L(c)       = max(mvdensity{c});
                end
            else
                mvdensity{c} = 0;
                L(c) = 0;
            end
        end
        L(c) = spm_softmax(L(c), 1e-16);
    end
end