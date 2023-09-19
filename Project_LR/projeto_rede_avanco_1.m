clear all
%Projeto controle avanço de fase
polos=[-2 -4 0]
sys=zpk([],polos,20)
qsi=0.577;
%sistema de malha fechada
sys_mf=minreal(sys/(1+sys))
%retirar o denominador da função de transferência de malha fechada
[NUM,DEN]=tfdata(sys_mf,'v');
%Raízes da função de transferência de malha fechada
DEN
polos_mf=roots(DEN)



wd=imag(polos_mf(2))
alfa=real(polos_mf(2))

% Tempo de acomodação atual
Tac=4/abs(alfa)

%novo tempo de acomodação
Tac=Tac/4

% Teremos assim o novo alfa
alfa=4/Tac

%Com isso mudamos o wd também
wn=alfa/qsi
wd=sqrt(wn^2-alfa^2)

%novos polos dominantes
p=[-alfa+wd*i -alfa-wd*i]


%Escolhendo um zero igual a -2 para anular
%o efeito do polo -2 da planta
%Pela condição angular

%Verificar a condição de ângulo
p(1)
a1=angle(p(1)-polos(3))*180/pi
a2=angle(p(1)-polos(2))*180/pi


ap1=180-(a1+a2) %ângulo do polo do controlador
pc=wd/tan(ap1*pi/180)
pc=-(pc+alfa)

%Podemos obter o valor do K a partir da condição de módulo
d3=abs(p(1)-polos(3))
d2=abs(p(1)-polos(2))
dc=abs(p(1)-pc)

Kc=d3*d2*dc/20
zc=-2;
Gc=zpk(zc,pc,Kc);
Gc=zpk(zc,pc,1);
sysc=sys*Gc
sysc_mf=tf(minreal(sysc/(1+sysc)))


% figure
% 
% step(sysc_mf)
% hold on
% step(sys_mf)
% hold off
% grid

figure
rlocus(sysc)
text(-alfa,wd,'x')
text(-alfa,-wd,'x')
v=[-14 1 -4 4];axis(v)


