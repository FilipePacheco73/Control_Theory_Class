clear all

A=[0 1 0;0 0 1;-6 -11 -6;];

%A=[0 1 0;0 0 1; 0 -11 -6;]; %Se testar com esta planta verá que rejeita
%perturbações constantes
B=[0; 0; 1];
C=[1 0 0];
n=length(C);
J=[-2+1i*2*sqrt(3) -2-1i*2*sqrt(3) -6];

K=acker(A,B,J)

Jo=[-10 -10];
Cj=poly(Jo); %coeficientes dos polinômios
Abb=A(2:3,2:3);
Aaa=0;
Aba=[0;-6];
Aab=[1 0];

phi=(Abb^2*Cj(1)+Abb*Cj(2)+eye(2)*Cj(3));
Ke=phi*[Aab;Aab*Abb]^-1*[0; 1]

%Definição das matrizes do observador
Ba=0;
Bb=[0;1];
Ac=Abb-Ke*Aab;
Bc=Ac*Ke+Aba-Ke*Aaa;
Fc=Bb-Ke*Ba;
Cc=[zeros(1,n-1);eye(n-1)];
Dc=[1;Ke];
%Matrizes do observador modificada
Ka=K(1);
Kb=K(2:end);
Atil=Ac-Fc*Kb;
Btil=Bc-Fc*(Ka+Kb*Ke);
Ctil=-Kb;
Dtil=-(Ka+Kb*Ke);

[num, den]=ss2tf(Atil,Btil,-Ctil, -Dtil)


sim('sim_sistema_2_observador_tf')
figure
plot(y.time,y.signals.values,'-b','LineWidth',2)
hold on
plot(Y_obs.time,Y_obs.signals.values,'-g','LineWidth',2);grid;
plot(r1.time,r1.signals.values,'--r','LineWidth',2)
h = legend('Y','Y_obs','Ref',1);set(h,'Interpreter','none')
hold off
xlabel('Tempo')
ylabel('estados')



