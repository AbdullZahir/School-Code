clear all;
cardiac=load('cardiacRFdata.mat');
phantom1=load('phantomRFdata1.mat');
phantom2=load('phantomRFdata2.mat');
LP=load('LP.mat');

%skriv inn filnavnet for det du vil hente data fra;
filename=cardiac;
dyn=-55; %dB contrast
gain=110; %dB brightness
%% Oppgave 1
figure(1)
Nfft=2048; %2^11
fs=filename.p.frs_Hz; % sampling freq
Ts=1/fs;
t=(0:size(filename.rf,1)-1)*Ts;%tidsaksen
omega=2*pi*2*filename.p.f0_Hz;%omega=s*pi*f0

%downmixing
Sdm=filename.rf.*exp(-1i*omega*t.');%S(t)*e^(iwt), downmixing, t.'-transponere vektoren for å matche lengden på vektorene
freqtab=linspace(-0.5, 0.5, Nfft+1)*fs; freqtab(end)=[];%normalisert freq.axis

%filtering with a lowpassfilter which i designer with filterDesigner
IQ=filter2(LP.Num.',Sdm);%filtering the donwmixed signal and tranpos it!!!!!!!!!!!!

subplot(4,1,1); 
plot(freqtab,20*log10(abs(fftshift(fft(filename.rf,Nfft))))); title('original signal'); xlabel('Hz'); ylabel('Amplitude[dB]'); 
subplot(4,1,2)
plot(freqtab,20*log10(abs(fftshift(fft(Sdm,Nfft)))));title('downmixed signal'); xlabel('Hz'); ylabel('Amplitude [dB]')
subplot(4,1,3);
plot(freqtab,20*log10(abs(fftshift(fft(IQ,Nfft)))));title('IQ signal without the avg.mean'); xlabel('Hz'); ylabel('Amplitude [dB]')
subplot(4,1,4);
plot(freqtab,10*log10(mean(abs(fftshift(fft(IQ,Nfft))).^2,2)));title('IQ signal with avg.mean'); xlabel('Hz'); ylabel('Amplitude [dB]')

%% Oppgave 2
figure(2)
c=1540;
start_depth=filename.p.startdepth_m;
%depthaxis=(0:(size(filename.rf,1)-1))*Ts*c/2+start_depth;%inkrementere med pos=Ts*c/2 og legger til +startdepth for å starte der 
depthaxis=linspace(0, size(filename.rf,1)-1, size(filename.rf,1))*(Ts*c/2) +start_depth;
subplot(2,1,1);plot(depthaxis,filename.rf(:,64)); title('Rf sig from middleline 64 with envelope'); xlabel('depth [m]'); ylabel('RF');
hold on

%finding envelope
envelope=2*abs(IQ); %ganger med 2 fordi vi fjerne halve signalet
plot(depthaxis,envelope(:,64)) ; 

subplot(2,1,2);
plot(depthaxis,envelope(:,64)); title('envelope from middle line 64');xlabel('depth[m]');ylabel('RF');

%% Oppgave 3
figure(3)
angle=linspace(0,size(filename.rf,2)-1,size(filename.rf,2))*(filename.p.angleincrement_rad)+filename.p.startangle_rad;
r=depthaxis;
[Img,CX,CZ]=scanconvert(IQ,r,angle);
colormap(gray);

% paramters for the image: gain and dynamic range(dyn)
imagesc(CX*1e3,CZ*1e3,20*log10(abs( Img)));
caxis([dyn 0] +gain);
colormap(gray); title('beam image'); xlabel('[mm]');ylabel('[mm]');


