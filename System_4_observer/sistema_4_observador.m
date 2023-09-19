clear all
A=[0 1 0 0;20.601 0 0 0;0 0 0 1;-0.4905 0 0 0]
B=[0 -1 0 0.5]';
C=[0 0 1 0];

J=[-1+j*sqrt(3) -1-j*sqrt(3) -5 -5 -5]; %polos desejados da planta

%% Sistema aumentado por conta do integrador
Ac=[A zeros(4,1);-C 0]
Bc=[B;0]
K=acker(Ac,Bc,J) %Alocação dos polos desejados
KI=K(end);
K=K(1:end-1);

%% Cálculo da matriz de ganho do erro do observador
Jo=[-20 -20 -25 -25]
phi_coef=poly(Jo) %Obtém os coeficientes do polinômio a partir de suas raízes
phi=polyval(phi_coef,A) %Avaliar o polinômio para um determinado valor

phi=phi_coef(1)*A^4+phi_coef(2)*A^3+phi_coef(3)*A^2+phi_coef(4)*A+phi_coef(5)*eye(4,4)

CA=C
for i=1:length(B)-1
  CA=[CA;C*A^i];
end

col=zeros(length(B),1);
col(end)=1;
Ke=phi*inv(CA)*col


sim('sim_sistema_4')
figure
%plot(x1.time,x1.signals.values,'--b','LineWidth',2)
hold on
%plot(x2.time,x2.signals.values,'.-r','LineWidth',2)
plot(x3.time,x3.signals.values,'--r','LineWidth',2);grid;
plot(x6.time,x6.signals.values,'-.b','LineWidth',3);
plot(r1.time,r1.signals.values,'--k','LineWidth',2)
h = legend('Y','Y_obs','Ref',1);set(h,'Interpreter','none')
hold off
xlabel('Tempo')
ylabel('estados')

