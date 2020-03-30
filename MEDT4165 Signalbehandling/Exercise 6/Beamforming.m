clear all; 
simdata=load('SimData.mat');
c=1540; %m/s
%% task 1
x0=0;%start pos
depth=0.01; %m
figure(1)
imagesc(1:length(simdata.elPosX),simdata.RF_t,20*log10(abs(simdata.RFdata)));
title('Recieved wavefronts'); xlabel('channel nr'); ylabel('time [s]'); 
hold on
TOF_single=sqrt((x0-simdata.elPosX).^2+(depth.^2))/c + depth/c;
plot(1:length(simdata.elPosX),TOF_single,'r');

x = linspace( -2e-2, 2e-2, 256); %x-coordinates
z = linspace( 0, 4.5e-2, 512); %z-coordinates
[X, Z] = meshgrid(x,z); %make X and Z matrices

% initialize TOF-matrix
TOF = zeros( length(z), length(x), length(simdata.elPosX));
elPosX=permute(simdata.elPosX,[3,2,1]);%endre rekkefølgen på dimensjonene
TOF=sqrt((X-elPosX).^2+(Z.^2))/c + Z/c;

%% task 2
delayedData = interpTOF( simdata.RFdata, simdata.RF_t, TOF);  
%delayedData=[channels, z, x]
%we are gathering signal from diffrent TOFs(hence scattering point), and plotting them,
%the reason for doing this is to separate the TOFs for different
%scatteringpoints
figure(2)
imagesc(delayedData(:,:,128).');
title('Interpolated Data'); xlabel('channels'); ylabel('z = 512 points');

figure(3)

%ch=32;
%hammingVector=permute(hamming(ch),[2,1]);
%hammingVector=[zeros(1,(128-ch)/2),hammingVector,zeros(1,(128-ch)/2)];
%delayedDataHamming=delayedData.*permute(hammingVector,[2,1]);

%ch=32;
%hammingVector=permute(hamming(ch),[2,1]); 
%hammingVector=[hammingVector,zeros(1,128-32)];
%delayedDataHamming=delayedData.*permute(hammingVector,[2,1]);

delayedDataHamming=delayedData.*hamming(128);
sumDelayedData=sum(delayedDataHamming);
bf_data=squeeze(sumDelayedData); %her summerer vi dataen mot et punkt, med squeeze 
%fjerner vi dimensjonen som har 1
envelope=abs(hilbert(bf_data));
imagesc(20*log10(envelope));
caxis([-50 0] -0);
title('Beamformed Data'); xlabel('aperture'); ylabel('depth');

%% task 3
figure(4)
fnumber=0.25;
%apod=generateApod(simdata.elPosX, xpos, z, fnumber);
channelNum=1:128;
%sum=0;

    for i=1:length(x) %1 to 256
        apod(i,:,:)=generateApod(simdata.elPosX, x(i), z, fnumber); %apod gives [channels, z]
        %apodsum=sum+apod;%summing data from all the channels and z for diff. x
    end
    
apodPermute=permute(apod,[2,3,1]).*delayedData;
apodPermuteSum=sum(apodPermute);
bf_apod=squeeze(apodPermuteSum);
apod_envelope=abs(hilbert(bf_apod));

%imagesc(z*1e3,channelNum,20*log10(abs(apod)));%1e3-->mm, 20*log10-->dB
imagesc(20*log10(apod_envelope));
caxis([-50 0] +10); 
%colormap(gray);
title(' Expanding Aperture with F#=0.25 for different x');xlabel('channel nr');ylabel('Depth [mm]');

%% task 4
%Generate an ultrasound image from the in vivo channel data.
%Select an appropriate Fnumber and use expanding aperture. 
%Also select appropriate dynamic range and gain
%and plot your image. Use axis equal to ensure that the aspect of the image is
%correct. The acquisition is taken from the carotid bifurcation, where the carotid artery
%splits into two arteries: the interna, which supplies the brain, and the externa, which
%supplies the face.
figure(5)

invivo=load('invivoData.mat');
xvivo = linspace( -2e-2, 2e-2, 256); %x-coordinates
zvivo = linspace( 0, 4.5e-2, 512); %z-coordinates
[Xvivo, Zvivo] = meshgrid(xvivo,zvivo); %make X and Z matrices

% initialize TOF-matrix
TOF_vivo = zeros( length(zvivo), length(xvivo), length(invivo.elPosX));
elPosX_vivo=permute(invivo.elPosX,[3,2,1]);%endre rekkefølgen på dimensjonene
TOF_vivo=sqrt((Xvivo-elPosX_vivo).^2+(Zvivo.^2))/c + Zvivo/c;

%delayedData: interpolates channel data such that for each receive focus point 
%(x,z), the signal from this point is aligned across the different channels. 
%The output is the realigned data [channels, z, x]
delayedData_vivo = interpTOF( invivo.RFdata, invivo.RF_t, TOF_vivo);
fnumbervivo=4;

    for i=1:length(xvivo) %1 to 256
        apod(i,:,:)=generateApod(invivo.elPosX, xvivo(i), zvivo, fnumbervivo);
    end
        
apodPermuteVivo=permute(apod,[2,3,1]).*delayedData_vivo;
apodPermuteSumVivo=sum(apodPermuteVivo);
bf_apod_vivo=squeeze(apodPermuteSumVivo);
apod_envelope_vivo=abs(hilbert(bf_apod_vivo));

imagesc(20*log10(apod_envelope_vivo));
caxis([-45 0] +115); 
colormap(gray);
title(' Vivo Data Image');xlabel('channel nr');ylabel('Depth [mm]');