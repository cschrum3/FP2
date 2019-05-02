function Noise = generateNoise(length,type,SNR)

switch type
    case 'white'
        z = 10^(SNR/10); % Linearize SNR from dB value 
        No = 1; 
        T = 2; % Chosen so that var = N0*T/2 = 1
        % SNR linear = ((A^2)*T)/No 
        A =  abs(sqrt(No*z/T)); 
        Noise = A*rand(1,length);
    case 'pink'
        Noise = dsp.ColoredNoise('Color','pink','SamplesPerFrame',length,'NumChannels',1);
end

end