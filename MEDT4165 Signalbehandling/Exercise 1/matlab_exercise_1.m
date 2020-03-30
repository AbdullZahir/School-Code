fs = 100; %sampling frequency
f1 = 5; a1 = 0.02; %frequency and amplitude of signal component 1
f2 = 45; a2 = 0.02; %frequency and amplitude of signal component 2
n1 = 0.0002; %noise amplitude
t = 0:1/fs:1;
s = a1*cos( 2*pi*f1*t) + a2*cos( 2*pi*f2*t) + n1*randn( size( t) ); %signal

%------------------%
figure(1)
n = 1024;
%n=length(s); %length of N-point of the signal
X=fft(s,n); % n-point fft of the signal

Y=fftshift(X); %shifting the frequency from [0 : fs] to [-fs/2 : fs/2]
fshift =(-n/2:n/2-1)*(fs/n); %zero centered frequency range from -n/2 to n/2
P=abs(Y); %Power of signal (power spectrum)
subplot(3,1,1)
plot(fshift,P)
title('power spectrum')

%-----------decibel scale-----------%
Pdb=20*log10(P); %power in logaritmic scale
subplot(3,1,2)
plot(fshift,Pdb)
title('Power spectrum in db')


%-------noramlizing frequency-------%
if(mod(n,0)==0) %n=Nfft
    f = linspace( -0.5, 0.5-1/n, n); % if n is even
else
    f = linspace( -0.5+0.5/n, 0.5-0.5/n, n); % if n is odd
end

subplot(3,1,3)
plot(f,Pdb)
title('normalized freq')

%--------making filters with normalized freq-------%
figure(2)
A1 = fir1(22, 0.5, 'low');
A2 = fir1(22, 0.5, 'high');

XA1=fft(A1,n);
YA1=fftshift(XA1);
subplot(2,1,1)
plot(f,20*log10(abs(YA1))) %20log(abs(YA1)) is the power spectrum in decibel
title('lowpass freqres.')

XA2=fft(A2,n); 
YA2=fftshift(XA2);
subplot(2,1,2)
plot(f,20*log10(abs(YA2)))
title('highpass freqres.')

%--------filtering signal-------------%
figure(3)
YA1=filter(A1,1,s); %filtering signal with a A1(lowpassfilter);
subplot(2,1,1)
plot(f,20*log10(abs(fftshift(fft(YA1,n)))))
title('lowpassfiltered signal')

YA2=filter(A2,1,s);
subplot(2,1,2)
plot(f,20*log10(abs(fftshift(fft(YA2,n)))))
title('highpassfiltered signal')

%--------downsampling-----------%
figure(4)
ds=downsample(s,2);
plot(f,20*log10(abs(fftshift(fft(ds,n)))))
%when we downsample with 2 we remove every other stick in the signal s.
%So by downsampling with 2 we remove the stick that is zero
%if we downsample by 1, then we remove the amplitude of the signal and
%we get distortion of the signal.
%we get aliasing, the high freq. tops will then be left out and be included in the signale as 1-fs/2 















    
