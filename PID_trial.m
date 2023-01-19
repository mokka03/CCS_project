clear all;

s = tf('s');
G = 1/(75*s+1)*[87.8 -86.4 86.5 -87; 108.2 -109.6 109 -108.5; 87.8 -86.4 86.5 -87];
G.InputName = {'qL','qV','qK','qM'};
G.OutputName = 'y';

D = tunableGain('Decoupler',ones([4,3]));
D.InputName = 'e';
D.OutputName = {'pL','pV','pK','pM'};

PI_L = tunablePID('PI_L','pid');
PI_L.InputName = 'pL';
PI_L.OutputName = 'qL';
  
PI_V = tunablePID('PI_V','pid'); 
PI_V.InputName = 'pV';
PI_V.OutputName = 'qV'; 

PI_K = tunablePID('PI_K','pid'); 
PI_K.InputName = 'pK';
PI_K.OutputName = 'qK'; 

PI_M = tunablePID('PI_V','pid'); 
PI_M.InputName = 'pM';
PI_M.OutputName = 'qM'; 

sum1 = sumblk('e = r - y',3);

C0 = connect(PI_L,PI_V,PI_K,PI_M,D,sum1,{'r','y'},{'qL','qV','qK','qM'});

wc = [0.1,1];
[G,C,gam,Info] = looptune(G,C0,wc);

showTunable(C)

T = connect(G,C,'r','y');
figure(312)
step(T)