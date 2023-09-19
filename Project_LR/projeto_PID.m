% Exemplo – Projetar um controlador PID para o sistema indicado.
% Mantendo o mesmo tempo de pico do sistema sem compensação. 
% Tenha o coeficiente de amortecimento de 0,5 no par de polos conjugados.
% Tenha erro estacionário de posição nulo.
polos=[-2 -5 -10];
zero=-6;
sys=zpk(zero,polos,200)
tf(sys)
qsi_n=0.5;

% em malha fechada
sys_mf=tf(minreal(sys/(1+sys)))
[NUM,DEN]=tfdata(sys_mf,'v');
%Raízes da função de transferência de malha fechada
DEN
polos_mf=roots(DEN)
wd=imag(polos_mf(1))
alfa=-real(polos_mf(1))
%Tempo de pico a ser mantido
tp=pi/wd

wn=sqrt(wd^2+alfa^2)
qsi=alfa/wn

%Novo wn

wn=wd/sqrt(1-qsi_n^2)

%Novo alfa com base no qsi desejado
alfa=wn*qsi_n

%% Polos dominantes desejados

polos_desejados=[-alfa+j*wd -alfa-j*wd]

%% calcular os ângulos para verificar a condição de ângulo do LR
pd1=polos_desejados(1)
% ângulo dos polos em relação aos polos dominantes desejados
a1=angle(pd1-polos(1))*180/pi
a2=angle(pd1-polos(2))*180/pi
a3=angle(pd1-polos(3))*180/pi
% ângulo do zero em relação aos polos dominantes desejados
az1=-angle(pd1-zero)*180/pi

phi=a1+a2+a3+az1
%sobra de ângulo (Se for positivo) usa um zero para corrigir
delta_phi=phi-180

%Corrigir com um zero.
%relações trigonométricas para determinar sua posição no eixo real
zc=wd/tan(delta_phi*pi/180)+alfa;
zc=-zc

figure
G_pd=zpk(zc,[],1)
rlocus(sys*G_pd)
title('Lugar das Raízes PD')
text(-alfa,wd,'x')
text(-alfa,-wd,'x')
v=[-100 1 -45 45];axis(v)

%A parte do PI terá um polo na origem e um zero próximo
%Simularemos o RL ajustando a posição do zero
%Testaremos com zero em -0.5
figure
G_PI=zpk(-0.5,0,1);
title('Lugar das Raízes PID')
rlocus(sys*G_pd*G_PI)
text(-alfa,wd,'x')
text(-alfa,-wd,'x')
axis(v)

% O polo e o zero adicionados modificarão um pouco o LR e a condição
% de ângulo não será exatamente atendida mas a posição dos polos desejados
% Será próxima

%% Determinação do K pela condição de módulo

d1=abs(pd1-polos(1))
d2=abs(pd1-polos(2))
d3=abs(pd1-polos(3))
d4=abs(pd1-0) %polo na origem
d5=abs(pd1-(-0.5)) %zero do PI
d6=abs(pd1-zc) %zero derivativo
d7=abs(pd1-zero) %zero da planta
K=d1*d2*d3*d4/(d5*d6*d7)

%Comparando com a função de transferência da planta
Kc=K/200
G_PID=zpk([zc -0.8],0,Kc)
[NUM,DEN]=tfdata(G_PID,'v');
Kp=NUM(2)
Kd=NUM(1)
Ki=NUM(3)

sysc=sys*G_PID
sysc_mf=tf(minreal(sysc/(1+sysc)))


figure
title('Resposta ao degrau dos sistemas em malha fechada')
step(sysc_mf)
hold on
step(sys*zpk(zc,[],0.021)/(1+sys*zpk(zc,[],0.021)))
step(sys_mf)

hold off
h = legend('PID','PD','Sem Compensador',1);set(h,'Interpreter','none')
grid







