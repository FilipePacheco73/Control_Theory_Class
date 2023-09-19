clear all
close all
%exemplo rede atraso 2


G=zpk([],[0 -10 -60],120000)
[Gm,Pm] = margin(G);



%margin(G)
MF=40; % Margem de fase do projeto
seg=5.5; % Margem de segurança de 5 a 12
dphi=MF+seg 

ang=-180+dphi 
[ganho fase w]=bode(G);
ganho_baixas=ganho(1)
d=100;


%% Obter o indice da nova frequencia de cruzamento
for i=1:length(fase)
dist=sqrt((fase(i)-ang)^2); %calcular o que está mais próximo
    if dist<d
        idx=i;
        d=dist; 
    end
    
end
%%
angulo=fase(idx)
a=1/ganho(idx); %fator para obter Ganho nulo na frequencia de cruzamento
wc=w(idx) %Obter a frequencia de cruzamento
%wc=7.72
[M Fase]=bode(G,wc)
a=1/M;
w2=-0.1*wc  %zero do controlador
w1=a*w2 %polo do controlador

C=zpk(w2,w1,a) %Controlador


%% Resultados
figure
margin(G*C);grid; %Obter as margens projetadas
[Gm2,Pm2] = margin(G*C);
Margens_antes=[20*log10(Gm) Pm]
Margens_depois=[20*log10(Gm2) Pm2]

figure
subplot(211)
title('Sistema compensado')
step(minreal(G*C/(1+G*C)));grid
%h = legend(['Compensado com MF = ' num2str(MF)],1);set(h,'Interpreter','none')
subplot(212)
title('Sistema não compensado')
step(minreal(G/(1+G)))
grid