clc
order = 5;
sampling_freq =2;
cut_off_freq = .1;
passband_peak_to_peak_db= 0.01;
stopband_attenuation = 5;
[B,A] = ellip(order,passband_peak_to_peak_db,stopband_attenuation,cut_off_freq/(.5*sampling_freq));
plot(dist)
hold on
plot(filter(B,A,dist))