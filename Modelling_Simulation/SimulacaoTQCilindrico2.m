clc
clear all
%load Dados_de_descida
load 'C:\Users\filip\Documents\Filipe\SENAI\Modelagem e Simulação\Dados de descida.mat'
%------------------------ Parâmetros Iniciais ----------------------------%

HF   =.155;
r    = 0.005;
Cv   =pi*r^2;
g    =9.7833;
L    =0.5;
descidar=dist(20:620);

%-------------------------------------------------------------------------%

%------------------------ Parâmetros do Filtro ---------------------------%

%order = 10;
%sampling_freq =1;
%cut_off_freq = .4;
%passband_peak_to_peak_db= .5;
%stopband_attenuation = 1;
%[B,A] = ellip(order,passband_peak_to_peak_db,stopband_attenuation,cut_off_freq/(.5*sampling_freq));
Wp=0.15;Ws=0.3;Rp=0.1;Rs=60;
[n,Wp] = ellipord(Wp,Ws,Rp,Rs);
%[n,Wp] = ellipord(Wp,Ws,Rp,Rs)
[b,a] = ellip(n,Rp,Rs,Wp);
%[b,a] = ellip(n,Rp,Rs,Wp)
%b = fir1(50,0.01,'low',chebwin(51,30))%Filtro Fir
%descidaf=filter(b,1,descidar);
descidaf=filter(b,a,descidar);

%Filtro binomial
h = [1/2 1/2];
binomialCoeff = conv(h,h);
binomialCoeff = conv(binomialCoeff,h);

fDelay = (length(binomialCoeff)-1)/2;
binomialMA = filter(binomialCoeff, 1, descidar);

%-------------------------------------------------------------------------%

%------------------------------ Simulação --------------------------------%

% for t=1:600
% [HF]    = abs(SIM(r,Cv,g,L,HF));    
% end

%-------------------------------------------------------------------------%

%------------------------------ Gráficos ---------------------------------%
t=600;
figure 

%plot(0:.1:t,100*HF)
hold on
plot(0:t,descidar)
plot(0:t,descidaf,'color','g')
plot(binomialMA, 'black');
hold off
title('Nível')
ylabel('Nível (cm)')
legend('Dados estimados','Sis. Real','Saída Filtro Elíptico','Saída Filtro Binomial')

%-------------------------------------------------------------------------%

%------------------------------- Funções ---------------------------------%


%-------------------------------------------------------------------------%