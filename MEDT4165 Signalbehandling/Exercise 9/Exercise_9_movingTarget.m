delete all
clear all
%% task 1
slowMot=load('slowmotion.mat');
iq_data=slowMot.iq; %SAMPLES x BEAMS x FRAMES 

beamnumber=4;%center beam 
c=1450; %m/s

figure(1)
iq_data_matrix=squeeze([iq_data(:,beamnumber,:)]); %Se kommentar
%{
velger beam nr 4
squeeze fjerner 1 dimensjon vektor, idette tilfelle fjerner den beam nr 4
uten å påvirke resten av matrisen<
%}
%usikker på dimensjonene
startDepth=slowMot.s.iq.StartDepthIQ_m;
IQ_TimeAxis=linspace(0, slowMot.s.iq.FramesIQ -1,slowMot.s.iq.FramesIQ)/slowMot.s.Framerate_fps; %t
IQ_DistanceAxis=linspace(0,slowMot.s.iq.SamplesIQ -1,slowMot.s.iq.SamplesIQ)*slowMot.s.iq.DepthIncrementIQ_m + startDepth;
imagesc(IQ_TimeAxis,IQ_DistanceAxis,20*log10(abs(iq_data_matrix))); 
title(['M-mode of IQ beamnr:',num2str(beamnumber)]); colormap(gray);
xlabel('Time [s]'); ylabel('Depth[m]');
caxis([-50 0] +90);

%estimere utslag, middelverdi, periode og fase til oscillasjonen
[x,y]=ginput(3); %p1=toppunkt,p2=nestetoppunkt, p3=bunnpunkt mellom p1 og p2
T=abs(x(2))-abs(x(1));
R=(abs(y(3))-abs(y(1)))/2; 
t0=0.02;%T*length(IQ_TimeAxis);
L=10e-2; %cm

%t=0:1/length(IQ_TimeAxis):length(IQ_TimeAxis);
%Assuming R<<L:
r=-R*cos(2*pi*(IQ_TimeAxis-t0)/T) + L;
grid on
hold on
plot(IQ_TimeAxis,r,'r');

%% Task 2
%For the velocity:
v=2*pi*R/T*sin(2*pi*(IQ_TimeAxis-t0)/T);
figure(2)
plot(IQ_TimeAxis,v,'b'); xlabel('Time [s]'); ylabel('velocity [m/s]');
title('analytical expression d/dt(r(t))');
%centerBeams=[iq_data(:,beamnumber,42:43)];
framebeam43=[iq_data(:,beamnumber,43)]; %x(t)
framebeam42=[iq_data(:,beamnumber,42)]; %y(t)

%Estimating velocity for frame 42 and 43
v42 = 2*pi*R/T*cos(2*pi*(IQ_TimeAxis(42)-t0)/T);
v43 = 2*pi*R/T*cos(2*pi*(IQ_TimeAxis(43)-t0)/T);
radial_displacement= v43/slowMot.s.Framerate_fps - v42/slowMot.s.Framerate_fps;
timeshift = 2*radial_displacement/c;

figure(3)
fs_rf=2e8;
%RF_data=iq2rf(squeeze(centerBeams),slowMot.s.iq.fDemodIQ_Hz,(1/T)*2,200);
RF_data_beam42=iq2rf(squeeze(framebeam42),slowMot.s.iq.fDemodIQ_Hz,slowMot.s.iq.frsIQ_Hz,fs_rf);
RF_data_beam43=iq2rf(squeeze(framebeam43),slowMot.s.iq.fDemodIQ_Hz,slowMot.s.iq.frsIQ_Hz,fs_rf);
t_rf=1:length(RF_data_beam42);  

plot(t_rf/fs_rf*10e9,RF_data_beam42,'b');
hold on
grid on
plot(t_rf/fs_rf*10e9,RF_data_beam43,'r');
title('RF data; beam from frame43(r) and frame42(b)'); xlabel('Time [ns]'); ylabel('Amplitude'); 

