x = 233.85;
y = 0;
z = -70.712;

C = 50;
F = 120;
Tx = 180;
Ty = 40;
T = sqrt(Tx^2 + Ty^2);
phi = atand(Ty/Tx);

if y == 0 
    theta = 0;
else 
    theta = atand(x/y);
end


if y ~= 0 & cosd(theta) ~= 0
    i = (y/cosd(theta)) - C;
elseif x ~= 0 & sind(theta) ~= 0
    i = (x/sind(theta)) - C;
else 
    i = x - C;
end

psi = atand(-z/i);
R = sqrt(i^2 + z^2);

beta = acosd((F^2+T^2-R^2)/(2*F*T)) + phi;

alpha = acosd((F^2+R^2-T^2)/(2*F*R)) - psi;