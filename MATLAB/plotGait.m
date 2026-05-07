total_points = 100;
T = 5;
f = 10;

total_runs = total_points/(T*f);

t = linspace(0, total_runs*T, total_points);      % time vector

px = zeros(1, total_points);
py = zeros(1, total_points);
pz = zeros(1, total_points);

pt = zeros(1, total_points);
pa = zeros(1, total_points);
pb = zeros(1, total_points);

degt = zeros(1, total_points);
dega = zeros(1, total_points);
degb = zeros(1, total_points);


for i = 1:total_points
    p = mod(i-1,50);
    disp(p);
    [x,y,z] = gait(p,T,f,0.5,0,200,-70);
    px(i) = x;
    py(i) = y;
    pz(i) = z;
end


%% plot 3d space
figure;
plot3(px, py, pz, '.', 'MarkerSize', 15);
grid on; axis equal;
xlabel('x [mm]'); ylabel('y [mm]'); zlabel('z [mm]');
title('3D Foot Trajectory: Smooth Flat + Swing');

xlim([-400 400]); ylim([-400 400]); zlim([-400 400]);

%% --- plot velocities / accelerations ---
vx = [0 diff(px)/mean(diff(t))];
vy = [0 diff(py)/mean(diff(t))];
vz = [0 diff(pz)/mean(diff(t))];

figure;
subplot(3,1,2); % POSITION
plot(t, vx, '.', 'MarkerSize', 12); hold on;
plot(t, vy, '.', 'MarkerSize', 12);
plot(t, vz, '.', 'MarkerSize', 12);
grid on;
ylabel('Velocity [mm/s]');
legend('vx','vy','vz');
hold off;

ax = [0 diff(vx)/mean(diff(t))];
ay = [0 diff(vy)/mean(diff(t))];
az = [0 diff(vz)/mean(diff(t))];

subplot(3,1,3); % ACCELERATION
plot(t, ax, '.', 'MarkerSize', 12); hold on;
plot(t, ay, '.', 'MarkerSize', 12);
plot(t, az, '.', 'MarkerSize', 12);
grid on;
ylabel('Acceleration [mm/s^2]');
legend('ax','ay','az');
hold off;

subplot(3,1,1); % VELOCITY
plot(t, px, '.', 'MarkerSize', 12); hold on;
plot(t, py, '.', 'MarkerSize', 12);
plot(t, pz, '.', 'MarkerSize', 12);
grid on;
xlabel('Time [s]');
ylabel('Position [mm]');
legend('px','py','pz');
hold off;

%% --- plot joint velocities / accelerations ---

for i = 1:total_points 
    [t_deg, a_deg, b_deg] = inverseKinematics(px(i), py(i), pz(i));

    % convert to radians immediately
    pt(i) = deg2rad(t_deg);
    pa(i) = deg2rad(a_deg);
    pb(i) = deg2rad(b_deg);

    degt(i) = t_deg;
    dega(i) = a_deg;
    degb(i) = b_deg;
end

figure;
subplot(3,1,1); % POSITION
plot(t, degt, '.', 'MarkerSize', 12); hold on;
plot(t, dega, '.', 'MarkerSize', 12);
plot(t, degb, '.', 'MarkerSize', 12);
grid on;
xlabel('Time [s]');
ylabel('Position [deg]');
legend('\theta','\alpha','\beta');
hold off;

vt = gradient(pt, t);
va = gradient(pa, t);
vb = gradient(pb, t);

subplot(3,1,2); % JOINT VELOCITY
plot(t, vt, '.', 'MarkerSize', 12); hold on;
plot(t, va, '.', 'MarkerSize', 12);
plot(t, vb, '.', 'MarkerSize', 12);
grid on;
ylabel('Velocity [rad/s]');
legend('\theta','\alpha','\beta');
hold off;

at = gradient(vt, t);
aa = gradient(va, t);
ab = gradient(vb, t);

subplot(3,1,3); % ACCELERATION
plot(t, at, '.', 'MarkerSize', 12); hold on;
plot(t, aa, '.', 'MarkerSize', 12);
plot(t, ab, '.', 'MarkerSize', 12);
grid on;
ylabel('Acceleration [rad/s^2]');
legend('\theta','\alpha','\beta');
hold off;

