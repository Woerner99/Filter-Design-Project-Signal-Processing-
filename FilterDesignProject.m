% Sean-Michael Woerner
% 1001229459
% 12/3/2020



%{
Filter Design Project

Description:
In this project, you will be designing a filter to remove unwanted noise 
from an audio file.You will accomplish with the paper design of a 
Butterworthlowpass filter.  The designed filter will then be implemented in
MATLAB and used to filter the audio and compare to the unfiltered audio.

Parts:
(1) Audio Frequency Analysis
(2) Filter Desgin
(3) Filter Implementation
(4) Report (attached pdf)

Included:
-Signal Processing Toolbox for MATLAB (specifically used for butterworth
filter implementaion)
-noisyaudio.wav (audio file that we will be filtering)

Outputs:
-Plots of: 
    .Magnitude of original DFT vs Frequency
    .Normalized Log Plot of original DFT
    .Logarithmic Gain vs Frequency of original DFT
    .Magnitude of new DFT vs Frequency 
-Filtered audio file: filteredaudio.wav
%}



clc 
clear
close all


% 1. Audio Frequency Analysis
audioFileName = 'noisyaudio.wav';
[y,Fs] = audioread(audioFileName);
audio_DFT = fft(y);

% form a freq axis for plotting the DFT
freqAxis = linspace(-(Fs/2),(Fs/2),length(y));

% plot the magnitude DFT vs frequency
subplot(2,2,1);

plot(freqAxis,fftshift(abs(audio_DFT)));
xlabel('Frequency (Hz)');
ylabel('Magnitude of DFT');
title(' Magnitude of Original DFT vs Frequency');


% Plot the normalized log plot of the DFT. Max value of DFT is 0dB
db = 20.*log10(abs(audio_DFT)/max(abs(audio_DFT)));
subplot(2,2,2);
plot(freqAxis,fftshift(db));
xlabel('Frequency (Hz)');
ylabel('Magnitude of DFT [dB]');
title(' Normalized Log Plot of DFT');


% 2. Filter Design
% Wp = end of the pass band, Ws = beginning of stop band
Wp = 1900; % 1.9 kHz
Ws = 2500; % 2.5 kHz
Rp = -1; % -1 db
Rs = -60; % -60 db
minAtten = .5;

% Solve for the nth order
args = (10.^(-Rs/10) - 1) / (10.^(-Rp/10) - 1);
N = (log10(args)) / (2*log10(Ws/Wp));
N_rounded = round(double(N))+1;
FqCutOff = Wp/(10^(-Rp/10)-1)^(1/(2*N_rounded));

% Find Ha(s)
Ha_s = 20*log10(sqrt(1./(1+(freqAxis/FqCutOff).^(2*N_rounded))));

% plot the log gain and bandpass filter
subplot(2, 2, 3);
plot(freqAxis, Ha_s);
xlabel('Frequency [Hz]');
ylabel('Magnitude [dB]');
title('Logarithmic Gain vs Frequency of DFT');

% 3. Filter Implementation

% first find Wn 
Wn = FqCutOff/(Fs/2);
[b,a] = butter(N_rounded, Wn);
new_audio_DFT = fft(filter(b,a,y));

% plot the filtered signal:
subplot(2, 2, 4);
plot(freqAxis,fftshift(abs(new_audio_DFT)));
xlabel('Frequency (Hz)');
ylabel('Magnitude of DFT');
title(' Magnitude of new DFT vs Frequency');

%==============================================
% We have everything we need, now play the user the original audio and
% then the filtered audio.
% I have also included two extra audio file prompts that inform the user
% which audio file is about to be played.

% Prompt 1 for original audio file
[q,Gs] = audioread('prompt1.mp3');
sound(q,Gs);
pause(2);
% Play noisyaudio.wav
sound(y,Fs);
pause(12);

% Prompt 2 for filtered audio file
[q,Gs] = audioread('prompt2.mp3');
sound(q,Gs);
pause(2);
% play the filtered audio:
sound(filter(b,a,y),Fs);
% write new audio to a file
audiowrite('filteredaudio.wav',filter(b,a,y),Fs);

% EXTRA CREDIT:
% This audio is from a clip in the movie called: "Airplane", 1980


