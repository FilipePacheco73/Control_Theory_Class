clear all

sis=zpk([],[0 -1 -2],1)
%sis=tf(sis)
sis=ss(sis)
J=[-2+j*sqrt(3) -2-j*sqrt(3) -10];
J=[-2+j*sqrt(10) -2-j*sqrt(10) -10];
K=acker(sis.a,sis.b,J)


sim('sim_sistema_2')
figure
plot(x1.time,x1.signals.values,'--b','LineWidth',2)
hold on
plot(x2.time,x2.signals.values,'.-r','LineWidth',2)
plot(x3.time,x3.signals.values,'--r','LineWidth',2);grid;
plot(r1.time,r1.signals.values,'-k','LineWidth',3)
h = legend('X1','X2','X3','Ref',1);set(h,'Interpreter','none')
hold off
xlabel('Tempo')
ylabel('estados')
