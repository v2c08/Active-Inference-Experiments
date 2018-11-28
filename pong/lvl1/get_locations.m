function [v, locations] = get_locations(fl, v, locations)

    pixel_data = rgb2gray(fl.image);
    [c, s] = wavedec2(pixel_data,5,'haar');
    init_ball_radius = 2;
    
    for h = 1:5

        [ho, ve, ob] = detcoef2('all',c,s,h);
        scale =  2^h;   

        newBX = linspace(-0.785  * (1/scale), 0.785  * (1/scale), 384  * (1/scale));  
        newBY = linspace(-0.895  * (1/scale), 0.895  * (1/scale), 240  * (1/scale)); 

        newP0X = linspace(-0.8   * (1/scale), 0.785   * (1/scale), 80   * (1/scale));
        newP0Y = linspace(-0.895 * (1/scale), 0.895  * (1/scale), 240  * (1/scale)); 

        newP1X = linspace(-0.8   * (1/scale), 1.3    * (1/scale), 80   * (1/scale)); 
        newP1Y = linspace(-0.895 * (1/scale), 0.895  * (1/scale), 240  * (1/scale)); 

        ball_radius = init_ball_radius * ((pi/2)/scale); % 1 / scale

        bx  = (fl.bx  * (1/scale)) * -1;
        by  =  fl.by        * (1/scale);

        p0x = (fl.p0x * (1/scale)) * -1;
        p0y =  fl.p0y       * (1/scale);

        p1x = (fl.p1x * (1/scale)) * -1 ;
        p1y =  fl.p1y       * (1/scale);

        [~, bx_index]  = min(abs((newBX  .* (1/scale)) - (bx  * (1/scale))));
        [~, by_index]  = min(abs((newBY  .* (1/scale)) - (by  * (1/scale))));

        [~, p0x_index] = min(abs((newP0X .* (1/scale)) - (p0x * (1/scale))));
        x_buffer       = 312 * (1/scale);
        p0x_index      = p0x_index + x_buffer;
        [~, p0y_index] = min(abs((newP0Y .* (1/scale)) - (p0y * (1/scale))));

        [~, p1x_index] = min(abs((newP1X .* (1/scale)) - (p1x * (1/scale))));
        [~, p1y_index] = min(abs((newP1Y .* (1/scale)) - (p1y * (1/scale))));

        width  = 16 * (1/scale);
        height = 42 * (1/scale);

        p0xLeft   = p0x_index - width/2;
        p0yBottom = p0y_index - height/2;
        p1xLeft   = p1x_index - width/2;
        p1yBottom = p1y_index - height/2;

        p0poly1 = [p0xLeft p0yBottom];
        p0poly2 = [p0xLeft+ width p0yBottom];
        p0poly3 = [p0xLeft + width p0yBottom+height];
        p0poly4 = [p0xLeft p0yBottom + height];
        p0polyY = [p0poly1(1) p0poly2(1) p0poly3(1) p0poly4(1)];
        p0polyX = [p0poly1(2) p0poly2(2) p0poly3(2) p0poly4(2)];

        p1poly1 = [p1xLeft p1yBottom];
        p1poly2 = [p1xLeft+ width p1yBottom];
        p1poly3 = [p1xLeft + width p1yBottom+height];
        p1poly4 = [p1xLeft p1yBottom + height];
        p1polyY = [p1poly1(1) p1poly2(1) p1poly3(1) p1poly4(1)];
        p1polyX = [p1poly1(2) p1poly2(2) p1poly3(2) p1poly4(2)];
        
        for y = 1:size(pixel_data,1) * ( 1/scale)
            for x = 1:size(pixel_data,2) * ( 1/scale)
                if any(inpolygon(x,y,p0polyY, p0polyX))                    
                    label = 1;
                elseif any(inpolygon(x,y,p1polyY, p1polyX))                     
                    label = 2;
                elseif ((x-bx_index)^2 + (y-by_index)^2) <= ((ball_radius)^2) 
                    label = 3;
                else
                    label = NaN;
                end
                
                locations{h}{y,x} = label;
                v{h}{y,x}         = [ho(y, x) ob(y,x) ve(y,x)];   
                
            end   
        end 
    end
end
    