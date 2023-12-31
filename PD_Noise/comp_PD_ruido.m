%Exemplo - Projeto de controlador PD
polos=[0 -1 -5];
K=30;
sys=zpk([],polos,K);

sys_mf=minreal(sys/(1+sys))
%rlocus(sys)
Tac=2;
qsi=0.5;
alfa=4/Tac;
wn=alfa/qsi;
wd=sqrt(wn^2-alfa^2);
p1=-alfa+wd*i;

%Verificar a condi��o de �ngulo
a1=angle(p1-polos(1))*180/pi;
a2=angle(p1-polos(2))*180/pi;
a3=angle(p1-polos(3))*180/pi;

az1=a1+a2+a3-180 %�ngulo do zero

%necess�rio determinar a posi��o do zero
%por trigonometria
z1=2-wd/tan((180-az1)*pi/180)
z1=-z1;
%rlocus(sys*zpk(z1,[],1))
kc=0.621;
Gc=zpk(z1,[],kc);

sim('comp_PD_sim')

figure
plot(ref.time,ref.signals.values,'--b','LineWidth',2)
hold on
plot(controle.time,controle.signals.values,'.-r','LineWidth',2)
plot(saida.time,saida.signals.values,'--k','LineWidth',2)
h = legend('ref','controle','saida',1);set(h,'Interpreter','none')
hold off
xlabel('Tempo')
ylabel('Saida')


