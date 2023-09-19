clear all

sys=zpk(-2,[0 -4 -6],10);
sys=ss(sys);
A=sys.a
B=sys.b;
C=sys.c;
D=sys.d
n=length(C);
J=[-1+1i*2 -1-1i*2 -5];
K=acker(A,B,J)


Jo=[-10 -10];
Cj=poly(Jo); %coeficientes do
%dadas as raízes
Abb=A(2:3,2:3);
Aaa=0;
Aba=[0;0];
Aab=[1.4142 0];
phi=(Abb^2*Cj(1)+Abb*Cj(2)+eye(2)*Cj(3));
Ke=phi*[Aab;Aab*Abb]^-1*[0; 1]

%Definição das matrizes do observador
Ba=0;
Bb=[0;4];
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

%calculo dos coeficientes da função de transferência
[num, den]=ss2tf(Atil,Btil,-Ctil, -Dtil);
FT=tf(num,den);
FT=zpk(FT);



sim('sim_sistema_obs_tf')
figure
plot(y.time,y.signals.values,'-b','LineWidth',2)
hold on
plot(Y_obs.time,Y_obs.signals.values,'-g','LineWidth',2);grid;
plot(r1.time,r1.signals.values,'--r','LineWidth',2)
h = legend('Y','Y_obs','Ref',1);set(h,'Interpreter','none')
hold off
xlabel('Tempo')
ylabel('estados')



