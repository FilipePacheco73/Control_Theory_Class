clear all
clc
exist W;
if ans ==0
    rng(1);
    W=randi([0 100], 1,10)/150;
end

%------------------------ Parâmetros Iniciais ----------------------------%
HF    =[.1 .1];
r     =.1;
Cv   =pi*(0.01/2)^2;
Cd    =0.40;
g     =9.7833;
L     =.5;
FI    =[1.4011e-05 1.4011e-05];
REF   = .15;
REFF  = REF;
REFFM = REF;
rng(5);

%-------------------------------------------------------------------------%

%------------------------------ Simulação --------------------------------%

for t=1:15000
    REFFM(t+1)= REF;
    Lyapunov(t)= (HF(end)-HF(end-1))^2;
    REFFM(t+1)= REF - 1e2*(HF(end)-HF(end-1));
    [AUX4,W] = RNA(W,REFFM(end),HF,FI);
    FI(t+1)  = max(8.083e-5*AUX4,0);  
    FO(t) = Cd*Cv*sqrt(g*HF(end));
    [HF]     = abs(SIM1(r,Cv,Cd,g,L,FI,HF));    
    if rem(t,1500) == 0
        REF=randi([05 15],1)/100;
    end
    REFF(t+1)= REF;
end
%Lyapunov(t+1)=Lyapunov(t);
FO(t+1) = FO(end);
%-------------------------------------------------------------------------%

%------------------------------ Gráficos ---------------------------------%

figure(1)
subplot(2,1,1);
%plot(0:1:t,100*HF(1:end-1))
%hold on
%plot(0:1:t,100*REFF)
%hold on
plot(0:1:t,100*REFF)
hold on
plot(0:1:t,100*REFFM)
hold on
title('Tanque Cilíndrico Horizontal')
xlabel('Tempo (s)')
ylabel('Nível (cm)')
ylim([0 20])
%legend('Saída da Planta','Referência')
legend('Referência','Referência para o Controlador')

subplot(2,1,2);
plot(0:1:t,1e6*FI)
hold on
%plot(0:1:t,1e6*FO)
%hold on
legend('Vazão de Entrada')
title('Ação de Controle')
ylim([0 100])
xlabel('Tempo (s)')
ylabel('Vazão (mL/s)')

% figure (2)
% plot(0:1:t,Lyapunov)
% hold on
% title('Função de Lyapunov')
% xlabel('Tempo (s)')
% ylabel('')

%-------------------------------------------------------------------------%

%------------------------------- Funções ---------------------------------%

function[HF] = SIM1(r,Cv,Cd,g,L,FI,HF)
[t,h]= ode45(@(t,h) ((FI(end)-Cd*Cv*sqrt(g*h))/L)*((2*r*(-(h*(h-2*r))/r^2)^(1/2)))^-1  ,[.0:.5:1],HF(end));
HF=[HF h(3)];
end

function[AUX4,W] = RNA(W,REFFM,HF,FI)
I       = 01; % Quant. Neurônios de Entrada.
H       = 05; % Quant. Nuerônios Escondidos na 1ª Camada.
O       = 01; % Quant. Neurônios de Saída.
R       = .1; % Normalização.
SIZE    = (H*(I+O)); % Tamanho do vetor pesos.
Alfa    = .2; % Taxa de aprendizagem.
INPUT   =[REFFM];

M1=reshape(W(1:I*H),[H,I]);
M2=reshape(W(I*H+1:SIZE),[O,H]);

AUX1=(M1*INPUT'); % Parâmetro para evitar saturação da função de ativação (Normalização).
AUX2=tanh(AUX1);
AUX3=(M2*AUX2);  % Parâmetro paraevitar saturação da função de ativação (Normalização).
AUX4=tanh(AUX3);

J=[100]*(REFFM-HF(end))+[.1]*(AUX4-FI(end));

A=(sech(AUX2)).^2;
B=(sech(AUX4)).^2;

M1=M1 +Alfa*A*INPUT.*sum(Alfa*J.*B*AUX2'.*M2)';
M2=M2 +Alfa*J.*B*AUX2';
W=[reshape(M1,[1,I*H]) reshape(M2,[1,H*O])];
end

%-------------------------------------------------------------------------%