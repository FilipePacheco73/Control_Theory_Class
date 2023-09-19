%a = arduino('COM3', 'Mega 2560', 'Libraries', 'JRodrigoTech/HCSR04')
%sensor = addon(a, 'JRodrigoTech/HCSR04', 'D06', 'D07');
clc
order = 1;
sampling_freq =2;
cut_off_freq = .001;
passband_peak_to_peak_db= 5;
stopband_attenuation = 20;
[B,A] = ellip(order,passband_peak_to_peak_db,stopband_attenuation,cut_off_freq/(.5*sampling_freq));
%plot(filter(B,A,dist))
%writePWMVoltage(a,'D5',.1)

T=4001;
h = animatedline('color','blue');
j = animatedline('color','red');
axis([0,T,0,20])


for i=1:T
dist(i) = 17.890-readTravelTime(sensor)*17000;
addpoints(h,i-1,dist(i));
%addpoints(j,i-1,filter(B,A,dist(i)));
drawnow
pause(.25);
end

