clear all
clc
load 'C:\Users\filip\Documents\Filipe\SENAI\Modelagem e Simulação\Dados de descida.mat'
exist INPUT;
if ans ==0
     INPUT=zeros([20,4]);
end
exist TARGETT;
if ans ==0
     TARGET=zeros([20,1]);
end
exist WA;
if ans ==0
    WA=randi([0 100], 1,30*(4+1))/250;
end

%------------------------ Parâmetros Iniciais ----------------------------%

HF   =.155;
r    =0.1;
Cv   =pi*(0.00875/2)^2;
Cd   =0.40;
g    =9.7833;
L    =0.5;
net=fitnet(30,'trainlm');   
%-------------------------------------------------------------------------%

%------------------------ Parâmetros do Filtro ---------------------------%

Wp=0.15;Ws=0.3;Rp=0.1;Rs=60;
[n,Wp] = ellipord(Wp,Ws,Rp,Rs);
[b,a] = ellip(n,Rp,Rs,Wp);
dist1 =filter(b,a,dist);
%-------------------------------------------------------------------------%

%------------------------------ Simulação --------------------------------%

for t=1:600
    INPUT(2:20,1:4)=INPUT(1:19,1:4);
    TARGET(2:20,1:1)=TARGET(1:19,1:1);
    INPUT(1,1:4)  =[dist(19+t) dist(18+t) dist(17+t) dist(16+t)];
    TARGET(1,1:1) =[dist(20+t)];
    [AUX4,WA]=IDENTF(INPUT,TARGET,WA);
    AUX44(t)= AUX4;
         
    [HF]   = abs(SIM1(r,Cv,Cd,g,L,HF));    
end

INPUT(2:20,1:4)=INPUT(1:19,1:4);
TARGET(2:20,1:1)=TARGET(1:19,1:1);
[AUX4,WA]=IDENTF(INPUT,TARGET,WA);
AUX44(t+1)= AUX4;
[AUX444]= RNAGENERAL(WA,dist);

%-------------------------------------------------------------------------%

%------------------------------ Gráficos ---------------------------------%

figure(1)

subplot(2,1,1);
plot(0:1:t,dist(20:620))
title('Tanque Cilíndrico Horizontal')
xlabel('Tempo (s)')
ylabel('Nível (cm)')
legend('Dados Reais')

subplot(2,1,2); 
plot(0:.1:t,100*HF)
xlabel('Tempo (s)')
ylabel('Nível (cm)')
legend('Dados estimados')

figure(2)

subplot(2,1,1);
plot(0:1:t,dist(20:620))
hold on
plot(0:1:t,AUX44)
title('Tanque Cilíndrico Horizontal')
xlabel('Tempo (s)')
ylabel('Nível (cm)')
legend('Dados Reais','RNA em tempo real')

subplot(2,1,2); 
plot(0:1:t,dist(20:620))
hold on
plot(0:1:t,AUX444)
xlabel('Tempo (s)')
ylabel('Nível (cm)')
legend('Dados Reais','RNA Generalizada')

%-------------------------------------------------------------------------%

%------------------------------- Funções ---------------------------------%

function[HF] = SIM1(r,Cv,Cd,g,L,HF)
ho=HF(size(HF,2));
T=1;
[t,h]= ode45(@(t,h) -Cd*(Cv*sqrt(g*h)/L)*((2*r*(-(h*(h-2*r))/r^2)^(1/2)))^-1  ,[.0:.1:1],ho);
h=h(2:11);
HF=[HF h'];
end

function[AUX4,WA]= IDENTF(INPUT,TARGET,WA)

I       = 04; % Quant. Neurônios de Entrada.
H       = 15; % Quant. Nuerônios Escondidos na 1ª Camada.
O       = 01; % Quant. Neurônios de Saída.
SIZE    = (H*(I+O)); % Tamanho do vetor pesos.
R       = 0.05;
Alfa    = 0.005;

M1=reshape(WA(1:I*H),[H,I]);
M2=reshape(WA(I*H+1:SIZE),[O,H]);

INPUT=INPUT*R;
TARGET=TARGET*R;
for i=1:20
n=randi([1 20], 1);
AUX1=(M1*INPUT(n,1:I)'); % Parâmetro para evitar saturação da função de ativação (Normalização).
AUX2=tanh(AUX1);
AUX3=(M2*AUX2);  % Parâmetro paraevitar saturação da função de ativação (Normalização).
AUX4=tanh(AUX3);
Erro=(TARGET(n,1:1)'-AUX4);

A=(sech(AUX2)).^2;
B=(sech(AUX4)).^2;

M1=M1 +Alfa*A*INPUT(n,1:I).*sum(Alfa*Erro.*B*AUX2'.*M2)';
M2=M2 +Alfa*Erro.*B*AUX2';
end

AUX1=(M1*INPUT(1,1:I)'); % Parâmetro para evitar saturação da função de ativação (Normalização).
AUX2=tanh(AUX1);
AUX3=(M2*AUX2);  % Parâmetro paraevitar saturação da função de ativação (Normalização).
AUX4=(1/R)*tanh(AUX3);
WA=[reshape(M1,[1,I*H]) reshape(M2,[1,H*O])];
end

function[AUX444]= RNAGENERAL(WA,dist)
I       = 04; % Quant. Neurônios de Entrada.
H       = 15; % Quant. Nuerônios Escondidos na 1ª Camada.
O       = 01; % Quant. Neurônios de Saída.
SIZE    = (H*(I+O)); % Tamanho do vetor pesos.
R       = 0.05;

M1=reshape(WA(1:I*H),[H,I]);
M2=reshape(WA(I*H+1:SIZE),[O,H]);
INPUTT(1:01,1:4)=[dist(29) dist(28) dist(27) dist(26)];

for i=1:601
AUX1=(M1*(INPUTT(1,1:I)'*R)); % Parâmetro para evitar saturação da função de ativação (Normalização).
AUX2=tanh(AUX1);
AUX3=(M2*AUX2);  % Parâmetro paraevitar saturação da função de ativação (Normalização).
AUX4=(1/R)*tanh(AUX3);
AUX444(i)=AUX4;
INPUTT=flip(INPUTT);
for i=1:3
    INPUTT(i)=INPUTT(i+1);
end
    INPUTT(4)=AUX4;
    INPUTT=flip(INPUTT);
end

end

%-------------------------------------------------------------------------%