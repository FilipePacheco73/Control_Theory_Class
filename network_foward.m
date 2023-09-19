clear all
clc
%exemplo rede atraso


G=zpk([],[-2 -1 -.5],9)
[Gm,Pm] = margin(G)

%margin(G)
MF=25; % Margem de fase do projeto
seg=10; % Margem de segurança de 5 a 12
dphi=MF+seg 

ang=-180+dphi 
dphi=dphi*pi/180 %Converter para radiano
a=(1+sin(dphi))/(1-sin(dphi))
adB=20*log10(a)
half_adB=adB/2

[ganho fase xw]=bode(G);

wm = 3.4 % A partir da análise do gráfico

w2=wm/sqrt(a)  %zero do controlador
w1=a*w2 %polo do controlador
C=zpk(-w2,-w1,a) %Controlador


%% Resultados
figure
margin(G*C);grid; %Obter as margens projetadas
[Gm2,Pm2] = margin(G*C);
Margens_antes=[20*log10(Gm) Pm]
Margens_depois=[20*log10(Gm2) Pm2]

figure
step(minreal(G*C/(1+G*C)),'r',minreal(G/(1+G)),'k--');grid
step(minreal(G*C/(1+G*C)));grid
%h = legend(['Compensado com MF = ' num2str(MF)],1);set(h,'Interpreter','none')

figure
subplot(1,2,1)
title('Comparação compensado e não compensado')
bode(G,'r',G*C,'b--');grid
%h = legend('Não Compensado', 'Compensado',1);set(h,'Interpreter','none')
subplot(1,2,2)
bode(C);grid
title('Controlador')


