clear all;

%% Parameters
K_t = 0.0036;   % Torque thrust constant of motor/propeller (N*m/V)
K_f = 0.1188;   % Force-thrust constant of motor/propeller (N/V)
L = 0.197;      % Distance between pivot to each motor (cm)
J_y = 0.11;     % Equivalent moment of inertia about yaw axis (kg*m^2)
J_p = 0.0552;   % Equivalent moment of inertia about pitch axis (kg*m^2)
J_r = 0.0552;   % Equivalent moment of inertia about roll axis (kg*m^2)


%% 1.1 State-Space Model
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

%% 1.2  Input-output model: transfer function, impulse response function

% Transfer function
sys = ss(A, B, C, D);
H = tf(sys);

% Impulse response function
figure(1)
impulse(sys)
[y,t] = impulse(sys);

%% 1.3 Response of the system for a given input

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


%% 1.4 Stability

stab = isstable(sys);
eigs = eig(A);

% Lyapunov equation: A*M + M*A' + N = 0
N = diag([1 1 1 1 1 1]); % positive definite
% M = lyap(A,N); % Since the system is not satble, running this line we get
               % the following error message:
               % "The solution of this Lyapunov equation does not exist or is not unique."


%% 1.5 Controllability, Observability

C6 = ctrb(sys);
C6_rank = rank(C6);

O6 = obsv(sys);
O6_rank = rank(O6);

%% 1.6 Discretization

sysd = c2d(sys,1e-3);    % Sampling time = 1e-3 s => Sampling frequency = 1000 Hz

%% 2.1 PID

H = tf(sys);
H.InputName = {'qVf','qVb','qVr','qVl'};
H.OutputName = 'y';

D0 = [
      1 0 0
      0 1 0
      0 0 1
      0 0 0
     ];
Dec = tunableGain('Decoupler',D0);
Dec.InputName = 'e';
Dec.OutputName = {'pVf','pVb','pVr','pVl'};

PID_Vf = tunablePID('PID_Vf','pid');
PID_Vf.InputName = 'pVf';
PID_Vf.OutputName = 'qVf';

PID_Vb = tunablePID('PID_Vb','pid');
PID_Vb.InputName = 'pVb';
PID_Vb.OutputName = 'qVb';

PID_Vr = tunablePID('PID_Vr','pid');
PID_Vr.InputName = 'pVr';
PID_Vr.OutputName = 'qVr';

PID_Vl = tunablePID('PID_Vl','pid');
PID_Vl.InputName = 'pVl';
PID_Vl.OutputName = 'qVl';

sum1 = sumblk('e = r - y',3);

C0 = connect(PID_Vf,PID_Vb,PID_Vr,PID_Vl,Dec,sum1,{'r','y'},{'qVf','qVb','qVr','qVl'});

wc = [0.1,10];
[H,PID,gam,Info] = looptune(H,C0,wc);

% showTunable(PID)

T = connect(H,PID,'r','y');

%%% Validation
% % Constant
t = 0:3*60;
r = zeros([3 size(t,2)]);
r(1,:) = ones(1,size(t,2));
r(2,50:end) = ones(1,size(t,2)-49);
r(3,80:end) = ones(1,size(t,2)-79);

% % Sinusoidal
% t = 0:40*60;
% r = ones([3 size(t,2)]);
% r(1,:) = sin(t*1e-3);
% r(2,:) = cos(t*1e-2);

y = lsim(T,r,t);

plot_PID(t,r,y);

%% 2.3 LQR control (continuous time)

Q = diag([500 350 350 0 20 20]);
R = diag([0.01 0.01 0.01 0.01]);
[K,S,P] = lqr(A,B,Q,R);
sys_LQR = ss(A-B*K,B,C,D);

figure(5)
step(sys_LQR)


%% 2.4 LQR control (discrete time)

Ad = sysd.A;
Bd = sysd.B;
Cd = sysd.C;
Dd = sysd.D;
[Kd,Sd,Pd] = lqr(Ad,Bd,Q,R);
sys_LQRd = ss(Ad-Bd*Kd,Bd,Cd,Dd);

figure(6)
step(sys_LQRd)


