%% task 1
horizontal_black=imread('horizontal.black.bmp'); 
horizontal_white=imread('horizontal.white.bmp'); 
horizontal_white_thick=imread('horizontal.white.thick.bmp'); 
vertical_black=imread('vertical.black.bmp'); 
vertical_white=imread('vertical.white.bmp');
vertical_white_thick=imread('vertical.white.thick.bmp');
white_tilted=imread('white.tilted.bmp');
lena=imread('lena.jpg');

%% task 2
filename=vertical_black;
figure(1)
subplot(1,2,1);
imagesc(20*log10(double(filename)));title('Original object/picture') 
colormap(gray(255));% 32-bit 

%% task 3
subplot(1,2,2);
fft_image=fft2(filename);
fft_norm_image=abs(fftshift(fft_image)./max(abs(fftshift((fft_image(:))))));
%{ 
taking the max value of the whole image using (:)
%this is because we want to normalize the image with one maxiumun value and
%not the maxiumum value in x and y direction. So now we are normalizing
%with the highest value of the image, which is either in x or y direction
%}

normGs = fft_norm_image;%the normalized Fourier transform of the image
dynRange = 60; % dynamic range in dB
NGray = 255; % number of grays in colormap.
imagePowerSpecter = NGray*(1 + 20*log10(normGs)/dynRange);
%{
limiting the picture to the 
dynamic range and excluding everything else
%}
colormap(gray);
image(imagePowerSpecter);
title('2D normalized FFT of original object/picture');
%{
In ultrasound imaging we lose information where the energy of the image is
high. This is due to the fact that ultrasound acts like a highpass filter,
and hence removing the lowest frequency. The highest power of the image is in the low
frequency in the fourier domain of the image/picture.
%}

%% part 2
figure(3) 
subplot(1,2,1);
dx=0.3/(300); %sample points in the x direction(30cm=0.3m devided by 300 point in that direcion)
fx=1/dx; % samplerate in x direction 
dy=0.3/300; %sample point in the y direction 
fy=1/dy; %samplerate in y direction
Kx=linspace(-fx/2, fx/2, length(lena)+1); Kx(end)=[]; %nylquits samplingstheorem
Ky=linspace(-fy/2, fy/2, length(lena)+1); Ky(end)=[];

%task 2 
image(lena);title('Original lena.jpg'); 
%axis([0 Kx 0 Ky]);
colormap(gray(255));

%Point spread funtion!
%{
the point spread function is the realistic pixel(impuls respons) of 
a single pixel in the object. So to imagine it, remove all the pixel in the
object with the psf, then we get the image of the object!
%} 

subplot(1,2,2)
fft_lena=fft2(double(lena));
%image(abs(fftshift(fft_lena)));%shifting the lowest freq. to the middle of the image
fft_norm_image_lena=abs(fftshift(fft_lena)./max(abs(fftshift((fft_lena(:))))));
normGs_lena = fft_norm_image_lena;%the normalized Fourier transform of the image
dynRange = 60; % dynamic range in dB
NGray = 255; % number of grays in colormap.
imagePowerSpecter_lena = NGray*(1 + 20*log10(normGs_lena)/dynRange);
image(Kx,Ky,imagePowerSpecter_lena);
title('2D normalized FFT of original lena.jpg');

%task 3&4
figure(4)
Nx = 5;
Ny = 5;
avgfilt = ones(Nx,Ny)/(Nx*Ny); 
subplot(1,2,1);
image(Nx,Ny,20*log10(avgfilt)); title('Avg filter'); 
%colormap(gray);

fft_filter=abs(fftshift(fft2(avgfilt,300,300))); 
fft_filter_norm=fft_filter/max(fft_filter(:));
normGs_filter =fft_filter_norm; %the normalized Fourier transform.
dynRange = 60; % dynamic range in dB
NGray = 255; % number of grays in colormap.
imagePowerSpecter_filter = NGray*(1 + 20*log10(normGs_filter)/dynRange);
subplot(1,2,2);
image(imagePowerSpecter_filter); title('2D FFT of Avg filter')
colormap(gray);

%task 5&6
figure(5)
lena_filtered_image=filter2(avgfilt,lena); %avgfilt from task 3
subplot(1,2,1);
colormap(gray(255));
image(lena_filtered_image); title('filtered lena image with filter2 with NyNx=5');

fft_lena_filtered_image=abs(fftshift(fft2(lena_filtered_image)));
fft_lena_filtered_image_norm=fft_lena_filtered_image/max(fft_lena_filtered_image);
normGs_filtered_lena = fft_lena_filtered_image_norm;%the normalized Fourier transform.
dynRange = 100; % dynamic range in dB
NGray = 255; % number of grays in colormap.
imagePowerSpecter_lena_filtered = NGray*(1 + 20*log10(normGs_filtered_lena)/dynRange); 
subplot(1,2,2);
image(Kx,Ky,imagePowerSpecter_lena_filtered);
title('2D FFT of filtered lena.jpg with Ny=Nx=5'); 
colormap(gray(255));

%task 7
%{
By vary the size of Nx and Ny, which in our case is the PSF. By making 
 PSF smaller, the picture gets better or the resolution increases. By
 making the PSF larger the picture becomes one big blob which is smeared
 out. This is due to the size of PSF, which in our case means how much we
 want a pixel to be averaged over, the how large is the reagion that we
 average and asign that pixel.
%}






