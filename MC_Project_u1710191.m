clc
close all
clear

%Importing audio file into program
%y - matrix of audio file, Fs - frequency of the sample

[y, Fs] = audioread('sample.wav');

info = audioinfo('sample.wav');

%plot(y); %graph of initial sample

Fc = 8820; %Carrier frequency
Fdev = 2205; %Frequency deviation

%sound for testing purposes only
%sound(y, Fs);

sampleBinary = dec2bin(typecast(double(y(:)), 'uint8'),8) - '0';

%Frequency modulation
z = fmmod(y, Fc, Fs, Fdev);

%plot(z);

for i = [0, 1, 2, 3, 4, 5]
    
    AWGNsample = awgn(z, i * 2, 'measured');


    %Frequency demodulation
    result = fmdemod(AWGNsample, Fc, Fs, Fdev);
    %plot(result);

    noiseSampleBinary = dec2bin(typecast(double(result(:)), 'uint8'),8) - '0';
    
    sampleBER(i + 1) = biterr(sampleBinary,noiseSampleBinary);
    %disp(sampleBER);

    %saving noisy sample to the file
    audiowrite(['sampleSNR_' num2str(i * 2) 'db_test.wav'], result, Fs);
end

semilogy([0, 2, 4, 6, 8, 10], sampleBER);
set(gca, 'YScale', 'log');
xlabel('E_b/N_0 (dB)'); 
ylabel('BER');
title('BER vs SNR');
grid on;

