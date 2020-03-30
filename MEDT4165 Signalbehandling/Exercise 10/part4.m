%{
Load the middle beam from the file fastmotion.mat. Repeat the processing as in the previous part, and
make an image. Comment on what happens.

Make another image by stacking the Doppler spectrum three times (P=[P;P;P];). Extend the Doppler
axis appropriately:
frequencyaxis=([0:Nfft-1]/Nfft)-0.5;
frequencyaxis=[frequencyaxis-1, frequencyaxis, frequencyaxis+1]*framerate;
Indicate the Nyquist limit in the image (positive and negative).
%}
clear all;
load('fastmotion.mat');
frames=s.iq.FramesIQ;
depthindex=1:142;%sample nr of the segment
framerate=s.Framerate_fps;
timeaxis = ([1:frames].*s.iq.DepthIncrementIQ_m) + s.iq.StartDepthIQ_m;

iqmm = squeeze(iq(:,round(end/2),:)); %chosing the middle beam for each frame, so this is sample x frames
Nfft=64; %Zeropadding to length 64
crop=16; %length of M-mode data
P=zeros(Nfft, frames-crop+1); %frames-crop=418 
for n=1:frames-crop+1,
iqsegm=iqmm(depthindex,n+[0:crop-1])';%chosing same sample for different frames
iqsegm=iqsegm.*(hamming(crop)*ones(1,length(depthindex)));%applying the hamming window on the segments 16, and rst are 1's
P(:,n)=mean(abs(fftshift(fft(iqsegm,Nfft))).^2,2); %64 point fft of the segment and taking the average of the segment.
end
%P is a matrix containing the fft of the different frames but at fixed sample
%rows contains the data for each frame

%Frequency axis
frequencyaxis=(([0:Nfft-1]/Nfft)-0.5); %compressing 256 values from -0.5 to 0.5, meaning its normalized
frequencyaxis=[frequencyaxis-1, frequencyaxis, frequencyaxis+1]*framerate; %this is not normalized
%Grayscale image of frequency specter in dB
P=[P;P;P];
Pdb=10*log10(abs(P));
figure(1), imagesc(timeaxis, frequencyaxis, Pdb);
title('Fastmotion data'); xlabel('Time [sec]'); ylabel('Frequency [Hz]');
colormap(gray);
caxis([-40 0] +90);
