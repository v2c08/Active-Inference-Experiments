function x = fx_pong(x, v, P)

    % v - x distance between ball & paddle 
    % v - y distance between ball & paddle
    

    by   = x(1);
    byv  = x(2);
    bx   = x(3);
    bxv  = x(4);
    p0y  = x(5);
    p0yv = x(6);
    p0x  = x(7);
    p0xv = x(8);
    p1y  = x(9);
    p1yv = x(10);
    p1x  = x(11);
    p1xv = x(12);
    T    = x(13);

    %dt = (0.0165/4) * T;
    %dt = 0.0165/4;
    dt = 0.0206;
    %dt = 0.0165
    %frame_skip = 4;
    
    kd = 0.05;
    max_force = 7
%     p0x_target_v = 3 * p0xtv;
%     p0y_target_v = 3 * p0ytv;
% 
%     p1x_target_v = 3 * p0xtv;
%     p1y_target_v = 3 * p0ytv;

    
%     dt = T / frame_skip;
    
    ball_radius = 0.025;
    paddle_radius = 0.03;
    PADDLE_HEIGHT = 0.3;
    MAXBOUNCEANGLE = pi;
    
    bx_range  = [-0.9  0.9];
    by_range  = [-0.9  0.9];
    
    byv_range = [-2.50  2.50];
    bxy_range = [-2.00  2.00];
    
    p0x_range = [ bx_range(2)-(sum(abs(bx_range))/5) ; bx_range(2) ];
    p1x_range = [ bx_range(1) ; bx_range(1)+(sum(abs(bx_range))/5) ];
    
     if T ==1  % y doesn't need to be rescaled
        p0x = rescale(p0x, -1, 1, p0x_range(1),  p0x_range(2));
        p1x = rescale(p1x, -1, 1, p1x_range(1),  p1x_range(2));  % Maybe shouldn't continuously rescale?
     end
     
    new_bx = bx + (bxv * dt);
    new_by = by + (byv * dt);
    
    new_bxv  = bxv;
    new_byv  = byv;

    % hit wall (upper & lower only)
    if (new_by > 0.9 || new_by < -0.9) 
        new_by = by;
        new_byv = -byv;
    elseif (new_bx >= 0.9 || new_bx <= -0.9) 
        new_bx = bx;
        new_bxv = -bxv;
        
    elseif bx <= p1x + (ball_radius + paddle_radius) && by < (p1y + PADDLE_HEIGHT/2) && by > (p1y - PADDLE_HEIGHT/2) && bxv <0

        
        % The ball bounces off from the paddle in 90 degrees if it hits the exact center of the paddle and in 45 degrees, if it hits the edges of it.
        % The ball can bounce from the paddle between -45 and 45 degrees, in radians, this is -PI/8 -> PI / 8.

        ball_speed = sqrt(bxv * bxv + byv * byv); 
        relativeIntersectY = (p1y +(PADDLE_HEIGHT/2)) - by;        
        normalizedRelativeIntersectionY = (relativeIntersectY/(PADDLE_HEIGHT/2));
        phi = pi/4 * (relativeIntersectY - 1) - pi/8;
        bounceAngle = normalizedRelativeIntersectionY * MAXBOUNCEANGLE/2;
        new_bxv = ball_speed*cos(bounceAngle);
        new_byv = ball_speed*-sin(bounceAngle);
        
    elseif bx >= p0x - (ball_radius + paddle_radius) && by < (p0y + PADDLE_HEIGHT/2) && by > (p0y - PADDLE_HEIGHT/2)  && bxv >0

        ball_speed = sqrt(bxv * bxv + byv * byv); 
        relativeIntersectY = (p0y +(PADDLE_HEIGHT/2)) - by;        
        normalizedRelativeIntersectionY = (relativeIntersectY/(PADDLE_HEIGHT/2));
        phi = pi/4 * (normalizedRelativeIntersectionY - 1) - pi /8;
        bounceAngle = normalizedRelativeIntersectionY * MAXBOUNCEANGLE/2;
        new_bxv =  ball_speed*cos(bounceAngle);
        new_byv = new_byv + ball_speed*-sin(bounceAngle);
        
    end
    
    x(1) = x(1) - new_by;
    x(2) = x(2) - new_byv;
    x(3) = x(3) - new_bx;
    x(4) = x(4) - new_bxv;
    x(5) = x(5) - new_p0y;
    x(6) = x(6) - new_p0yv;
    x(7) = x(7) - new_p0x;
    x(8) = x(8) - new_p0xv;
    x(9) = x(9) - new_p1y;
    x(10) = x(10) - new_p1yv;
    x(11) = x(11) - new_p1x;
    x(12) = x(12) - new_p1xv;
    x(13) = 1;

end
