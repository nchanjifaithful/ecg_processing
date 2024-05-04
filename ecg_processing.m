% % Generate ECG signals - Method 1
% fs = 360; % Sampling frequency in Hz
% t = 0:1/fs:10; % Time vector in seconds
% f = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]; % Frequencies for QRS complexes
% a = [1,0.7,0.3,0.2,0.1,0.05,0.03,0.02,0.01,0.005,0.003,0.002,0.001,0.0005,0.0003]; % Amplitudes for QRS complexes
% ecg = zeros(size(t));
% for i = 1:length(f)
%     ecg = ecg + a(i)*sin(2*pi*f(i)*t);
% end
% 
% % Add noise
% %ecg = ecg + 0.1*randn(size(ecg));
% figure,
% plot(t, ecg);
% title('ECG Waveform');
% xlabel('Time (s)');
% ylabel('Amplitude (mV)');
% 
% 
% % Generate ECG signals - Method 2
% fs = 360;                      % Sampling rate (Hz)
% t = 0:1/fs:10;                  % Time vector for one heartbeat (s)
% num_beats = 10;                 % Number of heartbeats in the ECG signal
% ecg_template = zeros(size(t));  % Initialize ECG template as an array of zeros
% 
% % Generate ECG template for one heartbeat
% p_wave = 0.1*sin(2*pi*6*t);     % P wave (60 bpm)
% qrs_complex = 1*sin(2*pi*15*t) - 0.5*sin(2*pi*30*t);  % QRS complex
% t_wave = 0.25*sin(2*pi*3.3*t);  % T wave (72 bpm)
% ecg_template = p_wave + qrs_complex + t_wave;
% 
% % Add random noise to the ECG template
% ecg_template = ecg_template + 0.1*randn(size(ecg_template));
% 
% % Replicate the template for the desired duration
% ecg_signal = repmat(ecg_template, [1, num_beats]);
% 
% % Adjust the timing of each heartbeat
% rr_interval = 60/72;            % RR interval for 72 bpm (s)
% rr_intervals = rr_interval * ones(1, num_beats);  % RR intervals for all heartbeats
% r_positions = cumsum(rr_intervals);  % R-peak positions (s)
% r_indices = round(r_positions * fs);  % R-peak indices
% ecg_signal = circshift(ecg_signal, [0, r_indices(1)]);  % Shift the first heartbeat to the first R-peak position
% for i = 2:num_beats
%     ecg_signal(:, r_indices(i-1):end) = circshift(ecg_signal(:, r_indices(i-1):end), [0, r_indices(i) - r_indices(i-1)]);
% end
% 
% figure,
% % Plot the ECG waveform
% t = linspace(0, num_beats * rr_interval, length(ecg_signal));
% plot(t, ecg_signal);
% title('ECG Waveform (custom function)');
% xlabel('Time (s)');
% ylabel('Amplitude (mV)');

%%
% Load ECG data from local file
filename = '100.dat';
fid = fopen(filename, 'r');
ecg_signal = fread(fid, Inf, 'int16');
fclose(fid);
fs = 360;

% Plot one beat of the ECG waveform
beat_start = 1900; % Starting index of beat in signal
beat_end = 2600;   % Ending index of beat in signal
t = (beat_start:beat_end)/fs; % Time vector for beat
beat = ecg_signal(beat_start:beat_end); % Extract one beat of the ECG signal
figure;
plot(t, beat);
xlabel('Time (s)');
ylabel('Amplitude (mV)');
title('ECG Signal');
