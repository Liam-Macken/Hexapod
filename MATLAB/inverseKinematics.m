function [theta,alpha,beta] = inverseKinematics(x,y,z)
%INVERSEKINEMATICS returns the angles given the x,y,z coordinates

C = 50;
F = 110;
Tx = 160;
Ty = 40;
T = sqrt(Tx^2 + Ty^2);
phi = atand(Ty/Tx);

if x == 0 
    theta = 0;
else 
    theta = atand(y/x);
end


if y ~= 0 && sind(theta) ~= 0
    i = (y/sind(theta)) - C;
elseif x ~= 0 && cosd(theta) ~= 0
    i = (x/cosd(theta)) - C;
else 
    i = x - C;
end

psi = atand(-z/i);
R = sqrt(i^2 + z^2);

beta = acosd((F^2+T^2-R^2)/(2*F*T)) + phi;

alpha = acosd((F^2+R^2-T^2)/(2*F*R)) - psi;

end

