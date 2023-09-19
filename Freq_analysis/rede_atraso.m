clear all
%exemplo rede atraso
ess=1/26;
Kp=1/ess-1
K=Kp*6*21 % Ganho para corrigir o erro de regime permanente.

G=zpk([],[-6 -21],K)
%margin(G)
MF=45; % Margem de fase do projeto
seg=5; % Margem de segurança de 5 a 12
dphi=MF+seg %60° + 5° de segurança
%dphi=35
ang=-180+dphi 
[ganho fase w]=bode(G);
d=100;

%% Obter o indice da nova frequencia de cruzamento
for i=1:length(fase)
dist=sqrt((fase(i)-ang)^2); %calcular o que está mais próximo
    if dist<d
        idx=i;
        d=dist; 
    end
    
end

%Localizar a nova frequencia de cruzamento a partir da fase

a=1/ganho(idx) %fator para obter Ganho nulo na frequencia de cruzamento


wc=w(idx) %Obter a frequencia de cruzamento
w2=-0.1*wc  %zero do controlador
w1=a*w2 %polo do controlador

C=zpk(w2,w1,a) %Controlador
figure
margin(G*C);grid; %Obter as margens projetadas

figure
step(G*C/(1+G*C));grid
hold on
step(G/(1+G))
hold off
h = legend(['Compensado com MF = ' num2str(MF)],'Não compensado',1);set(h,'Interpreter','none')
