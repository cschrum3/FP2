function [postNoise] = wiener(preNoise,musicBlock)

%Sxy = abs(cpsd(preNoise,preSignal,[],[],(length(preNoise) * 2) - 1));
[Ss,~] = periodogram(musicBlock',[],(length(musicBlock) * 2) - 1);
[Sxx,~] = periodogram(preNoise',[],(length(musicBlock) * 2) - 1);

postNoise = Ss./(Ss + Sxx);
postNoise = postNoise';
postNoise = dsp.IFFT(postNoise,length(musicBlock));

% Plot Filter DFT
plot(postNoise');
title('Weiner Filter Spectrum')

end