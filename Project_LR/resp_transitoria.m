Wn=1;
qsi=0.5;

[NUM,DEN]=ORD2(Wn,qsi);

NUM=[1 30]; DEN=[1 6.1 40];
t=0:0.02:20;
[y,x,t]=step(NUM,DEN,t);
plot(t,y)
grid
title('Resposta ao degrau unitário')
xlabel('t')
ylabel('Saída')

%Tempo de subida de 10% a 90%
r1=1;while y(r1)<0.1*y(end), r1=r1+1; end
r2=1;while y(r2)<0.9*y(end), r2=r2+1; end
rise_time=(r2-r1)*0.02;

rise_time

%Tempo de Pico
[ymax,tp]=max(y);
peak_time=(tp-1)*0.02;

peak_time

%Sobresinal
max_overshoot=ymax-y(end);
max_overshoot

%Tempo de acomodação
s=length(y); while y(s)>0.98*y(end) & y(s)<1.02*y(end); s=s-1; end;

settling_time=(s-1)*0.02;

settling_time

