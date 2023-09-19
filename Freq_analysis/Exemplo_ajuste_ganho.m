%%Realimentação Bode
K=45000
K=K/10
sys=zpk([],[0 -5 -90],[K])
margin(sys);grid
%break
figure
step(sys/(1+sys))
grid