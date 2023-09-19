%Overshoot menor que 25%
%Tempo de acomodação de 2s
%Rejeitar perturbação constante e seguir referência constante com erro nulo

%% Sistema

A=[-5 1 0;0 -2 1;0 0 -1];B=[0 0 1]';C=[1 0 0];


%%
Mp=0.25;
Tac=2;
alfa=4/Tac;
qsi=1/sqrt(1+pi^2/(log(Mp))^2);
%qsi=0.8;
wn=alfa/qsi;
wd=wn*sqrt(1-qsi^2)

J=[-alfa+j*wd -alfa-j*wd -5 -5] %polos desejados

Ac=[A zeros(3,1);-C 0]
Bc=[B;0]
K=acker(Ac,Bc,J) %Alocação dos polos desejados



sim('sim_sistema_3_2')
figure
plot(x1.time,x1.signals.values,'--b','LineWidth',2)
hold on
plot(r1.time,r1.signals.values,'-k','LineWidth',3);grid;
h = legend('X1','Ref',1);set(h,'Interpreter','none')
hold off
xlabel('Tempo')
ylabel('estados')
