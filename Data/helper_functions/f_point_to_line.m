function d = f_point_to_line(pt, v1, v2)

a = v1 - v2;
b = pt - v2;
d = norm(cross(a,b)) / norm(a);

end