clear all;
%load('NearFieldPulse.mat');
AZ_full=load('profile_AZ_7cm_Full.mat');
AZ_red=load('profile_AZ_7cm_reduced.mat');
EL_full=load('profile_EL_7cm_Full.mat');
EL_red=load('profile_EL_7cm_reduced.mat');
z_axis=load('z_axis_12dB.mat');
puls0avg=load('pulse_7cm_0dB_10x_aver.mat');
puls8avg=load('pulse_7cm_-8dB_10x_aver.mat');
puls14avg=load('pulse_7cm_-14dB_10x_aver.mat');
puls14=load('pulse_7cm_-14dB_no_aver.mat');
%giving files variable names and using struct notation to fetch them

%%
figure(1); %task 1
puls14;
%puls -14dB no avg
puls14time=((1:size(puls14.RF,1))*puls14.Ts+puls14.Position(4,1)); %creating time axis to match RF puls.
subplot(2,2,1);   
plot(puls14time.*10^6,puls14.RF.*10^3); title('pulse 7cm -14dB'); xlabel('us'); ylabel('mV'); 

%puls _14dB w/avg
puls14avgtime=((1:size(puls14avg.RF,1))*puls14avg.Ts+puls14avg.Position(4,1)); %creating time axis to match RF puls.
subplot(2,2,2); 
plot(puls14avgtime.*10^6,puls14avg.RF.*10^3); title('pulse 7cm -14dB avg');xlabel('us'); ylabel('mV'); 

%puls 0dB no avg
puls0avgtime=((1:size(puls0avg.RF,1))*puls0avg.Ts+puls0avg.Position(4,1)); %creating time axis to match RF puls.
subplot(2,2,3);
plot(puls0avgtime.*10^6,puls0avg.RF.*10^3); title('pulse 7cm 0dB avg'); xlabel('us'); ylabel('mV');

%puls -8dB no avg
puls8avgtime=((1:size(puls8avg.RF,1))*puls8avg.Ts+puls8avg.Position(4,1)); %creating time axis to match RF puls.
subplot(2,2,4); 
plot(puls8avgtime.*10^6,puls8avg.RF.*10^3); title('pulse 7cm -8dB avg');xlabel('us'); ylabel('MmV'); 

%% task 2
figure(2)
%plot(puls14.RF); 
Nfft=1200; %2^11;
fs=1/puls14.Ts;


freqtab=linspace(-0.5, 0.5, Nfft+1)*fs; %lager frek.akse og med ekstra element 
freqtab(end)=[]; %og fjerner siste elementet sånn at frekvensaksen blir riktig.
pow_spect14=20*log10(abs(fftshift(fft(puls14.RF(1:1200),Nfft))));
pow_spect14avg=20*log10(abs(fftshift(fft(puls14avg.RF,Nfft))));
pow_spect0avg=20*log10(abs(fftshift(fft(puls0avg.RF,Nfft))));
pow_spect8avg=20*log10(abs(fftshift(fft(puls8avg.RF,Nfft))));

%signal 14 no avg
subplot(2,2,1); plot(freqtab*10^-6, pow_spect14);xlim([0 50]); xlabel('frequency'); ylabel('dB'); title('pulse 7cm -14dB');
hold on
subplot(2,2,1); plot(freqtab*10^-6, 20*log10(abs(fftshift(fft(puls14.RF(2000:4096),Nfft)))));

%signal 14 avg
subplot(2,2,2); plot(freqtab*10^-6, pow_spect14avg);xlim([0 50]); xlabel('frequency'); ylabel('dB');title('pulse 7cm -14dB avg');
hold on
subplot(2,2,2); plot(freqtab*10^-6, 20*log10(abs(fftshift(fft(puls14avg.RF(2000:4096),Nfft)))));

%signal 0 avg
subplot(2,2,3); plot(freqtab*10^-6, pow_spect0avg);xlim([0 50]); xlabel('frequency'); ylabel('dB'); title('pulse 7cm 0dB avg');
hold on
subplot(2,2,3); plot(freqtab*10^-6, 20*log10(abs(fftshift(fft(puls0avg.RF(2000:4096),Nfft)))));

%signal 8 avg
subplot(2,2,4); plot(freqtab*10^-6, pow_spect8avg);xlim([0.5 50]); xlabel('frequency'); ylabel('dB'); title('pulse 7cm -8dB avg');
hold on
subplot(2,2,4); plot(freqtab*10^-6, 20*log10(abs(fftshift(fft(puls8avg.RF(2000:4096),Nfft)))));

%% task 3
figure(3)
powEstAZ=sum(AZ_full.RF.^2,1);
powEstEL=sum(EL_full.RF.^2,1);

pdB_norm_AZ=powEstAZ./max(powEstAZ); %normalizing the intensity
pdB_norm_EL=powEstEL./max(powEstEL);
   
subplot(2,2,1);plot(AZ_full.Position(1,:)*1e3,10*log10(pdB_norm_AZ)); title('Intensity Azimuth normalized');xlabel('AZ X-axis'); ylabel('powEst');
subplot(2,2,2);plot(EL_full.Position(2,:)*1e3,10*log10(pdB_norm_EL)); title('Intensity Elevation normalized');xlabel('EL Y-axis'); ylabel('powEst');

x=-3:0.001:3;
c=1540; 
f=1.6*10^6;
lambda=c/f;
y_AZ_dB=20*log10(abs(sinc(x/(3.77*lambda)))); %scaling factor
y_EL_dB=20*log10(abs(sinc(x/(5.83*lambda)))); %scaling factor

%y_dB=20*log10(abs(sinc(x)));
%subplot(2,2,3); plot(x,y_dB); 
%hold on
%subplot(2,2,4); plot(x,y_dB);
%hold on
subplot(2,2,3); plot(x*1e3,y_AZ_dB);title('Mathematic beam profile aziimuth');xlabel('mm');ylabel('Amplitude dB');
subplot(2,2,4); plot(x*1e3,y_EL_dB);title('Mathematic beam profile elevation');xlabel('mm');ylabel('Amplitude dB');

%% task 4
figure(4)
powEstAZ_red=sum(AZ_red.RF.^2,1);
powEstEL_red=sum(EL_red.RF.^2,1);

pdB_norm_AZ_red=powEstAZ_red/max(powEstAZ_red); %normalizing the intensity in dB
pdB_norm_EL_red=powEstEL_red/max(powEstEL_red);
   
subplot(2,1,1);plot(AZ_full.Position(1,:)*1e3,10*log10(pdB_norm_AZ_red)); title('Intensity Azimuth reduced aperture');xlabel('AZ X-axis'); ylabel('powEst');
subplot(2,1,2);plot(EL_full.Position(2,:)*1e3,10*log10(pdB_norm_EL_red)); title('Intensity Elevation reduced aperture');xlabel('EL Y-axis'); ylabel('powEst');

%% task 5
figure(5)
powEst_z_axis=sum(z_axis.RF.^2,1);%the power of the beam
pdB_norm_z_axis=powEst_z_axis/max(powEst_z_axis);
mm_z_axis=z_axis.Position(3,:).*1e3;%z axis in mm
plot(mm_z_axis,10*log10(pdB_norm_z_axis)) ; title('Beamprofile along z-axis'); xlabel('mm'); ylabel('Power [dB]');

%% task 6
figure(6)
timescale=AZ_full.Position(4,1)+AZ_full.Ts(1).*[1:size(AZ_full.RF,1)]; 
speedofsound=1550; 
depthscale=timescale*speedofsound*1e3;%mm s=v*t
azimuthpositionscale=AZ_full.Position(1,:).*1e3;%azimuth scale in mm


subplot(2,1,1);imagesc(azimuthpositionscale, depthscale,AZ_full.RF);%negative pressure>dark, positive> bright
colormap(gray); title('full aperture');

subplot(2,1,2);imagesc(azimuthpositionscale, depthscale,AZ_red.RF);%negative pressure>dark, positive> bright
colormap(gray); title('reduced aperture');



