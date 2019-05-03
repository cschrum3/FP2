%% Adaptive Noise Filter
%% Init
Fs = 44100; %Sample Rate
timeStep = 0.001; %Window Time step
blockSize = round(Fs * timeStep); %Blocksize
SNR = .1;
duration = 5;

%% Create recording objects
ambientRec = audiorecorder(44100,16,1,0); % Records Noise from Internal microphone
musicRec = audiorecorder(44100,16,1,2); % Records muisc from AudioInterface

%% Create first audio block
recordblocking(musicRec,duration);
musicBlock = getaudiodata(musicRec)';

%% Create Additive Noise
var = 2;
switch var
    case 1
        type = 'white';
    case 2
        type = 'pink';
    case 3
        type = 'blue';
end
Noise = generateNoise(length(musicBlock),type,1);
%% Create audio block (1ms)
%while (~isempty(musicBlock))
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
  % post-filter Noise vs. original Audio
      figure
      subplot(2,1,1)
      plot(musicBlock)
      title('post-filter Noise')
      subplot(2,1,2)
      plot(postSignal)
      title('original Audio')
%%    
    % playback
      soundsc(postSignal, Fs);
    % create new block
      recordblocking(musicRec,.1);
      musicBlock = getaudiodata(musicRec)';
%end

%% Error Estimation

e = xcorr(postNoise,musicBlock);
Error = abs(sum(e))^2 / 100;
plot(e);


%% Adjustments
%
%  change SNR for Noise Generation
%
%  change Noise Type 
%
%  