G=zpk([],[-10 -30],200)

[num den]=tfdata(minreal(G/(1+G)), 'v')
pd1=roots(den)
Kp=0.15

pd1=pd1(1);
a1=angle(pd1-(-10))*180/pi
a2=angle(pd1-(-0.01))*180/pi
a3=angle(pd1-(-30))*180/pi

az=a1+a2+a3-180

z=-(20-10/tan((180-az)*pi/180))

Gc=zpk(-0.1,-0.01,1)
rlocus(G*Gc)
