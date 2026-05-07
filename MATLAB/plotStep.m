%% Step parameters
L = 200;        % step length [mm]
r = 100;         % step height / curvature [mm]
T = 1;          % total swing duration [s]
curve_percentage = 1/2;   % fraction of swing that is flat
x_offset = 200;            % lateral offset [mm]
flat_height = -70;         % z height during flat phase

N = 50;                    % total number of points
t = linspace(0, T, N);      % time vector

% Split indices
flat_period = round(curve_percentage * N);
swing_start = flat_period + 1;

%% Preallocate
px = zeros(1, N);
py = zeros(1, N);
pz = zeros(1, N);

%% --- Flat (prep) segment ---
tau = linspace(0,1,flat_period);   % normalized time for cubic

% Define start and end positions for smooth cubic
px_start = x_offset; 
px_end   = x_offset;       % lateral stays constant, can add small ramp if desired
py_start = -L/2;           % back of step
py_end   = L/2;           % keep constant or small offset if needed
pz_start = flat_height;    
pz_end   = flat_height;    % same height for flat

% Cubic interpolation: position = start + delta*(3*tau^2 - 2*tau^3)
px(1:flat_period) = px_start + (px_end - px_start)*(3*tau.^2 - 2*tau.^3);
py(1:flat_period) = py_start + (py_end - py_start)*(10*tau.^3 - 15*tau.^4 + 6*tau.^5);
pz(1:flat_period) = pz_start + (pz_end - pz_start)*(3*tau.^2 - 2*tau.^3);

%% --- Swing (semi-circular) segment ---
% Swing cubic (anchored at flat end)
py_start_swing = py(flat_period);    % last flat y
py_end_swing = -L/2;                  % end of step
pz_start_swing = pz(flat_period);    % flat height
pz_end_swing = flat_height;                     % max step height
px_start_swing = px(flat_period);  
px_end_swing = px_start_swing;      % no lateral change

delta_py = py_end_swing - py_start_swing;  % should be 0
delta_pz = pz_end_swing - pz_start_swing;  % step height change
delta_px = px_end_swing - px_start_swing;  % 0

% Normalized time for swing
swing_time = t(swing_start:N) - t(swing_start);
swing_duration = T*(1-curve_percentage);
tau_swing = swing_time / swing_duration;

% Minimum jerk polynomial
mj = @(s) (10*s.^3 - 15*s.^4 + 6*s.^5);

% px and py (unchanged behavior, still smooth)
px(swing_start:N) = px_start_swing;
py(swing_start:N) = py_start_swing + delta_py * mj(tau_swing);
pz(swing_start:N) = pz_start_swing + r * cos(pi*py(swing_start:N)./L);

%% pz split into two symmetric phases

%mid_idx = tau_swing <= 0.5;
%s_up = tau_swing(mid_idx) / 0.5;   % map [0,0.5] -> [0,1]
%pz(swing_start-1 + find(mid_idx)) = pz_start_swing + (r) * mj(s_up);
%s_down = (tau_swing(~mid_idx) - 0.5) / 0.5;  % map [0.5,1] -> [0,1]
%pz(swing_start-1 + find(~mid_idx)) = flat_height + r - (r) * mj(s_down);

%% --- Plot 3D trajectory ---
figure;
plot3(px, py, pz, '.', 'MarkerSize', 15);
grid on; axis equal;
xlabel('x [mm]'); ylabel('y [mm]'); zlabel('z [mm]');
title('3D Foot Trajectory: Smooth Flat + Swing');

xlim([-200 200]); ylim([-200 200]); zlim([-200 200]);

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