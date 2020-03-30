%{
The main application of Doppler in medical imaging is to measure blood flow. The data we have used so far
are not realistic for blood flow measurements. The file Dopplerdata.mat contains a dataset with realistic
Doppler data. Use the command load Dopplerdata.mat to load the file into Matlab. The variables in the
file are:

iq: IQ-demodulated data, 103 range samples x 2032 beams
prf: pulse repetition frequency 2.5 kHz
f0: pulse frequency 2.5 MHz
fs: sampling frequency along the axis , 10 MHz

Use the same code as in part 4 to generate the Doppler spectrum. Use a depth segment of about 10
samples (ex. depthindex=[70:80]) and Nfft=256. Make a logarithmic greyscale image. Vary the length of
the segment between 8, 16, 32 og 64. Find a combination of segment length, high-pass filter settings and
logarithmic compression that gives the best Doppler spectrum. The dataset contains a lot of aliasing. Stack
3 spectra on top of each other to ease interpretation. What is the maximum velocity in the data. What is
the Nyquist limit? What PRF is needed to avoid the aliasing?
%}
clear all;
dopplerData=load('Dopplerdata.mat');
%% Variables
frames=size(dopplerData.iq,2); %iq = samples X frames
framerate=dopplerData.prf/frames; 
depthindex=1:size(dopplerData.iq,1);
iqmm=dopplerData.iq;
Nfft=256; %Zeropadding to length 64
crop=30; %length of M-mode data
P=zeros(Nfft, frames-crop+1); %f 

%% clutter filter
% A simple lowpass filter:
N=5; %rectangular window
%b=ones(1,N); %=boxcar(N). May also use hamming(N), hanning(N), ....
b=hamming(N);
b=b/sum(b); %Normalization of filter coefficients
iq_lp=filter(b,1,iqmm,[],2); %Filter along rows
iq_hp=iqmm-iq_lp; %Subtract low pass component:

iqmm=iq_hp;
%% Doppler data processing
for n=1:frames-crop+1,
iqsegm=iqmm(depthindex,n+[0:crop-1])';%chosing same sample for different frames
iqsegm=iqsegm.*(hamming(crop)*ones(1,length(depthindex)));%applying the hamming window on the segments 16, and rst are 1's
P(:,n)=mean(abs(fftshift(fft(iqsegm(:,[70:80]),Nfft))).^2,2); %64 point fft of the segment and taking the average of the segment.
end

%% Plots and axis

%Time axis
timeaxis=[1:frames].*(1/dopplerData.fs); %time=frames*period

%Frequency axis
frequencyaxis=(([0:Nfft-1]/Nfft)-0.5);%compressing 256 values from -0.5 to 0.5, meaning its normalized
frequencyaxis=[frequencyaxis-1, frequencyaxis, frequencyaxis+1]*dopplerData.prf; % instead of *framerate

%% Signle doppler data
frequencyaxis=(([0:Nfft-1]/Nfft)-0.5)*framerate;
%Grayscale image of frequency specter in dB
Pdb=10*log10(abs(P));
figure(1), imagesc(timeaxis, frequencyaxis, Pdb);
title(['Single doppler data with crop=',num2str(crop)]); xlabel('Time [sec]'); ylabel('Frequency [Hz]');
colormap(gray);
caxis([-40 0] +70);

%% tripple doppler data
P_tripple=[P;P;P];
frequencyaxis=(([0:Nfft-1]/Nfft)-0.5);%compressing 256 values from -0.5 to 0.5, meaning its normalized
frequencyaxis=[frequencyaxis-1, frequencyaxis, frequencyaxis+1]*dopplerData.prf; % instead of *framerate
P_tripple=10*log10(abs(P_tripple));
figure(2), imagesc(timeaxis, frequencyaxis, P_tripple);
title(['Tripple Doppler data with crop=',num2str(crop)]); xlabel('Time [sec]'); ylabel('Frequency [Hz]');
colormap(gray);
caxis([-40 0] +70);

%% Maximum velocity
fd=3447;
c=1540;
maxVel=(fd*c)/(2*dopplerData.f0)
V_nyq=(c*dopplerData.prf)/(4*dopplerData.f0)