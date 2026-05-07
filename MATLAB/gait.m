function [x,y,z] = gait(t,T,f,groundPercent,angle,xOffset,zOffset)
%GAIT returns xyz returns the gait based on the given parameters

L = 500;
r = 200;

num_points = T * f;
if t < (groundPercent * num_points)
    s = t/(groundPercent * num_points);
    pathPosition = -L/2 + L*(10*s^3 - 15*s^4 + 6*s^5);
elseif t < num_points 
    s = (t-groundPercent * num_points)/((1 - groundPercent) * num_points);
    pathPosition = L/2 - L*(10*s^3 - 15*s^4 + 6*s^5);
else 
  disp("Not valid t value")
end

if t < (groundPercent * num_points)
    x = xOffset - pathPosition * sind(angle);
    y = pathPosition * cosd(angle);
    z = zOffset;
elseif t < num_points 
    x = xOffset - pathPosition * sind(angle);
    y = pathPosition * cosd(angle);
    z = zOffset + r * cos(pi*pathPosition/L);
else 
    x = NaN;
    y = NaN;
    z = NaN;
end

