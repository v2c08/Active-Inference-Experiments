function demi = roboschool_to_gridspace(x_pixels, y_pixels, N)

% where 
for c = 1:3
    for h = 1:5
        scale =  2^h;   
        x_vector = 1:x_pixels * 1/scale;
        y_vector = 1:y_pixels * 1/scale;

        point_grid = [-1:0.01:1];

        for i = 1:length(point_grid)
            for j = 1:length(point_grid)
                x_grid = find(x_vector <= point_grid(i), 1, 'last');
                y_grid = find(y_vector <= point_grid(i), 1, 'last');    
                u = [x_grid(end) y_grid(end)];
                c = [x_grid(end) y_grid(end)];
                demi.U{i,j,h,c} = u * ones(1,N);
                demi.C{i,j,h,c} = c * ones(1,N);
            end
        end        
    end
end
end 