%% Audio Device
info = audiodevinfo; % Struct that contains internal audio device info and ID
%% Init
Fs = 44100; %Sample Rate
timeStep = 0.001; %Window Time step
blockSize = round(Fs * timeStep); %Blocksize
SNR = 1;
%% Create music input using audiorecorder
[music,Fs] = audioread('po35.wav'); %temporary music file load
plot(music) %plot waveform
%% Create recording objects
ambientRec = audiorecorder(44100,16,1,0); % Records Noise from Internal microphone
musicRec = audiorecorder(44100,16,1,0); % Records muisc from AudioInterface


recordblocking(musicRec,.1);
musicBlock = getaudiodata(musicRec)';

%% Create audio block (1ms)
while (~isempty(musicBlock))
  % get blocks
    recordblocking(ambientRec, .1);
  % turn to data
    ambientBlock = getaudiodata(ambientRec)';
  % check isempty
    
  % create noise
    Noise = generateNoise(length(musicBlock),'pink',1);
    Noise = step(Noise);
  % preNoise
    preNoise = ambientBlock + Noise;
  % preSignal
    preSignal = preNoise + musicBlock;
  % postNoise
    [postNoise] = wiener2(preNoise,[1,44100]);
    post
  % postSignal
    postSignal = preSignal - postNoise;
    
% Test plots

  % inputs
    figure 
    subplot(2,1,1)
    plot(ambientBlock)
    title('ambient noise')
    subplot(2,1,2)
    plot(musicBlock)
    title('music block')
    
  % noise  
    figure
    subplot(2,1,1)
    plot(preNoise)
    title('pre noise')
    subplot(2,1,2)
    plot(postNoise)
    title('post noise')
%%    
  % signals
    figure
    subplot(2,1,1)
    plot(preSignal)
    title('preSignal')
    subplot(2,1,2)
    plot(postSignal)
    title('postSignal')
    
%%    
  % playback
    soundsc(postSignal, Fs);
  % create new block
    recordblocking(musicRec,.1);
    musicBlock = getaudiodata(musicRec)';
end

%% Error Estimation

e = xcorr(postNoise,musicBlock);
Error = abs(sum(e))^2 / 100;
plot(e);

