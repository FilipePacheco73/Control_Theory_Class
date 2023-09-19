clear all
clc

%------------------------ Parâmetros Iniciais ----------------------------%
HF   =.1;
r    =.1;
Cv   =pi*(0.01/2)^2;
Cd   =0.40;
g    =9.7833;
L    =.5;
REF     = .15;
Erro    = [0];
dErro   = [0];
SUM     = [0];
% Kp      = [20];
% Ki      = [.2];
% Kd      = [0];
Kp      = [7.706655231239209e3];
Ki      = [2.1221674060025e1];
Kd      = [-1.37824561434454e3];
REFF(1) = REF;
rng(5);

%-------------------------------------------------------------------------%

%------------------------------ Simulação --------------------------------%

for t=1:15000
    dErro = (REF-HF(end) - Erro)*[.1]';
    Erro  = (REF-HF(end))*[.1]';
    SUM   = SUM + Erro;
    MV    = Kp*Erro' +Ki*SUM' +Kd*dErro';
    FI(t) = 8.083e-7*min(100, max(0,MV)); 
    FO(t) = Cd*Cv*sqrt(g*HF(end));
    [HF]   = abs(SIM1(r,Cv,Cd,g,L,FI,HF));
    if rem(t,1500) == 0
        REF=randi([05 15],1)/100;
    end
    REFF(t+1)= REF;
end
FI(t+1)=FI(end);
FO(t+1) = FO(end);
%-------------------------------------------------------------------------%

%------------------------------ Gráficos ---------------------------------%

figure(1)
subplot(2,1,1);
plot(0:1:t,100*HF)
hold on
plot(0:1:t,100*REFF)
title('Tanque Cilíndrico Horizontal')
xlabel('Tempo (s)')
ylabel('Nível (cm)')
ylim([0 20])
legend('Saída da Planta','Referência')

subplot(2,1,2);
plot(0:1:t,1e6*FI)
hold on
%plot(0:1:t,1e6*FO)
%hold on
legend('Vazão de Entrada')
title('Ação de controle')
ylim([0 100])
xlabel('Tempo (s)')
ylabel('Vazão (mL/s)')

%-------------------------------------------------------------------------%

%------------------------------- Funções ---------------------------------%

function[HF] = SIM1(r,Cv,Cd,g,L,FI,HF)
[t,h]= ode45(@(t,h) ((FI(end)-Cd*Cv*sqrt(g*h))/L)*((2*r*(-(h*(h-2*r))/r^2)^(1/2)))^-1  ,[.0:.5:1],HF(end));
HF=[HF h(3)];
end

%-------------------------------------------------------------------------%