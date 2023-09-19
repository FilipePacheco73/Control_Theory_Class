%%Realimentação Bode
K=10
sys=tf([K],[1 6 6.25 6.25])

margin(sys);grid
break
figure
bode(sys)
grid