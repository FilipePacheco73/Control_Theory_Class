G=zpk([],[0 0],25)
margin(G)
phi=30+5;
phi=phi*pi/180
a=(1+sin(phi))/(1-sin(phi))
adb=20*log10(a)
adb2=adb/2

wm=6.93 %Analisando o gr�fico
w2=wm/sqrt(a)
w1=a*w2
C=zpk(-w2,-w1,a)
margin(G*C)


step(minreal(G*C/(1+G*C)))

