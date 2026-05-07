x = -500:5:500;
y = -500:5:500;
z = -500:5:500;

thetaMin = -90;  thetaMax = 90;
alphaMin =  -90;  alphaMax = 135;
betaMin = 5;  betaMax = 90;

maxPts = length(x)*length(y)*length(z);
xv = zeros(maxPts,1);
yv = zeros(maxPts,1);
zv = zeros(maxPts,1);
n = 0;

for ix = 1:length(x)
    for iy = 1:length(y)
        for iz = 1:length(z)

            [theta, alpha, beta] = inverseKinematics(x(ix),y(iy),z(iz));
            if mod(z(iz),100) == 0
                disp([x(ix), y(iy), z(iz)])
            end

            if isnan(theta) || isnan(alpha) || isnan(beta)
                continue
            end

            if ~isreal(theta) || ~isreal(alpha) || ~isreal(beta)
                continue
            end

            if theta >= thetaMin && theta <= thetaMax && ...
               alpha >= alphaMin && alpha <= alphaMax && ...
               beta  >= betaMin  && beta  <= betaMax

                n = n + 1;
                xv(n) = x(ix);
                yv(n) = y(iy);
                zv(n) = z(iz);
            end
        end
    end
end

% Trim unused space
xv = xv(1:n);
yv = yv(1:n);
zv = zv(1:n);
figure
scatter3(xv, yv, zv, 10, 'filled')
xlabel('X')
ylabel('Y')
zlabel('Z')
grid on
axis equal
title('Points satisfying all conditions')