function [polyY, polyX] = get_poly(x, y, width, height)

xLeft   = x%x - width/2;
yBottom = y%y - height/2;

poly1 = [xLeft yBottom];
poly2 = [xLeft+ width yBottom];
poly3 = [xLeft + width yBottom+height];
poly4 = [xLeft yBottom + height];
polyY = [poly1(1) poly2(1) poly3(1) poly4(1)];
polyX = [poly1(2) poly2(2) poly3(2) poly4(2)];

end



