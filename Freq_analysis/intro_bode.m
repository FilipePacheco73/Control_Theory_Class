%% Bode
figure
G1=tf(2,[1 2])
bode(G1);grid
figure
G1=zpk([],[-4 -2],6)
bode(G1);grid
figure
G1=zpk([-1],[-4 -2],6)
bode(G1);grid
figure
G1=tf(1,[1 0.1 1])
bode(G1);grid