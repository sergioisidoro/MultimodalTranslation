function [  ] = f_draw_pie( radius, offset_x, offset_y, pie_start, pie_end, scale_fix, color )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% Klaus Förger, Department of Media Technology, Aalto University, 2013 

t = [pie_start:0.01:pie_end pie_end]' *2*pi;
x = sin(t) * scale_fix * radius + offset_x;
y = cos(t) * radius + offset_y;


if (pie_end - pie_start) > 0.9999 && (pie_end - pie_start) < 1.0001
    fill(x,y,color);
else
    fill([offset_x; x; offset_x],[ offset_y; y; offset_y ],color);
end

end

