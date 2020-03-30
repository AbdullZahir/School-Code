clear all;
load('slowmotion_clutter.mat');

frames=s.iq.FramesIQ;
depthindex=1:142;%sample nr of the segment
framerate=s.Framerate_fps;

iqmm = squeeze(iq(:,round(end/2),:)); %chosing the middle beam for each frame, so this is sample x frames
Nfft=64; %Zeropadding to length 64
crop=16; %length of M-mode data
P=zeros(Nfft, frames-crop+1); %frames-crop=418 

%% HIGH PASS FILTER to remove clutter 
%{
To remove the clutter, a high pass filter is used in the block diagram for the PW Doppler system. Use a
highpass filter to filter the data in ”‘slow time”’ and make a new Dopplerspectrum. How does the spectrum
look now? Vary the length of the filter from N=2 til N=10. What is the optimal length to remove all the
clutter?
Tip: A simple and intuitive way to highpass filter the signal, is to first make a lowpass filter (that is to
take the average of N samples) and then subtract this from the data:
%}
% A simple lowpass filter:
N=5; %rectangular window
%b=ones(1,N); %=boxcar(N). May also use hamming(N), hanning(N), ....
b=hamming(N);
b=b/sum(b); %Normalization of filter coefficients
iq_lp=filter(b,1,iqmm,[],2); %Filter along rows
iq_hp=iqmm-iq_lp; %Subtract low pass component:

%% The doppler data
for n=1:frames-crop+1,
%iqsegm=iqmm(depthindex,n+[0:crop-1])';%chosing same sample for different frames
iqsegm=iq_hp(depthindex,n+[0:crop-1])';
iqsegm=iqsegm.*(hamming(crop)*ones(1,length(depthindex)));%applying the hamming window on the segments 16, and rst are 1's
P(:,n)=mean(abs(fftshift(fft(iqsegm,Nfft))).^2,2); %64 point fft of the segment and taking the average of the segment.
end
%P is a matrix containing the fft of the different frames but at fixed sample
%rows contains the data for each frame

%% PLOTS 
%Frequency axis
frequencyaxis=(([0:Nfft-1]/Nfft)-0.5);
frequencyaxis=[frequencyaxis-1, frequencyaxis, frequencyaxis+1]*framerate;

%Time axis
%timeaxis = ([1:frames].*s.iq.DepthIncrementIQ_m) + s.iq.StartDepthIQ_m;
timeaxis=[1:s.iq.FramesIQ]/s.Framerate_fps;

%Depth axis
depthaxis=depthindex;

%Grayscale image of frequency specter in dB
%P=[P;P;P];
Pdb=10*log10(abs(P));
figure(1), imagesc(timeaxis, depthaxis,20*log10(abs(iq_hp)));
title('Clutter filtered Slowmotion data'); xlabel('Time [sec]'); ylabel('Depth [m]');
colormap(gray);
caxis([-40 0] +90);

figure(2)
imagesc(timeaxis, frequencyaxis, 10*log10(abs(P)));
title('M-mode filtered data'); xlabel('Time [sec]'); ylabel('Frequency [Hz]');
colormap(gray);
caxis([-40 0] +90);