load('sigFile.mat');
%s: signal
%sn: signal with noise
%t: time-axis, vector containing the time of samples in s og sn.

n=1024;%n-point fft of the signal

%--------normalizing the frequency------------%
if(mod(n,0)==0) %n=Nfft
    f = linspace( -0.5, 0.5-1/n, n); % if n is even
else
    f = linspace( -0.5+0.5/n, 0.5-0.5/n, n); % if n is odd
end

%------------power spectrum--------------%
figure(1)
Xn=fft(sn,n); %fft of the noisy signal
X=fft(s,n);
Yn=fftshift(Xn);
Y=fftshift(X);

subplot(2,1,1)
plot(f,20*log10(abs(Y)))
title('Signal s')

subplot(2,1,2)
plot(f,20*log10(abs(Yn)))
title('Signal with noise')

%------------filters-----------------%
figure(2)
Asn=fir1(150,2*0.03174); %we only need lowpass filter in this case, lowpass signal for sn
As=fir1(150,2*0.03467);%lowpass filter for signal s

subplot(2,1,1)
plot(f,20*log10(abs(fftshift(fft(As,n)))))
title('frequency response for s')

subplot(2,1,2)
plot(f,20*log10(abs(fftshift(fft(Asn,n)))))
title('frequency response for sn')

%---------filtering the signal---------%
figure(3)
Ys=filter(As,1,s); 
subplot(2,1,1)
plot(f,20*log10(abs(fftshift(fft(Ys,n)))))
title('filtered s signal')

Ysn=filter(Asn,1,sn);
subplot(2,1,2)
plot(f,20*log10(abs(fftshift(fft(Ysn,n)))))
title('filtered sn-signal')

%----------comparing the signals---------%
figure(4)

subplot(2,2,1)
plot(t,sn) %non filtered sn signal
title('original signal sn')

subplot(2,2,2)
plot(t,Ysn)%lowpassfiltered sn signal
title('filtered signal sn')

subplot(2,2,3)
plot(t,s) %original signal s
title('original signal s')

subplot(2,2,4)
plot(t,Ys) %lowpassfiltered signal s
title('filtered signal s')

%-------calculating the average quadratic deviations and noise reduction-----%
aqd1=mean(abs(sn-s)); %nonfiltered noisy signal vs original signal
aqd2=mean(abs(Ysn-s)); %filtered noisy signal vs original signal

nr_db=20*log10(aqd2/aqd1) %noise reduction in decible.

