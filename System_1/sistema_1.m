%Modelo de sistema completamente controlável e observável
A=[0 1 0;
    0 0 1;
    -1 -5 -6];
B=[0;0;1]; % uma entrada
C=eye(3);
D=[0;0;0];

%Definição dos pólos de malha fechada desejados
s=[-2+j*4 -2-j*4 -10];
%Determinação da matriz K de realimentação
%Sistema de uma entrada podemos usar o comando acker
K=acker(A,B,s);
sim('sim_sistema_1')

figure
plot(x1.time,x1.signals.values,'--b','LineWidth',2)
hold on
plot(x2.time,x2.signals.values,'.-r','LineWidth',2)
plot(x3.time,x3.signals.values,'--k','LineWidth',2)
plot(controle.time,controle.signals.values,'-k','LineWidth',3)
plot(w.time,w.signals.values,'-b','LineWidth',2);grid;
h = legend('X1','X2','X3','controle','perturb',1);set(h,'Interpreter','none')
hold off
xlabel('Tempo')
ylabel('estados')


