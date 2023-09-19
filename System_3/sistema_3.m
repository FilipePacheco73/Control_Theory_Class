A=[-5 1 0;0 -2 1;0 0 -1]
B=[0 0 1]';
C=[1 0 0; 0 1 0; 0 0 1];
D=[0 0 0]'

J=[-2+j*4.9540 -2-j*4.9540 -10 -10]; %polos desejados

Ac=[A zeros(3,1);-[1 0 0] 0]
Bc=[B ;0]
K=acker(Ac,Bc,J) %Alocação dos polos desejados



sim('sim_sistema_3')
figure
plot(x1.time,x1.signals.values,'--b','LineWidth',2)
hold on
plot(x2.time,x2.signals.values,'.-r','LineWidth',2)
plot(x3.time,x3.signals.values,'-b','LineWidth',2);grid;
%plot(x4.time,x4.signals.values,'-y','LineWidth',2);
plot(r1.time,r1.signals.values,'-k','LineWidth',3)
h = legend('X1','X2','X3','Ref');set(h,'Interpreter','none')
hold off
xlabel('Tempo')
ylabel('estados')
