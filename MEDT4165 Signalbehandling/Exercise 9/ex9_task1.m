%% --- LOAD DATA ---
load('slowmotion.mat');

IQMatMiddle = iq(:,ceil(end/2),:);
IQMatMiddle = squeeze(IQMatMiddle);
length(IQMatMiddle)
%% --- Make M-mode image ---

depthInc = s.iq.DepthIncrementIQ_m;

gain = 0;
dyn = 100;

c = 1540;

y = 0:depthInc:depthInc*size(IQMatMiddle,1)-depthInc;
t = 0:1/s.Framerate_fps:size(IQMatMiddle,2)/s.Framerate_fps-1/s.Framerate_fps;

T = 0.9023;
t0 = 0.0712;
R = 0.0065;
L = 0.1;

r = -R*cos(2*pi*(t-t0)/T) + L;

figure(1);
colormap(gray);
imagesc(t, y, 20*log10(abs(IQMatMiddle)));
hold on;
plot(t,r,'r-');
xlabel('Time [s]');
ylabel('Depth [m]');
title('Sample data over time');
caxis([-gain, -gain+dyn]);

% Input function to find period
% [tT,yT] = ginput(2);

% Find time of first top t0
% [t0, yt0] = ginput(1);

% Find amplitude yR to find R
% [tR, yR] = ginput(2);



%% --- PROBLEM 2 - plot r' ---

rd = 2*pi*R/T*sin(2*pi*(t-t0)/T);

figure(2);
plot(t,rd,'b');
title('r''(t)');
xlabel('Time [s]');
ylabel('Amplitude [m]');

%% --- P2 - estimate velocity ---

IQ42 = IQMatMiddle(:,42);
IQ43 = IQMatMiddle(:,43);

rd42 = 2*pi*R/T*sin(2*pi*(42/s.Framerate_fps-t0)/T);
rd43 = 2*pi*R/T*sin(2*pi*(43/s.Framerate_fps-t0)/T);

rDifference = rd43/s.Framerate_fps - rd42/s.Framerate_fps;

timeshift = 2*rDifference/c;

%% --- P2 Convert to RF ---

fs = 2e8;

rf42 = iq2rf(IQ42, s.iq.fDemodIQ_Hz, s.iq.frsIQ_Hz, fs);
rf43 = iq2rf(IQ43, s.iq.fDemodIQ_Hz, s.iq.frsIQ_Hz, fs);

t2 = 1:length(rf42);

figure(3);
plot(t2/fs*10^9, rf42, 'b:');
hold on;
plot(t2/fs*10^9, rf43, 'k--');
xlabel('Time [ns]');
ylabel('Amplitude');
title('RF data');
legend('Frame 42','Frame 43');


%% -- Part 3 - Autocorrelation --



