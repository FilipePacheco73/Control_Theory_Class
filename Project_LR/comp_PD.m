
clear all
%Exemplo - Projeto de controlador PD
polos=[0 -1];
k=2;
sys=zpk([],polos,k);

sys_mf=minreal(sys/(1+sys))
rlocus(sys)
Tac=6;
Mp=0.10; %Overshoot
qsi=-log(Mp)/sqrt(pi^2+log(Mp)^2)


alfa=4/Tac;
wn=alfa/qsi;
wd=sqrt(wn^2-alfa^2);
p1=-alfa+wn*sqrt(1-qsi^2)*i;

p1



%Verificar a condição de ângulo
a1=angle(p1-polos(1))*180/pi
a2=angle(p1-polos(2))*180/pi


az1=a1+a2-180 %ângulo do zero
%[a1 a2 a3]


%necessário determinar a posição do zero
%por trigonometria
z1=alfa+wd/tan(az1*pi/180);
z1=-z1;
zc=z1;

%rlocus(sys*zpk(z1,[],1))
kc=abs(p1-polos(1))*abs(p1-polos(2))/abs(p1-zc);
Gc=zpk(zc,[],1);
rlocus(sys*Gc)
text(-alfa,wd,'X')
[kc,p]=rlocfind(sys*Gc)


Gc=zpk(zc,[],kc);

ylim([-30 30])
 
sys_mf_c=(minreal(Gc*sys/(1+Gc*sys)))


step(sys_mf,'r-',sys_mf_c,'k-')
h = legend('Sem compensador','Com Compensador',1);set(h,'Interpreter','none')
xlabel('Tempo')
ylabel('Resposta em malha fechada')
grid
