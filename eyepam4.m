% Define parameters
N = 10000; % Number of symbols
T = 1e-9; % Symbol duration
A = 1; % Amplitude
SNR = 10; % Signal-to-Noise Ratio

% Generate random binary data
data = randi([0 1], N, 1);

% Convert binary data to PAM4 symbols
symbols = 2*data(1:2:end) + data(2:2:end);

% Upsample PAM4 symbols
tx = repelem(symbols, ceil(T/(2*length(symbols))));

% Define pulse shape
t = linspace(0, T, length(tx));
p = 1/sqrt(T)*rectpuls(t-T/2, T);

% Transmit PAM4 signal with added noise
rx = awgn(A*conv(tx, p, 'same'), SNR, 'measured');

% Matched filtering and downsampling
r = conv(rx, fliplr(p), 'same');
r = r(1:ceil(T/(2*length(symbols))):end);

% Decode PAM4 symbols
decoded = zeros(N, 1);
decoded(symbols == 0) = 1;
decoded(symbols == 1) = -1;
decoded(symbols == 2) = 3;
decoded(symbols == 3) = -3;

% Plot normal plot and eye diagram
figure;
subplot(2,1,1);
plot(t, tx);
hold on;
plot(t, rx);
legend('Transmitted', 'Received');
xlabel('Time (s)');
ylabel('Amplitude');
title('PAM4 Signal with Added Noise');

subplot(2,1,2);
eyediagram(r, ceil(T/(2*length(symbols))));
xlabel('Time (s)');
ylabel('Amplitude');
title('Eye Diagram of Received PAM4 Signal');