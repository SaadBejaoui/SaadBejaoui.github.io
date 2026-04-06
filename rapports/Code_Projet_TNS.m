pkg load signal
%indicateur de perception pour qualite de son
#Banc de filtres
%1.
[s, fe] = audioread('voix_homme_8.wav');
l=1024;
f=(-l/2:l/2-1)*fe/l;
fc=fe/4;

%2.
b_rect = fir1(7, fc / (fe / 2), rectwin(8));
b_hamm = fir1(7, fc / (fe / 2), hamming(8));


hb_rect = filter(b_rect, 1, s);
hb_hamm = filter(b_hamm, 1, s);


%Signaux temporels

t = (0:length(s)-1) / fe;
figure;
subplot(3,1,1);
plot(t, s, 'k');
title('Signal Original');
xlabel('Temps (s)'); ylabel('Amplitude'); grid on;

subplot(3,1,2);
plot(t, hb_rect, 'b');
title('Signal Filtré (Rectwin)');
xlabel('Temps (s)'); ylabel('Amplitude'); grid on;

subplot(3,1,3);
plot(t, hb_hamm, 'r');
title('Signal Filtré (Hamming)');
xlabel('Temps (s)'); ylabel('Amplitude'); grid on;


%Spectres fréquentiels (subplots)

S = abs(fftshift(fft(s, l)));
S_rect = abs(fftshift(fft(hb_rect, l)));
S_hamm = abs(fftshift(fft(hb_hamm, l)));

figure;
subplot(3,1,1);
plot(f, S, 'k');
title('Spectre du signal original');
xlabel('Fréquence (Hz)'); ylabel('Amplitude'); grid on;

subplot(3,1,2);
plot(f, S_rect, 'b');
title('Spectre du signal filtré (Rectwin)');
xlabel('Fréquence (Hz)'); ylabel('Amplitude'); grid on;

subplot(3,1,3);
plot(f, S_hamm, 'r');
title('Spectre du signal filtré (Hamming)');
xlabel('Fréquence (Hz)'); ylabel('Amplitude'); grid on;


% 3. Réponses des filtres (gain et phase)

[h_rect, w] = freqz(b_rect, 1, l);
[h_hamm, ~] = freqz(b_hamm, 1, l);

%gain
figure;
subplot(2,1,1);
plot(w/(2*pi)*fe, abs(h_rect),'b', w/(2*pi)*fe, abs(h_hamm), 'r');
legend('Gain Rectwin', 'Gain Hamming');
xlabel('Fréquence (Hz)');
ylabel('|H(f)|');
title('Réponse en gain (ordre 7)');
grid on;

%phase
subplot(2,1,2);
plot(w, unwrap(angle(h_rect)),'b', w, unwrap(angle(h_hamm)), 'r');
legend('Phase Rectwin', 'Phase Hamming');
xlabel('Fréquence (Hz)');
ylabel('Phase (radians)');
title('Réponse en phase (ordre 7)');
grid on;

% 5. ordre 24
b_rect = fir1(24, fc/(fe/2), rectwin(25));
b_hamm = fir1(24, fc/(fe/2), hamming(25));
[h_rect, w] = freqz(b_rect, 1, l);
[h_hamm, ~] = freqz(b_hamm, 1, l);

%gain
figure;
subplot(2,1,1);
plot(w/(2*pi)*fe, abs(h_rect),'b', w/(2*pi)*fe, abs(h_hamm), 'r');
legend('Gain Rectwin', 'Gain Hamming');
xlabel('Fréquence (Hz)');
ylabel('|H(f)|');
title('Réponse en gain (ordre 24)');
grid on;

%phase
subplot(2,1,2);
plot(w/(2*pi)*fe, unwrap(angle(h_rect)), 'b', w/(2*pi)*fe, unwrap(angle(h_hamm)), 'r');
legend('Phase Rectwin', 'Phase Hamming');
xlabel('Fréquence (Hz)');
ylabel('Phase (radians)');
title('Réponse en phase (ordre 24)');
grid on;
%%%La fenêtre de Hamming est retenue pour son équilibre entre performance fréquentielle et réduction des distorsions, essentiel pour une restitution fidèle du signal.

% Application des filtres et visualisation
%6.
s1_hamm = filter(b_hamm, 1, s);
S1_hamm = abs(fftshift(fft(s1_hamm, l)));

figure;
plot(f, S1_hamm);
title('Spectre du signal BF (Hamming ordre 24)');
xlabel('Fréquence (Hz)');
ylabel('Magnitude');
grid on;


%7.
bh = fir1(24, fc / (fe / 2), hamming(25),'high');
[hh, w] = freqz(bh, 1, l);
figure;
subplot(2,1,1)
plot(w/(2*pi)*fe, abs(hh));
xlabel('Fréquence ');
ylabel('|H(f)|');
title('Gain Hamming passe haut');
grid on;
subplot(2,1,2)
plot(w/(2*pi)*fe, unwrap(angle(hh)));
xlabel('Fréquence ');
ylabel('Phase (radians)');
title('Phase');
grid on;

%8.
s2_hamm = filter(bh, 1, s);
S2_hamm = abs(fftshift(fft(s2_hamm, l)));

figure;
plot(f, S2_hamm);
title('Spectre du signal HF (Hamming ordre 24)');
xlabel('Fréquence (Hz)');
ylabel('Amplitude');
grid on;
%9.
s_r=s1_hamm+s2_hamm;

%10.
figure;
subplot(2,1,1);
plot(t, s, 'b');
title('Signal original');
xlabel('Temps (s)');
ylabel('Amplitude');
grid on;
subplot(2,1,2);
plot(t,s_r,'r');
title('Signal reconstruit');
xlabel('Temps (s)');
ylabel('Amplitude');
grid on;
%11.filtre butterworth ordre 4
[b, a] = butter(4, fc / (fe / 2), 'low');
[h,w]=freqz(b, a,l);

figure;
subplot(2,1,1)
plot(w/(2*pi)*fe, abs(h));
xlabel('Fréquence ');
ylabel('|H(f)|');
title('Gain Butterworth ordre 4');
grid on;
subplot(2,1,2)
plot(w/(2*pi)*fe, unwrap(angle(h)));
xlabel('Fréquence ');
ylabel('Phase (radians)');
title('Phase');
grid on;
%ordre plus faible mais Phase non linéaire (inadapté pour l’audio haute fidélité)
#Decimation
%1.
s1=s1_hamm;
s2=s2_hamm;
M=2;
N1=length(s1);
N2=length(s2);
fed=fe/M;
s1d=s1(1:M:N1);
s2d=s2(1:M:N2);
S1d=abs(fftshift(fft(s1d, l)));
S2d=abs(fftshift(fft(s2d, l)));
fd=(-l/2:l/2-1)*(fed/l);
%2.
figure;
subplot(2,1,1);
plot(fd,S1d);
title('Spectre de s_{1d}');
xlabel('Fréquence (Hz)');
ylabel('Amplitude');
grid on;
subplot(2,1,2);
plot(fd,S2d);
title('Spectre de s_{2d}');
xlabel('Fréquence (Hz)');
ylabel('Amplitude');
grid on;

#Quantification
%1.
function [xq, rsb] = unifquant(x, Amin, Amax, l)
    L = 2^l;
    q = (Amax - Amin) / L;
    xq = round((x - Amin) / q) * q + Amin;
    error = x - xq;
    rsb = 10 * log10(mean(x.^2) /(q^2/12));
end
%2.
Amin_s1d=min(s1d);
Amax_s1d=max(s1d);
Amin_s2d=min(s2d);
Amax_s2d=max(s2d);
l_values = 2:2:12;
rsb_s1d = zeros(size(l_values));
rsb_s2d = zeros(size(l_values));

for i = 1:length(l_values)
    l = l_values(i);
    [~, rsb_s1d(i)] = unifquant(s1d, Amin_s1d, Amax_s1d, l);
    [~, rsb_s2d(i)] = unifquant(s2d, Amin_s2d, Amax_s2d, l);
end
figure;
plot(l_values, rsb_s1d, 'b');
hold on;
plot(l_values, rsb_s2d, 'r');
grid on;
xlabel('Nombre de bits (l)');
ylabel('RSB (dB)');
legend('s_{1d} (BF)', 's_{2d} (HF)');
title('Évolution du RSB en fonction du nombre de bits');#Pour l ≤ 3, la courbe est non-linéaire :À ces faibles résolutions, l’erreur de quantification devient dominante, et le modèle linéaire ne s’applique plus bien.
#l=12 pour un traitement audio haute fidélité	(aucun bruit n’est perçuaucun bruit n’est perçu)
[s1q,~] = unifquant(s1d, Amin_s1d, Amax_s1d, 12);
[s2q,~] = unifquant(s2d, Amin_s2d, Amax_s2d, 12);
#Interpolation
%1.
L=2;
l=1024;
s1i=zeros(1,L*length(s1q));
s1i(1:L:L*length(s1q))=s1q;
s2i=zeros(1,L*length(s2q));
s2i(1:L:L*length(s2q))=s2q;
S1i=abs(fftshift(fft(s1i,l)));
S2i=abs(fftshift(fft(s2i,l)));
figure;
subplot(2,1,1);
fei=fed*L;
fei=(-l/2:l/2-1)*(fei/l);
plot(fei,S1i);
title('Spectre de s_{1i} (BF suréchantillonnée)');
xlabel('Fréquence (Hz)');
ylabel('Amplitude (dB)');
grid on;
subplot(2,1,2);
plot(fei,S2i);
title('Spectre de s_{2i}(HF suréchantillonnée)');
xlabel('Fréquence (Hz)');
ylabel('Amplitude (dB)');
grid on;
#Filtres de synthèse
%1.
l=1024;
s1r=filter(b_hamm, 1, s1i);
s2r=filter(bh, 1, s2i);
sr=s1r+s2r;
Sr=abs(fftshift(fft(sr,l)));
f=(-l/2:l/2-1)*fe/l;
figure;
plot(f,Sr,'r');
grid on;
hold on;
plot(f, S, 'b');
legend('Signal interpolé','Signal original');
title('Spectre des signaux  S_{r} et S');
xlabel('Fréquence (Hz)');
ylabel('|S(f)|');
grid on;
%% 3.5 Filtres de synthèse - Questions 3, 4 et 5

% Configuration des paramètres à tester
configs = [2, 2; 4, 4;  8, 4; 12, 4;8, 8; 12, 12;];
results = cell(size(configs, 1), 6);  % Stockage des résultats

% Retard total des filtres (ordre 24 × 2 = 48 échantillons)
retard = 48;


%% Traitement pour chaque configuration
for i = 1:size(configs, 1)
    l1 = configs(i, 1);
    l2 = configs(i, 2);

    % Quantification
    [s1q, rsb1] = unifquant(s1d, min(s1d), max(s1d), l1);
    [s2q, rsb2] = unifquant(s2d, min(s2d), max(s2d), l2);

    % Interpolation
    L=2;
    s1i=zeros(1,L*length(s1q));
    s1i(1:L:L*length(s1q))=s1q;
    s2i=zeros(1,L*length(s2q));
    s2i(1:L:L*length(s2q))=s2q;
    % Filtrage de synthèse
    s1r = filter(b_hamm, 1, s1i);
    s2r = filter(bh, 1, s2i);
    sr = s1r + s2r;

    % Ajustement des longueurs (compensation du retard)
    start_idx = retard + 1;
    end_idx = min(length(s), length(sr));
    s_comp = s(start_idx:end_idx);
    sr_comp = sr(start_idx:end_idx);

    % Calcul du RSB
    s_comp = s_comp(:);  % Conversion en vecteur colonne
    sr_comp = sr_comp(:);
    error = s_comp - sr_comp;
    Ps = mean(s_comp.^2);
    Pe = mean(error.^2);

    % Calcul du débit binaire
    debit = (fe / M) * (l1 + l2) / 1000; % en kbps

    results{i, 1} = l1;
    results{i, 2} = l2;
    results{i, 3} = debit;
    results{i, 4} = rsb1;
    results{i, 5} = rsb2;

    %Écoute comparative (à décommenter pour tester)
    %printf("\nConfiguration l1=%d, l2=%d - RSB1=%.1f dB - RSB2=%.1f dB", l1, l2, rsb1, rsb2);
    %soundsc(s, fe); pause(length(s)/fe + 1);
    %soundsc(sr, fe); pause(length(sr)/fe + 1);
end

%% Affichage des résultats
fprintf("\n=== RÉSULTATS COMPARATIFS ===\n");
fprintf("-----------------------------------------------------------\n");
fprintf("l1\tl2\tDébit (kbps)\tRSB BF (dB)\tRSB HF (dB)\n");
fprintf("-----------------------------------------------------------\n");
for i = 1:size(results, 1)
    fprintf("%d\t%d\t%.1f\t\t%.1f\t\t%.1f\n",
            results{i,1}, results{i,2}, results{i,3},
            results{i,4}, results{i,5});
end
