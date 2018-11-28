function v = gx_pong(x,v,a,P)
    
    v(1) = x(3) - x(11);       % bx - px 
    v(2) = (x(1) - x(9)) + a;  % by - py

end