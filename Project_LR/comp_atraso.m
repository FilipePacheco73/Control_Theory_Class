clear all
%Exemplo - Compensador atraso de fase
sys=zpk([],[-2 -8],20)
sys_mf=minreal(sys/(1+sys))
[NUM,DEN]=tfdata(sys_mf,'v');
polos=roots(DEN)
alfa=real(polos);
alfa=alfa(1);
wd=imag(polos);
wd=wd(1);
tau=4/abs(alfa);

%Atualizar o valor de tau para 2*tau
tau=2*tau;
%Atualizar o valor de alfa
alfa=-4/tau;

polos=[(alfa+wd*i) (alfa-wd*i)]
DEN=poly(polos)

%Cancelando o polo em -8 com um zero
%E incluindo um polo em -3 poderemos deixar o 
%Sistema mais lento
rlocus(sys*zpk(-8,-3,1));

Kc=0.561;
Gc=zpk(-8,-3,Kc)



sys_mf_c=minreal(Gc*sys/(1+Gc*sys))


figure

step(sys_mf,'r-',sys_mf_c,'k-')
h = legend('Sem compensador','Com Compensador',1);set(h,'Interpreter','none')
xlabel('Tempo')
ylabel('Resposta em malha fechada')
grid
