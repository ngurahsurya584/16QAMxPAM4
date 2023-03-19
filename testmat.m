% Define the parameters
data = randi([0 1], 1, 10000); % Random data points
pulse_shape = ones(1, 10); % Rectangular pulse shape
Fs = 100e6; % Sampling frequency
Ns = 1000; % Number of samples

% Convert random data to PAM4 levels
pam4_levels = 2*data(1:2:end) + data(2:2:end);

% Generate PAM4 signal
pam4_signal = conv(pulse_shape, pam4_levels);
pam4_signal = pam4_signal(1:Ns);

% Add impairments
noisy_signal = awgn(pam4_signal, 20); % Add 20dB of noise
jittered_signal = circshift(noisy_signal, 10); % Introduce 10-sample timing offset
isi_signal = conv(pam4_signal, [-1 1 0.5 -0.5]); % Introduce ISI

% Plot the signals
figure(1);
subplot(2, 1, 1);
plot(data);
title('Random data');
xlabel('Sample number');
ylabel('Data');
ylim([-0.1, 1.1]);

subplot(2, 1, 2);
plot(pam4_signal);
hold on;
plot(noisy_signal);
plot(jittered_signal);
plot(isi_signal);
title('PAM4 Signal with Impairments');
xlabel('Sample number');
ylabel('Amplitude');
legend('Ideal', 'Noisy', 'Jittered', 'ISI');