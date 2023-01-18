clear all;

%% Parameters
K_t = 0.0036;   % Torque thrust constant of motor/propeller (N*m/V)
K_f = 0.1188;   % Force-thrust constant of motor/propeller (N/V)
L = 0.197;      % Distance between pivot to each motor (cm)
J_y = 0.11;     % Equivalent moment of inertia about yaw axis (kg*m^2)
J_p = 0.0552;   % Equivalent moment of inertia about pitch axis (kg*m^2)
J_r = 0.0552;   % Equivalent moment of inertia about roll axis (kg*m^2)


%% State-Space Model
A = [
     0 0 0 1 0 0
     0 0 0 0 1 0
     0 0 0 0 0 1
     0 0 0 0 0 0
     0 0 0 0 0 0
     0 0 0 0 0 0
    ];

B = [
             0            0           0            0
             0            0           0            0
             0            0           0            0
      -K_t/J_y     -K_t/J_y     K_t/J_y      K_t/J_y
     L*K_f/J_p   -L*K_f/J_p           0            0
             0            0   L*K_f/J_r   -L*K_f/J_r
    ];

C = [
     1 0 0 0 0 0
     0 1 0 0 0 0
     0 0 1 0 0 0
    ];

D = zeros([3 4]);

%% 1. Determine the transfer function of the system

sys = ss(A, B, C, D);
H = tf(sys);

%% 2. Response of the system for a given input

% Create time axis
t = 0:0.1:10;

% Create input
u = [
     sin(3*t)
     cos(t)
     t
     sqrt(t)
    ];

% Response of the system
y = lsim(sys,u,t);

% Plot output
plot_IO(t,u,y);

%% 2. Determine the impulse response of the system

figure(3)
impulse(sys)
[y,t] = impulse(sys);

%% 4. Stability

stab = isstable(sys);
eigs = eig(A);

%% 5. Controllability, Observability

C6 = ctrb(sys);
C6_rank = rank(C6);

O6 = obsv(sys);
O6_rank = rank(O6);

%% Discretization

sysd = c2d(sys,1e-3);    % Sampling time = 1e-3 s => Sampling frequency = 1000 Hz