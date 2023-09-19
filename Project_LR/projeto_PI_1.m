%Projeto PI 1
sys=zpk([],[-2 -3],60)
%sistema de malha fechada
sys_mf=minreal(sys/(1+sys))
%retirar o denominador da fun��o de transfer�ncia de malha fechada
[NUM,DEN]=tfdata(sys_mf,'v');
%Ra�zes da fun��o de transfer�ncia de malha fechada
DEN
polos_mf=roots(DEN)
Gc=zpk(-0.1,0,1)
rlocus(sys*Gc)
axis([-8 0.1 -10 10]); 
sgrid(0.308,1.27) % Hertz
Kp=0.96
Gc=Gc*Kp
sysc=sys*Gc
sysc_mf=tf(minreal(sysc/(1+sysc)))

figure
rlocus(sys)
axis([-3.5 -1.5 -3 3]);
hold on
rlocus(sysc)
text(-2.48,2.26,'Sistema compensado')
text(-3.0,2.76,'Sistema n�o compensado')
hold off

figure
step(sys_mf)
hold on
step(sysc_mf)
grid
hold off

