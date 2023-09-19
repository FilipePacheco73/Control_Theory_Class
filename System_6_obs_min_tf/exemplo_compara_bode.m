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
%dadas as ra�zes
Abb=A(2:3,2:3);
Aaa=0;
Aba=[0;0];
Aab=[1.4142 0];
phi=(Abb^2*Cj(1)+Abb*Cj(2)+eye(2)*Cj(3));
Ke=phi*[Aab;Aab*Abb]^-1*[0; 1]

%Defini��o das matrizes do observador
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

%calculo dos coeficientes da fun��o de transfer�ncia
[num, den]=ss2tf(Atil,Btil,-Ctil, -Dtil);
FT=tf(num,den);
FT=zpk(FT);

figure
bode(FT*sys/(1+FT*sys))
hold on

Jo=[-4.5 -4.5];
Cj=poly(Jo); %coeficientes do
%dadas as ra�zes
Abb=A(2:3,2:3);
Aaa=0;
Aba=[0;0];
Aab=[1.4142 0];
phi=(Abb^2*Cj(1)+Abb*Cj(2)+eye(2)*Cj(3));
Ke=phi*[Aab;Aab*Abb]^-1*[0; 1]

%Defini��o das matrizes do observador
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

%calculo dos coeficientes da fun��o de transfer�ncia
[num, den]=ss2tf(Atil,Btil,-Ctil, -Dtil);
FT=tf(num,den);
bode(FT*sys/(1+FT*sys))

hold off






