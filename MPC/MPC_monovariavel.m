clear all
clc

%------------------------- Sistema Dinâmico -------------------------------
s   = tf('s');
G   = 2/(3*s +2);
a   = 2;
b   = [3 2];
[A,B,C,D]   = tf2ss(a,b);
XO = 0;
YS= 2*ones(20,1);

%c2d(ss(A,B,C,D),1)
%-------------------------- Dados do Controlador --------------------------
n = 20;                   % horizonte de prediçao
u = [0;ones(n-1,1)];      % esforço de controle



%------------------------------- Predições --------------------------------

for i=1:n
    Phi(i)=A^n;           % Matriz de Estados Iniciais
end

Theta=eye(n,n);

for i=2:n
    for j=1:i-1
    Theta(i,j)=A^(i-j);     % Matriz de Predição dos Estados
    end
end

X = Phi'*XO + Theta*B*u;    % Matriz completa dos Estados

Y   = C*Phi;

for i=1:n
    for j=1:n
        H(i,j) = -YS(i)+C*(Phi(j)*XO+Theta(i,j)*B)*C*Theta(i,j);
    end
end

x=quadprog((H+H')/2,zeros(20,1))

z=tf('z');
G=(2/(3*z+2));
y=step(G,1:10)

