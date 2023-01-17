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